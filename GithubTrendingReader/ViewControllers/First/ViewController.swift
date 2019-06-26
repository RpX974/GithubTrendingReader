//
//  ViewController.swift
//  GithubTrendingReader
//
//  Created by Laurent Grondin on 13/04/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import UIKit

// MARK: - ViewController

class ViewController<Data: Repo, Cell: RepoTableViewCell>: GenericControllerWithTableView<Repo, Cell, HomeViewModel> {
    
    // MARK: - Typealias
    
    typealias ViewModel = HomeViewModel
    typealias Create    = ViewControllerUI

    // MARK: - Deinit
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        log_done()
    }
    
    // MARK: - Views
    
    fileprivate var webView: UIWebView!
    
    fileprivate lazy var activityIndicator                  = Create.activityIndicator()
    fileprivate lazy var languagesTableView                 = Create.languagesTableView(delegate: self)
    fileprivate lazy var search: SearchController<Language> = Create.searchController(delegate: self)
    fileprivate lazy var segmentedControl                   = Create.segmentedControl(selectedIndex: viewModel.getCurrentSince(),
                                                                                      delegate: self)
    
    // MARK: - Properties
    
    override var titleToSet: String? { return Create.Text.titleToSet }
    override var noDataText: String? { return Create.Text.noDataText }
    override var contentInset: UIEdgeInsets {
        return .init(top: segmentedControl.height + 20.0,
                     left: 0,
                     bottom: 10,
                     right: 0)
    }
    
    // MARK: - Constraints
    
    fileprivate var bottomLanguagesTableViewConstraint: Constraint?
    
    // MARK: - Initializers
    
    override func setViewModel(viewModel: HomeViewModel) {
        super.setViewModel(viewModel: viewModel)
        self.viewModel.setDelegate(delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        log_start()
        setupNavigationBar()
        enableKeyboard(true)
        initFakeWebView()
        viewModel.start()
    }
    
    override func addAllSubviews() {
        super.addAllSubviews()
        addSubviews(languagesTableView, segmentedControl)
    }
    
    fileprivate func setupNavigationBar() {
        navigationItem.addSearchController(search)
        navigationItem.setLeftBarButton(image: Create.Image.leftBarButtonImage,
                                        target: self,
                                        action: #selector(changeMode),
                                        tintColor: Themes.current.textColor)
        navigationItem.setRightBarButton(image: Create.Image.rightBarButtonImage,
                                         target: self,
                                         action: #selector(showFavorites),
                                         tintColor: Themes.current.textColor)
        navigationItem.rightBarButtonItems?.append(UIBarButtonItem(customView: activityIndicator))
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        segmentedControl.fillSuperviewSafeAreaLayoutGuide(padding: Create.Rect.segmentedControlInsets).bottom?.isActive = false
        languagesTableView.fillSuperviewSafeAreaLayoutGuide().bottom?.isActive = false
        bottomLanguagesTableViewConstraint = languagesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomLanguagesTableViewConstraint?.isActive = true
    }
    
    fileprivate func initFakeWebView() {
        webView = UIWebView.init(frame: .zero)
        let url = URL(string: Constants.HTML.google)
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
    }
    
    // MARK: - Custom Functions
    
    @objc override func scrollToTop() {
        super.scrollToTop()
        Animator.animate(view: segmentedControl, alpha: 1, completion: nil)
    }
    
    @objc fileprivate func showFavorites() {
        let viewModel = self.viewModel.getFavoritesViewModel()
        let vc = FavoritesViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
        log_info("Pushing to FavoritesViewController")
    }

    @objc fileprivate func changeMode(){
        self.enableDarkMode(bool: !Themes.isDarkModeEnabled)
    }
    
    fileprivate func enableDarkMode(bool: Bool) {
        Themes.changeCurrentTheme(viewController: self)
        activityIndicator.color = Themes.current.textColor
        navigationItem.rightBarButtonItem?.tintColor = Themes.current.textColor
        navigationItem.leftBarButtonItem?.tintColor = Themes.current.textColor
        navigationItem.leftBarButtonItem?.image = Create.Image.leftBarButtonImage
        viewModel.dataSource.forEach { $0.refreshHTML() }
        viewModel.getFavoritesViewModel().refreshHTML()
        if let indexs = tableView.indexPathsForVisibleRows {
            UIView.performWithoutAnimation {
                tableView.reloadRows(at: indexs, with: .none)
            }
        }
        log_info("DarkMode is \(bool ? "enabled" : "disabled")")
    }
    
    // MARK: - Delegate
    // MARK: - TableView
    
    override func setDataSource(_ tableView: UITableView) -> [[Decodable]?]? {
        return viewModel.getTableViewDataSource(type: getTableViewType(tableView))
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, data: Decodable?) {
        switch getTableViewType(tableView) {
        case .languages:
            log_info("Cell tapped at \(indexPath) from LanguagesTableView")
            viewModel.setCurrentLanguage(data: data, indexPath: indexPath)
            if search.isActive == true { search.isActive = false }
        default:
            log_info("Cell tapped at \(indexPath) from defaultTableView")
            showDetails(index: indexPath.item)
        }
    }
    
    func getTableViewType(_ tableView: UITableView) -> TableViewType {
        return tableView == languagesTableView ? .languages : .repo
    }
    
    
    override func setTitleHeaders(_ tableView: UITableView) -> [String]? {
        return viewModel.getTitleHeaders(type: getTableViewType(tableView))
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat? {
        return  tableView == languagesTableView && section == 0 && viewModel.getRecents().count == 0
            ? 0.0
            : tableView.sectionHeaderHeight
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.addShadow(radius: 6, opacity: 0.05)
        header.textLabel?.textColor = Themes.current.textColor
        header.backgroundView?.backgroundColor = Themes.current.color
    }
    
    override func tableViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>, isScrollingDown: Bool) {
        guard scrollView == self.tableView else { return }
        let alpha: CGFloat = isScrollingDown ? 0 : 1
        guard segmentedControl.alpha != alpha else { return }
        Animator.animate(view: segmentedControl, alpha: alpha, completion: nil)
    }
}

// MARK: - Extension
// MARK: - SearchController

extension ViewController: SearchControllerDelegate {
    
    func updateSearchResults<T>(for searchController: UISearchController, filteredData: [T], filtering: Bool) where T: Decodable, T: Encodable {
        guard let data = filteredData as? [Language] else { viewModel.removeAllFilteredData(); return }
        viewModel.setFilteredData(data: data)
        self.reloadLanguagesTableView()
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        search.updateDataToFilter(data: viewModel.getLanguages(type: .all))
        languagesTableView.reloadData()
        segmentedControl.isHidden = true
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        Animator.animate(view: languagesTableView, alpha: 0, duration: 0.3, completion: nil)
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        Animator.animate(view: languagesTableView, alpha: 1, duration: 0.5, completion: nil)
        log_info("LanguagesTableView is currently displayed")
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        segmentedControl.isHidden = false
        log_info("LanguagesTableView is currently hidden")
    }
}

// MARK: - SegmentedControl

extension ViewController: SegmentedControlDelegate {
    
    func indexChanged(_ sender: UISegmentedControl) {
        log_info("Current segmentedControl index: \(sender.selectedSegmentIndex)")
        viewModel.setCurrentSince(index: sender.selectedSegmentIndex)
    }
}
// MARK: - HomeProtocolDelegate

extension ViewController: HomeProtocolDelegate {
    
    func reloadTableView(isUpdating: Bool) {
        let alpha: CGFloat = isUpdating ? 0 : 1
        tableView.reloadData()
        Animator.addCATransition(view: tableView)
        tableView.alpha = alpha
        DispatchQueue.main.async {
            self.segmentedControl.isEnabled = !isUpdating
            self.scrollToTop()
            self.showActivityIndicator(bool: isUpdating)
        }
    }
    
    func reloadLanguagesTableView() {
        languagesTableView.reloadData()
        languagesTableView.scrollToTop(animated: false)
    }
    
    func updateLeftButtonBarTitle(languageName: String?) {
        title = languageName ?? "loading".localized
        log_info("Title updated to \(title ?? "No Title")")
    }
    
    func showActivityIndicator(bool: Bool) {
        bool ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
}

// MARK: - KeyboardDelegate

extension ViewController: KeyboardDelegate {
    func keyboardFrame(_ notification: Notification, frame: CGRect) {
        self.bottomLanguagesTableViewConstraint?.constant = -frame.size.height
    }
}
