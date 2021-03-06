//
//  GenericController+UITableView.swift
//  GithubTrendingReader
//
//  Created by Laurent Grondin on 19/04/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import Foundation
import UIKit

class GenericControllerWithTableView<Data: Repo, Cell: GenericTableViewCell<Data>, ViewModel: GenericDataSourceViewModel<Data>>: UIViewController, TableViewProtocol {
    
    // MARK: - Deinit

    deinit {
        log_done()
    }
    
    // MARK: - Views

    lazy var tableView: TableView<Data, Cell> = TableView(backgroundColor: Themes.current.color,
                                                          estimateRowHeight: 60.0,
                                                          contentInset: self.contentInset,
                                                          enableHighlight: true,
                                                          noDataText: noDataText,
                                                          delegate: self)
    
    // MARK: - Properties

    var noDataText: String? { return nil }
    var contentInset: UIEdgeInsets { return UIEdgeInsets.init(top: 10, left: 0, bottom: 10, right: 0) }

    var viewModel: ViewModel!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Themes.preferredStatusBarStyle
    }
    
    var titleToSet: String? {
        return self.stringClass()
    }
    // MARK: - Closures

    var scrollToIndex: ((Int) -> Void)!
    
    // MARK: - Initializers
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.setViewModel()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(viewModel: ViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.setViewModel(viewModel: viewModel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViewModel(viewModel: ViewModel = ViewModel()) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        log_start()
        setupUI()
        setupConstraints()
        setScrollToIndex()
    }
    
    func setupUI() {
        view.backgroundColor = Themes.current.color
        view.clipsToBounds = true
        extendedLayoutIncludesOpaqueBars = true
        title = titleToSet
        addAllSubviews()
    }
    
    func addAllSubviews() {
        view.addSubview(tableView)
    }

    func setupConstraints() {
        tableView.fillSuperview()
    }
    
    fileprivate func setScrollToIndex() {
        scrollToIndex = { [weak self] index in
            guard let `self` = self else { return }
            self.tableView.scrollToRow(at: IndexPath.init(item: index, section: 0), at: .bottom, animated: true)
            log_info("Parent scrolled to cell at \(index)")
        }
    }
    
    // MARK: - Custom Functions
    
    func showDetails(index: Int) {
        log_info("Cell tapped at \(index)")
        guard let favoritesViewModel = viewModel.getGenericViewModel() as? FavoritesViewModel else { return }
        let vc = DetailsViewController(favoritesViewModel: favoritesViewModel,
                                       repos: viewModel.getDataSource(),
                                       index: index,
                                       scrollToIndex: scrollToIndex)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func scrollToTop() {
        self.tableView.scrollToTop()
    }

    override func setTapGestureAction() -> Selector? {
        return #selector(scrollToTop)
    }

    // MARK: - Delegate
    // MARK: - TableView

    func setDataSource(_ tableView: UITableView) -> [[Decodable]?]? { return viewModel.getListDataSource() }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, cell: UITableViewCell, data: Decodable?) -> UITableViewCell? { return nil }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, data: Decodable?) { showDetails(index: indexPath.item) }
    func setTitleHeaders(_ tableView: UITableView) -> [String]? { return nil }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat? { return nil }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {}
    func tableViewDidScroll(_ scrollView: UIScrollView, isScrollViewDown: Bool) {}
    func tableViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>, isScrollingDown: Bool) {}
}
