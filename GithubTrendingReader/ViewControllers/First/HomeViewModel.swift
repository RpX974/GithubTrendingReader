//
//  HomeViewModel.swift
//  GithubTrendingReader
//
//  Created by Laurent Grondin on 13/04/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import Foundation
import Promises

class HomeViewModel: GenericDataSourceViewModel<Repo> {

    // MARK: - Deinit
    
    deinit {
        log_done()
    }
    
    // MARK: - Constants

    struct PrivateConstants {
        static let defaultLanguage: All = All.init(urlParam: Constants.defaultLanguageUrlParam, name: Constants.defaultLanguage)
        static let defaultSince: SinceIndex = .daily
    }
    
    // MARK: - Properties

    fileprivate weak var delegate: HomeProtocolDelegate?


    fileprivate var filtering = false
    fileprivate var language: Language?

    fileprivate var _currentLanguage: All?
    fileprivate var _currentSince: SinceIndex?
    fileprivate var _recents: [All]?

    fileprivate lazy var favoritesViewModel: FavoritesViewModel = {
        return FavoritesViewModel()
    }()

    fileprivate var filtered = [All]() {
        didSet {
            filtering = filtered.count > 0
        }
    }
    fileprivate var currentLanguage: All {
        get {
            return  _currentLanguage ?? All.retrieve(forKey: Constants.UserDefault.language) ??
                    PrivateConstants.defaultLanguage
        }
        set {
            newValue.save(forKey: Constants.UserDefault.language)
            _currentLanguage = newValue
            self.updateTrending()
        }
    }
    fileprivate var currentSince: SinceIndex {
        get {
            if let since = _currentSince { return since }
            let index = UserDefaults.standard.integer(forKey: Constants.UserDefault.since)
            return SinceIndex(rawValue: index) ?? PrivateConstants.defaultSince
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: Constants.UserDefault.since)
            _currentSince = newValue
            self.updateTrending()
        }
    }
    fileprivate var recents: [All] {
        get {
            return _recents ?? All.retrieveArray(forKey: Constants.UserDefault.recents) ?? []
        }
        set {
            newValue.saveArray(forKey: Constants.UserDefault.recents)
            _recents = newValue
        }
    }
    
    // MARK: - Initializers
    
    required override init() {
        super.init()
    }
    
//    convenience init(delegate: HomeProtocolDelegate) {
//        self.init()
//        self.delegate = delegate
//    }

    func start(){
        getTrending()
            .then { [weak self] in
                guard let `self` = self else { return }
                self.delegate?.updateLeftButtonBarTitle(languageName: self.currentLanguage.name, count: self.dataSource.count)
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

    func setDelegate(delegate: HomeProtocolDelegate) {
        self.delegate = delegate
    }
    
    func appendRecent(recent: All?){
        guard let recent = recent else { return }
        if let index = recents.findIndex(predicate: {$0.name == recent.name}) {
            recents.remove(at: index)
        }
        if recents.count == Constants.maxRecentsCount { recents.removeLast() }
        recents.insert(recent, at: 0)
    }
    
    func updateTrending(data: Decodable?, indexPath: IndexPath) {
        guard var result = data as? All else { return }
        if indexPath.section == 0 && filtering == true {
            result = filtered[indexPath.row]
        }
        appendRecent(recent: result)
        currentLanguage = result
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
    override func getGenericViewModel() -> GenericDataSourceViewModel<Repo>? {
        return getFavoritesViewModel()
    }
    
    func getFavoritesViewModel() -> FavoritesViewModel<Repo> {
        return favoritesViewModel
    }
    
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
            return getListDataSource()
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

    func updateTrending(){
        getTrending()
            .then { [weak self] in
                guard let `self` = self else { return }
                self.delegate?.updateLeftButtonBarTitle(languageName: self.currentLanguage.name, count: self.dataSource.count)
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
                    log_info("All Languages retrieved")
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
    
    func getTrending() -> Promise<()> {
        dataSource.removeAll()
        self.delegate?.updateLeftButtonBarTitle(languageName: nil, count: dataSource.count)
        self.delegate?.reloadTableView(isUpdating: true)
        self.delegate?.showActivityIndicator(bool: true)
        return Promise<()>(on: .global(qos: qosClass), { [weak self] (fullfill, reject) in
            guard let `self` = self else { return }
            API.shared.getTrending(fromLanguage: self.currentLanguage.urlParam, since: self.getSince(), completion: {
                [weak self] (result: Result<Repos>) in
                guard let `self` = self else { return }
                switch result {
                case .success(let data):
                    log_info("\(self.getSince().rawValue.capitalized) repos retrieved from \(self.currentLanguage.name)")
                    self.dataSource.removeAll()
                    self.dataSource.append(contentsOf: data)
                    fullfill(())
                    self.dataSource.forEach({ $0.setUrlString() })
                case .failure(let error):
                    reject(error)
                }
            })
        })
    }
}
