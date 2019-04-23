//
//  LanguageViewModel.swift
//  GithubTrendingReader
//
//  Created by Laurent Grondin on 21/04/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import Foundation
import Promises

class LanguagesViewModel: GenericDataSourceViewModel<Language> {
    
    // MARK: - Typealias

    typealias Data = Language
    typealias RequestResult = AllLanguages

    // MARK: - Deinit
    
    deinit {
        log_done()
    }

    // MARK: - Constants
    
    struct PrivateConstants {
        static let defaultLanguage: Language = Language.init(urlParam: Constants.Languages.defaultLanguageUrlParam, name: Constants.Languages.defaultLanguage)
        static let allLanguages: Language = Language.init(urlParam: Constants.Languages.allLanguagesUrlParam, name: Constants.Languages.allLanguages)
        static let defaultSince: Since = .daily
    }
    
    // MARK: - Properties
    
    fileprivate var popular: Languages = []
    fileprivate var recents: Languages = []
    fileprivate var _currentLanguage: Language?

    fileprivate var currentLanguage: Language {
        get {
            return  _currentLanguage ?? Language.retrieve(forKey: Constants.UserDefault.language) ??
                PrivateConstants.defaultLanguage
        }
        set {
            newValue.save(forKey: Constants.UserDefault.language)
            _currentLanguage = newValue
        }
    }

    // MARK - Initializers
    
    required init() {
        super.init()
        retriveFromCloud()
    }

    func retriveFromCloud() {
        Data.retrieveFromCloud(completion: { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let data):
                self.recents = data
            case .failure(let error):
                log_error(error.localizedDescription)
            }
        })
    }
    
    // MARK: - SETTERS

    func setCurrentLanguage(language: Language) {
        currentLanguage = language
    }
    
    func appendRecent(recent: Language?){
        guard let recent = recent else { return }
        let removed = removeRecent(recent: recent)
        if recents.count == Constants.maxRecentsCount { recents.removeLast() }
        recents.insert(recent, at: 0)
        currentLanguage = recent
        guard let data = removed else { recent.saveInCloud(); return }
        data.updateInCloud()
    }
    
    func removeRecent(recent: Language) -> Language? {
        guard let index = recents.findIndex(predicate: {$0.name == recent.name}) else { return nil }
        let recent = recents.remove(at: index)
        return recent
    }
    
    // MARK: - GETTERS

    func getCurrentLanguage() -> Language {
        return currentLanguage
    }
    
    func getLanguages(type: LanguagesType) -> Languages {
        switch type {
        case .recents:
            return recents
        case .popular:
            return popular
        default:
            return dataSource
        }
    }
    
    func getAllLanguages() -> [[Language]] {
        return [recents, popular, dataSource]
    }
    
    // MARK: - Requests
    
    func start() -> Promise<()>{
        return Promise<()>(on: .global(qos: .background), { (fullfill, reject) in
            API.shared.getAllLanguages(completion: { [weak self] (result: Result<RequestResult>) in
                guard let `self` = self else { return }
                switch result {
                case .success(let data):
                    log_info("All Languages retrieved")
                    self.dataSource = data.all
                    self.popular = data.popular
                    let allLanguages = PrivateConstants.allLanguages
                    self.popular.insert(allLanguages, at: 0)
                    fullfill(())
                case .failure(let error):
                    reject(error)
                }
            })
        })
    }
}
