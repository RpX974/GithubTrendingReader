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

    fileprivate var favorites: [Data] {
        get {
            if dataSource.count == 0 { dataSource = Data.retrieveArray(forKey: Constants.UserDefault.favorites) ?? [] }
            return dataSource
        }
        set {
            newValue.saveArray(forKey: Constants.UserDefault.favorites)
            dataSource = newValue
        }
    }
    
    // MARK - Initializers    
    // MARK: - SETTER
    
    func refreshHTML(){
        self.favorites.forEach({ $0.refreshHTML() })
    }

    func addFavorite(repo: Data?) -> Bool {
        guard checkIfFavoriteExists(repo: repo) == false, let data = repo else {
            removeFavorite(repo: repo)
            log_info("Repo removed from Favorites")
            return false
        }
        removeFavorite(repo: data)
        favorites.insert(data, at: 0)
        log_info("Repo added to Favorites")
        return true
    }
    
    func removeFavorite(repo: Data?) {
        guard let data = repo, let index = favorites.findIndex(predicate: {$0.url == data.url}) else { return }
        favorites.remove(at: index)
    }

    // MARK: - GETTER
        
    func checkIfFavoriteExists(repo: Data?) -> Bool {
        guard let data = repo else { return true }
        return favorites.contains(where: {$0.url == data.url }) ? true : false
    }
    
    override func getDataFrom(index: Int) -> Data? {
        return index < favorites.count ? favorites[index] : nil
    }
    
    override func getDataSource() -> [Data] {
        return favorites
    }
    
    override func getListDataSource() -> [[Data]?] {
        return [favorites]
    }
}
