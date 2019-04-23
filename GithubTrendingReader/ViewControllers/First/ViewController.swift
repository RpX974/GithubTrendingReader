//
//  ViewController.swift
//  GithubTrendingReader
//
//  Created by Laurent Grondin on 13/04/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import UIKit
import TinyConstraints

// MARK: - Constants

struct HomeConstants {
    static let titleToSet: String = "loading".localized
    static let noDataText: String = "no_repo".localized
    static let cellSize: CGFloat = 80.0
    static let segmentedControlItems: [String] = ["daily".localized, "weekly".localized, "monthly".localized]
    static let darkModeEnabledImage: UIImage? = "moon".image
    static let darkModeDisabledImage: UIImage? = "moonFull".image
    static let rightBarButtonImage: UIImage? = "favorite_full".image
    static var leftBarButtonImage: UIImage? {
        return (Constants.isDarkModeEnabled ? HomeConstants.darkModeEnabledImage : HomeConstants.darkModeDisabledImage)
    }
    
    static func titleFormat(string: String?) -> String { return string != nil ? String(format: "trending_format".localized, string ?? "", "trending".localized) : "loading".localized }
}

// MARK: - ViewController

class ViewController<Data: Repo, Cell: RepoTableViewCell>: GenericControllerWithTableView<Repo, Cell, HomeViewModel> {
    
    typealias ViewModel = HomeViewModel
    
    // MARK: - Deinit
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        log_done()
    }
    
    // MARK: - Views
    
    fileprivate var webView: UIWebView!
    
    fileprivate lazy var segmentedControl: SegmentedControl = {
        let sc = SegmentedControl.init(items: HomeConstants.segmentedControlItems, backgroundColor: view.getModeColor(), tintColor: view.getModeTextColor(), textAttributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14, weight: .semibold)], selectedIndex: viewModel.getCurrentSince())
        sc.delegate = self
        return sc
    }()
    fileprivate lazy var search: SearchController<Language> = {
        let search = SearchController<Language>(placeholder: "other_language".localized, tintColor: view.getModeTextColor(), obscuresBackgroundDuringPresentation: false)
        search.globalDelegate = self
        return search
    }()
    fileprivate lazy var languagesTableView: TableView<Language, LanguageTableViewCell> = {
        let tableView = TableView<Language, LanguageTableViewCell>(backgroundColor: view.getModeColor(),
                                                              estimateRowHeight: 44.0,
                                                              sectionHeaderHeight: 44.0,
                                                              alpha: 0.0)
        tableView.globalDelegate = self
        return tableView
    }()
    fileprivate lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator.color = view.getModeTextColor()
        return activityIndicator
    }()
    
    // MARK: - Properties
    
    override var titleToSet: String? { return HomeConstants.titleToSet }
    override var noDataText: String? { return HomeConstants.noDataText }
    override var contentInset: UIEdgeInsets {
        return .init(top: segmentedControl.height + 20.0,
                     left: 0,
                     bottom: 10,
                     right: 0)
    }
    
    // MARK: - Constraints
    
    fileprivate var bottomLanguagesTableViewConstraint: Constraint?
    fileprivate var topSegmentedControlConstraint: Constraint?
    
    // MARK - Initializers
    
    override func setViewModel(viewModel: HomeViewModel) {
        super.setViewModel(viewModel: viewModel)
        self.viewModel.setDelegate(delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        log_start()
        setupNavigationBar()
        setupNotificationKeyboard()
        initFakeWebView()
        viewModel.start()
    }
    
    override func addAllSubviews() {
        super.addAllSubviews()
        view.addSubview(languagesTableView)
        view.addSubview(segmentedControl)
        view.addSubview(languagesTableView)
    }
    
    fileprivate func setupNavigationBar(){
        navigationItem.addSearchController(search)
        navigationItem.setLeftBarButton(image: HomeConstants.leftBarButtonImage,
                                        target: self,
                                        action: #selector(changeMode),
                                        tintColor: view.getModeTextColor())
        navigationItem.setRightBarButton(image: HomeConstants.rightBarButtonImage,
                                         target: self,
                                         action: #selector(showFavorites),
                                         tintColor: view.getModeTextColor())
        navigationItem.rightBarButtonItems?.append(UIBarButtonItem(customView: activityIndicator))
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        segmentedControl.edgesToSuperview(excluding: [.top, .bottom], insets: .init(top: 0, left: 16, bottom: 0, right: 16), usingSafeArea: true)
        topSegmentedControlConstraint = segmentedControl.topToSuperview(offset: 16.0, usingSafeArea: true)
        languagesTableView.edgesToSuperview(excluding: .bottom, usingSafeArea: true)
        bottomLanguagesTableViewConstraint = languagesTableView.bottomToSuperview()
    }
    
    fileprivate func setupNotificationKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveKeyboardNotificationObserver(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
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
    
    @objc fileprivate func showFavorites(){
        let viewModel = self.viewModel.getFavoritesViewModel()
        let vc = FavoritesViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
        log_info("Pushing to FavoritesViewController")
    }
    
    @objc fileprivate func didReceiveKeyboardNotificationObserver(_ notification: Notification) {
        let userInfo = notification.userInfo
        let keyboardFrame = (userInfo!["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
        self.bottomLanguagesTableViewConstraint?.constant = -keyboardFrame.size.height
    }
    
    @objc fileprivate func changeMode(){
        self.enableDarkMode(bool: !Constants.isDarkModeEnabled)
    }
    
    fileprivate func enableDarkMode(bool: Bool) {
        ClassHelper.changeModeColor(isDarkModeEnabled: bool, vc: self)
        activityIndicator.color = view.getModeTextColor()
        navigationItem.rightBarButtonItem?.tintColor = view.getModeTextColor()
        navigationItem.leftBarButtonItem?.tintColor = view.getModeTextColor()
        navigationItem.leftBarButtonItem?.image = HomeConstants.leftBarButtonImage
        viewModel.dataSource.forEach{ $0.refreshHTML() }
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
        header.textLabel?.textColor = view.getModeTextColor()
        header.backgroundView?.backgroundColor = view.getModeColor()
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
    
    func updateSearchResults<T>(for searchController: UISearchController, filteredData: [T], filtering: Bool) where T : Decodable, T : Encodable {
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
    
    func indexChanged(_ sender: UISegmentedControl){
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
    
    func reloadLanguagesTableView(){
        languagesTableView.reloadData()
        languagesTableView.scrollToTop(animated: false)
    }
    
    func updateLeftButtonBarTitle(languageName: String?){
        title = languageName ?? "loading".localized
        log_info("Title updated to \(title ?? "No Title")")
    }
    
    func showActivityIndicator(bool: Bool) {
        bool ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
}
