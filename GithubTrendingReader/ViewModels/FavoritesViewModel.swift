//
//  FavoritesViewModel.swift
//  GithubTrendingReader
//
//  Created by Laurent Grondin on 18/04/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import Foundation

class FavoritesViewModel: GenericDataSourceViewModel<Repo> {

    typealias Data = Repo
    // MARK: - Deinit
    
    deinit {
        log_done()
    }
    
    // MARK: - Properties
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
                self.dataSource = data
            case .failure(let error):
                log_error(error.localizedDescription)
            }
        })
    }
    
    // MARK: - SETTER
    
    func refreshHTML(){
        self.dataSource.forEach({ $0.refreshHTML() })
    }

    func addFavorite(repo: Data?) -> Bool {
        guard checkIfFavoriteExists(repo: repo) == false, let data = repo else {
            removeFavorite(repo: repo)
            log_info("Repo removed from Favorites")
            return false
        }
        removeFavorite(repo: data)
        dataSource.insert(data, at: 0)
        log_info("Repo added to Favorites")
        data.saveInCloud()
        return true
    }
    
    func removeFavorite(repo: Data?) {
        guard let data = repo, let index = dataSource.findIndex(predicate: {$0.url == data.url}) else { return }
        data.removeFromCloud()
        dataSource.remove(at: index)
    }

    // MARK: - GETTER
    
    func checkIfFavoriteExists(repo: Data?) -> Bool {
        guard let data = repo else { return true }
        return dataSource.contains(where: {$0.url == data.url }) ? true : false
    }
}
