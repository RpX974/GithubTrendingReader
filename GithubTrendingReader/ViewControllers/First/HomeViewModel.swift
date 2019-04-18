//
//  HomeViewModel.swift
//  GithubTrendingReader
//
//  Created by Laurent Grondin on 13/04/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import Foundation
import Promises

enum TableViewType {
    case repo, languages
}

enum LanguagesType {
    case recents, popular, all
}

class HomeViewModel: GenericDataSourceViewModel<Repo> {
    
    // MARK: - Properties

    weak var delegate: HomeProtocolDelegate?
    
    fileprivate var filtering = false
    fileprivate var language: Language?

    fileprivate var filtered = [All]() {
        didSet {
            filtering = filtered.count > 0
        }
    }
    fileprivate var currentLanguage: All? {
        get {
            guard let data = UserDefaults.standard.data(forKey: Constants.UserDefault.language) else {
                return All.init(urlParam: Constants.defaultLanguageUrlParam, name: Constants.defaultLanguage)
            }
            return try? JSONDecoder().decode(All.self, from: data)
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            UserDefaults.standard.set(data, forKey: Constants.UserDefault.language)
        }
    }
    fileprivate var currentSince: SinceIndex {
        get {
            let index = UserDefaults.standard.integer(forKey: Constants.UserDefault.since)
            return SinceIndex(rawValue: index) ?? .daily
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: Constants.UserDefault.since)
            self.updateTrending()
        }
    }
    fileprivate var recents = [All]() {
        didSet {
            let value = recents.compactMap({ try? JSONEncoder().encode($0) })
            UserDefaults.standard.setValue(value, forKey: "recents")
        }
    }
    
    // MARK: - Initializers
    
    required init(delegate: HomeProtocolDelegate) {
        super.init()
        self.delegate = delegate
    }

    func start(){
        getRecentsFromCache()
        getTrending()
            .then { [weak self] in
                guard let `self` = self else { return }
                self.delegate?.updateLeftButtonBarTitle(languageName: self.currentLanguage?.name, count: self.dataSource.count)
                self.delegate?.reloadTableView(isUpdating: false)
            }
            .catch { error in
                log_error(error.localizedDescription)
        }
        getAllLanguages()
            .then { [weak self] in
                guard let `self` = self else { return }
                self.delegate?.reloadLanguagesTableView()
            }
            .catch { error in
                log_error(error.localizedDescription)
        }
    }
    
    // MARK: - Custom Functions
    // MARK: - SETTERS

    func appendRecent(recent: All?){
        guard let recent = recent else { return }
        if let index = recents.findIndex(predicate: {$0.name == recent.name}) {
            recents.remove(at: index)
        }
        if recents.count == Constants.maxRecentsCount { recents.removeLast() }
        recents.insert(recent, at: 0)
    }
    
    func updateTrending(data: Decodable?, indexPath: IndexPath) {
        var result: All? = data as? All
        if indexPath.section == 0 && filtering == true {
            result = filtered[indexPath.row]
        }
        appendRecent(recent: result)
        currentLanguage = result
        updateTrending()
    }
    
    func removeAllFilteredData(){
        filtered.removeAll()
    }
    
    func setFilteredData(data: [All]){
        removeAllFilteredData()
        filtered.append(contentsOf: data)
    }
    
    func setCurrentSince(index: Int){
        switch index {
        case 1:
            currentSince = .weekly
        case 2:
            currentSince = .monthly
        default:
            currentSince = .daily
        }
    }
    
    // MARK: - GETTER
    
    func getCurrentSince() -> Int {
        return currentSince.rawValue
    }
    
    func getLanguages(type: LanguagesType) -> [All]? {
        switch type {
        case .recents:
            return recents
        case .popular:
            return language?.popular
        default:
            return language?.all
        }
    }
    
    func getRecents() -> [All] {
        return recents
    }
    
    func getTableViewDataSource(type: TableViewType) -> [[Decodable]?]? {
        switch type {
        case .languages:
            return filtering ? [filtered] : [recents, language?.popular, language?.all]
        default:
            return [dataSource]
        }
    }
    
    func getTitleHeaders(type: TableViewType) -> [String]? {
        switch type {
        case .languages:
            return [filtering ? String(format: "results".localized, filtered.count)
                : String(format: "recents".localized, recents.count),
                    String(format: "populars".localized, language?.popular.count ?? 0),
                    String(format: "all_languages".localized, language?.all.count ?? 0)]
        default:
            return nil
        }
    }
    
    func getSince() -> Since {
        switch currentSince {
        case .daily:
            return .daily
        case .weekly:
            return .weekly
        case .monthly:
            return .monthly
        }
    }
    
    // MARK: - Requests
    
    func getRecentsFromCache(){
        guard let data = UserDefaults.standard.array(forKey: "recents") as? [Data] else { return }
        recents = data.compactMap({ try? JSONDecoder().decode(All.self, from: $0) })
    }

    func updateTrending(){
        getTrending()
            .then { [weak self] in
                guard let `self` = self else { return }
                self.delegate?.updateLeftButtonBarTitle(languageName: self.currentLanguage?.name, count: self.dataSource.count)
                self.delegate?.reloadTableView(isUpdating: false)
            }
            .catch { error in
                log_error(error.localizedDescription)
        }
    }
    
    func getAllLanguages() -> Promise<()>{
        return Promise<()>(on: .global(qos: .background), { (fullfill, reject) in
            API.shared.getAllLanguages(completion: { [weak self] (result: Result<Language>) in
                guard let `self` = self else { return }
                switch result {
                case .success(let data):
                    log_info("Languages retrieved")
                    self.language = data
                    let allLanguages = All.init(urlParam: Constants.defaultLanguageUrlParam,
                                                name: Constants.defaultLanguage)
                    self.language?.popular.insert(allLanguages, at: 0)
                    fullfill(())
                case .failure(let error):
                    reject(error)
                }
            })
        })
    }
    
    func getTrending(language: String = Constants.defaultLanguageUrlParam) -> Promise<()> {
        dataSource.removeAll()
        self.delegate?.updateLeftButtonBarTitle(languageName: nil, count: dataSource.count)
        self.delegate?.reloadTableView(isUpdating: true)
        self.delegate?.showActivityIndicator(bool: true)
        return Promise<()>(on: .global(qos: qosClass), { [weak self] (fullfill, reject) in
            guard let `self` = self else { return }
            API.shared.getTrending(fromLanguage: self.currentLanguage?.urlParam ?? language, since: self.getSince(), completion: {
                [weak self] (result: Result<Repos>) in
                guard let `self` = self else { return }
                switch result {
                case .success(let data):
                    log_info("Repos retrieved")
                    self.dataSource = data
                    fullfill(())
                    self.dataSource.forEach({ $0.setUrlString() })
                case .failure(let error):
                    reject(error)
                }
            })
        })
    }
}
