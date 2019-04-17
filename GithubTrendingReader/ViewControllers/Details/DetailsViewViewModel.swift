//
//  DetailsViewViewModel.swift
//  GithubTrendingReader
//
//  Created by Laurent Grondin on 17/04/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import Foundation

class DetailsViewViewModel: GenericDataSourceViewModel<Repo> {
    
    // MARK: - Properties
    
    fileprivate var currentIndex: Int = 0 {
        didSet {
            let title = getDataFrom(index: currentIndex)?.name
            delegate?.updateTitle(title: title)
        }
    }

    weak var delegate: DetailsViewProtocolDelegate?
    
    // MARK: - Initializers
    
    required init(delegate: DetailsViewProtocolDelegate) {
        super.init()
        self.delegate = delegate
    }
    
    // MARK: - Custom Functions
    
    func getCurrentIndex() -> Int {
        return currentIndex
    }

    func setCurrentIndex(index: Int){
        currentIndex = index
    }
    
    func setDataSource(data: [Repo]){
        dataSource.removeAll()
        dataSource.append(contentsOf: data)
    }
    
    func getDataFromCurrentIndex() -> Repo?{
        return getDataFrom(index: currentIndex)
    }
    
    func getCollectionViewDataSource() -> [[Repo]?]?{
        return [dataSource]
    }
}
