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
        struct Format {
            static func recents(count: Int) -> String { return String(format: "recents".localized, count) }
            static func populars(count: Int) -> String { return String(format: "populars".localized, count) }
            static func all(count: Int) -> String { return String(format: "all_languages".localized, count) }
        }
    }
    
    // MARK: - Properties
    
    fileprivate weak var delegate: HomeProtocolDelegate?
    
    fileprivate let repoViewModel           = RepoViewModel()
    fileprivate let languagesViewModel      = LanguagesViewModel()
    fileprivate let favoritesViewModel      = FavoritesViewModel()
//    fileprivate lazy var favoritesViewModel : FavoritesViewModel = { return FavoritesViewModel() }()
    
    fileprivate var _currentSince   : Since?
    fileprivate var filtering       = false
    fileprivate var filtered        = Languages() { didSet { filtering = filtered.count > 0 } }
    fileprivate var currentLanguage : Language {
        get { return languages.getCurrentLanguage() }
        set {
            self.appendRecent(recent: newValue)
            getTrending()
        }
    }
    fileprivate var currentSince    : Since {
        get {
            if let since = _currentSince { return since }
            let index = UserDefaults.standard.integer(forKey: Constants.UserDefault.since)
            return Since.with(index: index)
        }
        set {
            UserDefaults.standard.set(newValue.asInt(), forKey: Constants.UserDefault.since)
            _currentSince = newValue
            getTrending()
        }
    }
    
    var languages: LanguagesViewModel { return languagesViewModel }
    var favorites: FavoritesViewModel { return favoritesViewModel }
    
    override var dataSource: [Repo] {
        get { return repoViewModel.getDataSource() }
        set { repoViewModel.dataSource = newValue }
    }
    
    // MARK: - Initializers
    
    
    // MARK: - Start
    
    func start(){
        getTrending()
        getLanguages()
    }
    
    // MARK: - Requests
    
    func getTrending() {
        repoViewModel.getTrending(with: currentLanguage, since: currentSince)
            .then { [weak self] in
                guard let `self` = self else { return }
                self.delegate?.updateLeftButtonBarTitle(languageName: self.currentLanguage.name)
                self.delegate?.reloadTableView(isUpdating: false)
                self.dataSource.forEach({ $0.createHTML() })
            }
            .catch { error in
                log_error(error.localizedDescription)
        }
        delegate?.updateLeftButtonBarTitle(languageName: nil)
        delegate?.reloadTableView(isUpdating: true)
    }
    
    func getLanguages() {
        languages.start()
            .then { [weak self] in
                guard let `self` = self else { return }
                self.delegate?.reloadLanguagesTableView()
            }
            .catch { error in
                log_error(error.localizedDescription)
        }
    }
    
    // MARK: - SETTERSfa
    
    func setDelegate(delegate: HomeProtocolDelegate) {
        self.delegate = delegate
    }
    
    func appendRecent(recent: Language?){
        languages.appendRecent(recent: recent)
    }
    
    func setCurrentLanguage(data: Decodable?, indexPath: IndexPath) {
        guard var result = data as? Language else { return }
        if indexPath.section == 0 && filtering == true {
            result = filtered[indexPath.row]
        }
        currentLanguage = result
    }
    
    func setFilteredData(data: [Language]){
        removeAllFilteredData()
        filtered.append(contentsOf: data)
    }
    
    func removeAllFilteredData(){
        filtered.removeAll()
    }
    
    func setCurrentSince(index: Int){
        currentSince = Since.with(index: index)
    }
    
    // MARK: - GETTER
    
    override func getGenericViewModel() -> GenericDataSourceViewModel<Repo>? {
        return getFavoritesViewModel()
    }
    
    func getFavoritesViewModel() -> FavoritesViewModel {
        return favoritesViewModel
    }
    
    func getCurrentSince() -> Int {
        return currentSince.asInt()
    }
    
    func getLanguages(type: LanguagesType) -> [Language]? {
        return languages.getLanguages(type: type)
    }
    
    func getRecents() -> [Language] {
        return languages.getLanguages(type: .recents)
    }
    
    func getTableViewDataSource(type: TableViewType) -> [[Decodable]?]? {
        switch type {
        case .languages:
            return filtering ? [filtered] : languages.getAllLanguages()
        default:
            return getListDataSource()
        }
    }
    
    func getTitleHeaders(type: TableViewType) -> [String]? {
        switch type {
        case .languages:
            return [filtering ? String(format: "results".localized, filtered.count) :
                PrivateConstants.Format.recents(count: languages.getLanguages(type: .recents).count),
                    PrivateConstants.Format.populars(count: languages.getLanguages(type: .popular).count),
                    PrivateConstants.Format.all(count: languages.getLanguages(type: .all).count)]
        default:
            return nil
        }
    }
}
