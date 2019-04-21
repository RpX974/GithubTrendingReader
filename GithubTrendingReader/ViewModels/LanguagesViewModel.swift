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
        static let defaultLanguage: Language = Language.init(urlParam: Constants.defaultLanguageUrlParam, name: Constants.defaultLanguage)
        static let defaultSince: Since = .daily
    }
    
    // MARK: - Properties
    
    fileprivate var popular: Languages = []
    fileprivate var _recents: Languages?
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

    fileprivate var recents: Languages {
        get {
            return _recents ?? Language.retrieveArray(forKey: Constants.UserDefault.recents) ?? []
        }
        set {
            newValue.saveArray(forKey: Constants.UserDefault.recents)
            _recents = newValue
        }
    }

    // MARK: - SETTERS

    func setCurrentLanguage(language: Language) {
        currentLanguage = language
    }
    
    func appendRecent(recent: Language?){
        guard let recent = recent else { return }
        if let index = recents.findIndex(predicate: {$0.name == recent.name}) {
            recents.remove(at: index)
        }
        if recents.count == Constants.maxRecentsCount { recents.removeLast() }
        recents.insert(recent, at: 0)
        currentLanguage = recent
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
                    let allLanguages = Language.init(urlParam: Constants.defaultLanguageUrlParam,
                                                     name: Constants.defaultLanguage)
                    self.popular.insert(allLanguages, at: 0)
                    fullfill(())
                case .failure(let error):
                    reject(error)
                }
            })
        })
    }
}
