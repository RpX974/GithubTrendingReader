//
//  SearchViewController.swift
//  GithubTrendingReader
//
//  Created by Laurent Grondin on 16/04/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Protocol

protocol SearchControllerDelegate: class {
    func willPresentSearchController(_ searchController: UISearchController)
    func willDismissSearchController(_ searchController: UISearchController)
    func updateSearchResults<T: Codable>(for searchController: UISearchController, filteredData: [T], filtering: Bool)
}

// MARK: - SearchController

class SearchController<T: Codable>: UISearchController, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    
    // MARK: - Properties

    fileprivate var dataToFilter: [T]?
    fileprivate var filtering: Bool = false
    fileprivate var valueToFilter: String = "name"

    weak var globalDelegate: SearchControllerDelegate?
    
    // MARK - Initializers

    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(searchResultsController: UIViewController? = nil, placeholder: String?, tintColor: UIColor?, obscuresBackgroundDuringPresentation: Bool = true, dataToFilter: [T]? = nil) {
        self.init(searchResultsController: searchResultsController)
        
        self.searchResultsUpdater = self
        self.searchBar.delegate = self
        self.delegate = self
        self.searchBar.placeholder = placeholder
        self.obscuresBackgroundDuringPresentation = obscuresBackgroundDuringPresentation
        self.dataToFilter = dataToFilter
        guard let tintColor = tintColor else { return }
        self.searchBar.tintColor = tintColor
    }
    
    // MARK: - Custom Functions

    func updateDataToFilter(data: [T]?){
        self.dataToFilter = data
    }
    
    // MARK: - Delegation
    
    func willPresentSearchController(_ searchController: UISearchController) {
        self.globalDelegate?.willPresentSearchController(searchController)
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        self.globalDelegate?.willDismissSearchController(searchController)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        var filtered: [T] = []
        filtering = false
        
        if let text = self.searchBar.text, !text.isEmpty {
            
            filtered = dataToFilter?.filter({ (value) -> Bool in
                switch value {
                case (let string as String):
                    log_info("String")
                    return string.lowercased().contains(text.lowercased())
                default:
                    log_info("Default")
                    guard let dict = value.dictionary, let string = dict[valueToFilter] as? String else { return false }
                    return string.lowercased().contains(text.lowercased())
                }
            }) ?? []
            filtering = true
        }
        self.globalDelegate?.updateSearchResults(for: searchController, filteredData: filtered, filtering: filtering)
    }
}

// MARK: - Extension

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}

extension UINavigationItem {
    func addSearchController(_ searchController: UISearchController?, hidesSearchBarWhenScrolling: Bool = false) {
        self.searchController = searchController
        self.hidesSearchBarWhenScrolling = hidesSearchBarWhenScrolling
    }
}
