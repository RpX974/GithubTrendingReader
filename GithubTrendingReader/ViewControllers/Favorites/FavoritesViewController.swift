//
//  FavoritesViewController.swift
//  GithubTrendingReader
//
//  Created by Laurent Grondin on 18/04/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import Foundation
import UIKit


// MARK: - Constants

struct FavoritesConstants {
    static let titleToSet: String = "favorites".localized
    static let noDataText: String = "no_favorites".localized
}

// MARK: - FavoritesViewController

class FavoritesViewController<Cell: RepoTableViewCell, ViewModel: FavoritesViewModel> : GenericControllerWithTableView<Repo, Cell, ViewModel> {
    
    // MARK: - Deinit

    deinit {
        log_done()
    }
    
    // MARK: - Properties
    
    override var titleToSet: String? { return FavoritesConstants.titleToSet }
    override var noDataText: String? { return FavoritesConstants.noDataText }
    
    // MARK - Initializers

    override func viewDidLoad() {
        super.viewDidLoad()
        log_start()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, cell: UITableViewCell, data: Decodable?) -> UITableViewCell? {
        guard let newCell = cell as? Cell else { return nil }
        newCell.starTodayStackView.isHidden = true
        return newCell
    }
}
