//
//  GenericDataSourceViewModel.swift
//  Way
//
//  Created by Laurent Grondin on 29/03/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import Foundation

class GenericDataSourceViewModel<Data: Codable> {
    
    // MARK: - Deinit

    deinit {
        log_done()
    }

    // MARK: - Properties

    var qosClass: DispatchQoS.QoSClass = .userInitiated
    var dataSource = [Data]()
    var numberOfItems: Int { return dataSource.count }

    // MARK: - Custom Functions
    // MARK: - GETTER

    func getDataSource() -> [Data] {
        return dataSource
    }
    
    func getListDataSource() -> [[Data]?] {
        return [dataSource]
    }
    
    func getDataFrom(indexPath: IndexPath) -> Data? {
        let index = indexPath.row
        return index < dataSource.count ? dataSource[index] : nil
    }
    
    func getDataFrom(index: Int) -> Data? {
        return index < dataSource.count ? dataSource[index] : nil
    }
    
    func getGenericViewModel() -> GenericDataSourceViewModel<Data>? {
        return self
    }
    
}
