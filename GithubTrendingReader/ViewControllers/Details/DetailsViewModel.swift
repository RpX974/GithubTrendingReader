//
//  DetailsViewViewModel.swift
//  GithubTrendingReader
//
//  Created by Laurent Grondin on 17/04/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import Foundation

class DetailsViewModel: GenericDataSourceViewModel<Repo> {
    
    // MARK: - Typealiast
    
    typealias Data = Repo
    
    // MARK: - Deinit
    
    deinit {
        log_done()
    }
    
    // MARK: - Properties
    
    weak var delegate: DetailsViewProtocolDelegate?

    fileprivate var currentIndex: Int = 0 {
        didSet {
            let title = getDataFrom(index: currentIndex)?.name
            delegate?.updateTitle(title: title)
        }
    }
        
    // MARK: - Initializers
    
    required init(delegate: DetailsViewProtocolDelegate) {
        super.init()
        self.delegate = delegate
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    // MARK: - Custom Functions
    // MARK: - SETTER
    
    func setCurrentIndex(index: Int) {
        currentIndex = index
    }
    
    func setDataSource(data: [Data]) {
        dataSource.removeAll()
        dataSource.append(contentsOf: data)
    }
    
    // MARK: - GETTER
    
    func getCurrentIndex() -> Int {
        return currentIndex
    }
    
    func getDataFromCurrentIndex() -> Data? {
        return getDataFrom(index: currentIndex)
    }
}
