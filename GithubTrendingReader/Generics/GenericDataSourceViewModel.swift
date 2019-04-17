//
//  GenericDataSourceViewModel.swift
//  Way
//
//  Created by Laurent Grondin on 29/03/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import Foundation

class GenericDataSourceViewModel<T: Decodable> {
    
    // MARK: - Deinit

    deinit {
        log_done()
    }

    // MARK: - Properties

    var qosClass: DispatchQoS.QoSClass = .userInitiated
    var dataSource = [T]()
    
    // MARK: - Custom Functions

    var numberOfItems: Int {
        return dataSource.count
    }
    
    func getDataFrom(indexPath: IndexPath) -> T? {
        let index = indexPath.row
        return index < dataSource.count ? dataSource[index] : nil
    }
    
    func getDataFrom(index: Int) -> T? {
        return index < dataSource.count ? dataSource[index] : nil
    }
}
