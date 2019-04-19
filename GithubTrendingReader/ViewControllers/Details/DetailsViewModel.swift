//
//  DetailsViewViewModel.swift
//  GithubTrendingReader
//
//  Created by Laurent Grondin on 17/04/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import Foundation

class DetailsViewModel: GenericDataSourceViewModel<Repo> {
    
    // MARK: - Deinit

    deinit {
        log_done()
    }
    
    // MARK: - Properties
    
    fileprivate var currentIndex: Int = 0 {
        didSet {
            let title = getDataFrom(index: currentIndex)?.name
            delegate?.updateTitle(title: title)
        }
    }

    var favorites = [Repo]()
    
    weak var delegate: DetailsViewProtocolDelegate?
    
    // MARK: - Initializers
    
    required init(delegate: DetailsViewProtocolDelegate) {
        super.init()
        self.delegate = delegate
    }
    
    // MARK: - Custom Functions
    // MARK: - SETTER

    func setCurrentIndex(index: Int){
        currentIndex = index
    }
    
    func setDataSource(data: [Repo]){
        dataSource.removeAll()
        dataSource.append(contentsOf: data)
    }
    
    // MARK: - GETTER

    func getCurrentIndex() -> Int {
        return currentIndex
    }
    
    func getDataFromCurrentIndex() -> Repo?{
        return getDataFrom(index: currentIndex)
    }
    
    func isFavorite() -> Bool {
        guard let data = getDataFromCurrentIndex() else { return false }
        return favorites.contains(where: { $0.urlString == data.urlString})
    }
}
