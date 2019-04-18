//
//  ViewController.swift
//  GithubTrendingReader
//
//  Created by Laurent Grondin on 13/04/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import UIKit
import TinyConstraints

class ViewController: UIViewController {

    // MARK: - Deinit

    deinit {
        NotificationCenter.default.removeObserver(self)
        log_done()
    }
    
    // MARK: - Constants
    
    struct PrivateConstants {
        static let cellSize: CGFloat = 80.0
        static let segmentedControlItems: [String] = ["daily".localized, "weekly".localized, "monthly".localized]
        static let darkModeEnabledImage: UIImage? = "moon".image
        static let darkModeDisabledImage: UIImage? = "moonFull".image
        static var leftBarButtonImage: UIImage? {
            return (Constants.isDarkModeEnabled ? PrivateConstants.darkModeEnabledImage : PrivateConstants.darkModeDisabledImage)
        }
        
        static func titleFormat(string: String?) -> String { return string != nil ? String(format: "trending_format".localized, string ?? "", "trending".localized) : "loading".localized }
    }
    
    // MARK: - Views
    
    fileprivate var webView: UIWebView!

    fileprivate lazy var segmentedControl: SegmentedControl = {
        let sc = SegmentedControl.init(items: PrivateConstants.segmentedControlItems, backgroundColor: view.getModeColor(), tintColor: view.getModeTextColor(), textAttributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14, weight: .semibold)], selectedIndex: viewModel.getCurrentSince())
        sc.delegate = self
        return sc
    }()
    fileprivate lazy var search: SearchController<All> = {
        let search = SearchController<All>(placeholder: "other_language".localized, tintColor: view.getModeTextColor(), obscuresBackgroundDuringPresentation: false)
        search.globalDelegate = self
        return search
    }()
    fileprivate lazy var tableView: TableView<Repo, RepoTableViewCell> = {
        let tableView = TableView<Repo, RepoTableViewCell>(backgroundColor: view.getModeColor(),
                                  estimateRowHeight: 60.0,
                                  contentInset: .init(top: segmentedControl.height + 20.0, left: 0, bottom: 10, right: 0),
                                  enableHighlight: true,
                                  noDataText: "no_repo".localized)
        tableView.globalDelegate = self
        return tableView
    }()
    fileprivate lazy var languagesTableView: TableView<All, LanguageTableViewCell> = {
        let tableView = TableView<All, LanguageTableViewCell>(backgroundColor: view.getModeColor(),
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

    fileprivate var lastYOffSet: CGFloat = 0.0
    
    fileprivate lazy var viewModel = HomeViewModel.init(delegate: self)

    // MARK: - Constraints

    fileprivate var bottomLanguagesTableViewConstraint: Constraint?
    fileprivate var topSegmentedControlConstraint: Constraint?

    // MARK - Closures

    fileprivate var scrollToIndex: ((Int) -> Void)!

    // MARK: - View Configuration

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        setupNotificationKeyboard()
        setScrollToIndex()
        initFakeWebView()
        viewModel.start()
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        segmentedControl.addShadow(radius: 5, opacity: 0.1)
        tableView.setScrollIndicatorColor(color: view.getModeTextColor())
    }
    
    fileprivate func setupUI(){
        extendedLayoutIncludesOpaqueBars = true
        view.backgroundColor = view.getModeColor()
        view.clipsToBounds = true
        addAllSubviews()
        setupNavigationBar()
    }
    
    fileprivate func addAllSubviews(){
        view.addSubview(tableView)
        view.addSubview(segmentedControl)
        view.addSubview(languagesTableView)
    }
    
    fileprivate func setupNavigationBar(){
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.addSearchController(search)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        navigationItem.setLeftBarButton(image: PrivateConstants.leftBarButtonImage,
                                        target: self,
                                        action: #selector(changeMode),
                                        tintColor: view.getModeTextColor())
    }
    
    fileprivate func setupConstraints(){
        segmentedControl.edgesToSuperview(excluding: [.top, .bottom], insets: .init(top: 0, left: 16, bottom: 0, right: 16), usingSafeArea: true)
        topSegmentedControlConstraint = segmentedControl.topToSuperview(offset: 16.0, usingSafeArea: true)
        tableView.edgesToSuperview(excluding: .none, usingSafeArea: false)
        languagesTableView.edgesToSuperview(excluding: .bottom, usingSafeArea: true)
        bottomLanguagesTableViewConstraint = languagesTableView.bottomToSuperview()
    }
    
    fileprivate func setupNotificationKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveKeyboardNotificationObserver(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    fileprivate func setScrollToIndex(){
        scrollToIndex = { [weak self] index in
            guard let `self` = self else { return }
            self.tableView.scrollToRow(at: IndexPath.init(item: index, section: 0), at: .bottom, animated: true)
        }
    }
    
    fileprivate func initFakeWebView() {
        webView = UIWebView.init(frame: .zero)
        view.addSubview(webView)
        let url = URL(string: Constants.HTML.google)
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
    }
    
    // MARK: - Custom Functions
    
    fileprivate func showDetails(index: Int){
        let vc = DetailsViewController()
        vc.scrollToIndex = self.scrollToIndex
        vc.setRepos(repos: viewModel.dataSource, index: index)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc fileprivate func didReceiveKeyboardNotificationObserver(_ notification: Notification) {
        let userInfo = notification.userInfo
        let keyboardFrame = (userInfo!["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
        self.bottomLanguagesTableViewConstraint?.constant = -(self.view.height - keyboardFrame.origin.y)
    }
    
    @objc fileprivate func changeMode(){
        self.enableDarkMode(bool: !Constants.isDarkModeEnabled)
    }
    
    @objc fileprivate func scrollToTop(){
        self.tableView.scrollToTop()
    }
    
    fileprivate func changeColorView(view: UIView) {
        view.subviews.forEach { (view) in
            if view.subviews.count > 0 {
                changeColorView(view: view)
            }
            switch view {
            case is UILabel:
                if let label = view as? UILabel {
                    label.textColor = label.getModeTextColor()
                    label.setNeedsDisplay()
                }
            case is UIImageView:
                if let iv = view as? UIImageView {
                    iv.tintColor = iv.getModeTextColor()
                    iv.setNeedsDisplay()
                }
            default:
                view.backgroundColor = view.getModeColor()
                view.setNeedsDisplay()
            }
        }
    }
    
    fileprivate func enableDarkMode(bool: Bool) {
        UserDefaults.standard.set(!Constants.isDarkModeEnabled, forKey: Constants.UserDefault.darkMode)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.switchMode()
    }
}

// MARK: - Extension
// MARK: - TableView

extension ViewController: TableViewProtocol {

    func getTableViewType(_ tableView: UITableView) -> TableViewType {
        return tableView == languagesTableView ? .languages : .repo
    }
    
    func setDataSource(_ tableView: UITableView) -> [[Decodable]?]? {
        return viewModel.getTableViewDataSource(type: getTableViewType(tableView))
    }
    
    func setTitleHeaders(_ tableView: UITableView) -> [String]? {
        return viewModel.getTitleHeaders(type: getTableViewType(tableView))
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat? {
        return  tableView == languagesTableView && section == 0 && viewModel.getRecents().count == 0
                ? 0.0
                : tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.addShadow(radius: 6, opacity: 0.05)
        header.textLabel?.textColor = view.getModeTextColor()
        header.backgroundView?.backgroundColor = view.getModeColor()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, data: Decodable?) {
        switch getTableViewType(tableView) {
        case .languages:
            viewModel.updateTrending(data: data, indexPath: indexPath)
            search.isActive = false
        default:
            showDetails(index: indexPath.item)
        }
    }
    
    func tableViewDidScroll(_ tableView: UITableView, isScrollViewDown: Bool) {
        guard tableView == self.tableView else { return }
        let alpha: CGFloat = isScrollViewDown ? 0 : 1
        guard segmentedControl.alpha != alpha else { return }
        Animator.animate(view: segmentedControl, alpha: alpha, completion: nil)
    }
}

// MARK: - SearchController

extension ViewController: SearchControllerDelegate {

    func updateSearchResults<T>(for searchController: UISearchController, filteredData: [T], filtering: Bool) where T : Decodable, T : Encodable {
        guard let data = filteredData as? [All] else { viewModel.removeAllFilteredData(); return }
        viewModel.setFilteredData(data: data)
        self.reloadLanguagesTableView()
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        search.updateDataToFilter(data: viewModel.getLanguages(type: .all))
        languagesTableView.reloadData()
        languagesTableView.alpha = 1
        Animator.animate(view: segmentedControl, alpha: 0, duration: 0.3, completion: nil)
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        languagesTableView.alpha = 0
        Animator.animate(view: segmentedControl, alpha: 1, duration: 0.5, delay: 0.2, completion: nil)
        bottomLanguagesTableViewConstraint?.constant = 0
    }
}

// MARK: - SegmentedControl

extension ViewController: SegmentedControlDelegate {

    func indexChanged(_ sender: UISegmentedControl){
        viewModel.setCurrentSince(index: sender.selectedSegmentIndex)
    }
}

// MARK: - ProtocolDelegate

extension ViewController: HomeProtocolDelegate {
    
    func reloadTableView(isUpdating: Bool) {
        let alpha: CGFloat = isUpdating ? 0 : 1
        self.tableView.reloadData()
        Animator.addCATransition(view: self.tableView)
        self.tableView.alpha = alpha
        DispatchQueue.main.async {
            self.segmentedControl.isEnabled = self.title == "loading".localized ? false : true
        }
    }
    
    func reloadLanguagesTableView(){
        self.languagesTableView.reloadData()
        self.languagesTableView.scrollToTop(animated: false)
    }
    
    func updateLeftButtonBarTitle(languageName: String?, count: Int){
        self.title = languageName ?? "loading".localized
        showActivityIndicator(bool: false)
    }
    
    func showActivityIndicator(bool: Bool) {
        bool ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
}

// MARK: - NavigationControllerDelegate

extension ViewController {
    override func setTapGestureAction() -> Selector? {
        return #selector(scrollToTop)
    }
}
