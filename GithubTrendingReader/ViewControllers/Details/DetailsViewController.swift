//
//  DetailsViewController.swift
//  GithubTrendingReader
//
//  Created by Laurent Grondin on 13/04/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import Foundation
import UIKit
import AppImageViewer

class DetailsViewController: UIViewController {
    
    // MARK: - Deinit
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        log_done()
    }

    // MARK: - Constants

    struct PrivateConstants {
        static let rightBarButtonImage: UIImage? = "githubLogo".image
        static let alertTitle: String = "swipe_title".localized
        static let alertMessage: String = "swipe_message".localized
    }
    
    // MARK: - Views
    
    fileprivate lazy var collectionView: CollectionView<Repo, DetailsCollectionViewCell> = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = CollectionView<Repo, DetailsCollectionViewCell>(
                                            layout: layout,
                                            backgroundColor: UIColor.clear,
                                            isPagingEnabled: true,
                                            noDataText: "no_repo".localized)
        collectionView.globalDelegate = self
        return collectionView
    }()
    
    // MARK: - Properties

    fileprivate lazy var viewModel = DetailsViewViewModel(delegate: self)
    fileprivate var first = true
    
    // MARK - Closures
    
    var scrollToIndex: ((Int) -> Void)?
    var showWebImage: ((String) -> Void)?

    // MARK: - View Configuration

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        setupShowWebImage()
        showAlertView()
        setupNotificationCenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Animator.setScrollIndicatorColor(scrollView: self.collectionView, color: view.getModeTextColor())
        self.updateTitle(title: self.title)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard first else { return }
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(indexPath: .init(item: self.viewModel.getCurrentIndex(), section: 0), animated: false)
        }
        first = false
    }
    
    fileprivate func setupUI(){
        extendedLayoutIncludesOpaqueBars = true
        view.backgroundColor = view.getModeColor()
        view.clipsToBounds = true
        addAllSubviews()
        setupNavigationBar()
    }
    
    fileprivate func addAllSubviews(){
        view.addSubview(collectionView)
    }
    
    fileprivate func setupNavigationBar(){
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.setRightBarButton(image: PrivateConstants.rightBarButtonImage, target: self, action: #selector(self.goToSafari), tintColor: view.getModeTextColor())
    }
    
    fileprivate func setupConstraints(){
        collectionView.edgesToSuperview(usingSafeArea: true)
    }
    
    fileprivate func setupShowWebImage(){
        showWebImage = { [weak self] url in
            guard let `self` = self else { return }
            let appImage = ViewerImage.appImage(forUrl: url)
            let viewer = AppImageViewer.init(photos: [appImage])
            viewer.isCustomShare = false
            DispatchQueue.main.async {
                self.present(viewer, animated: true, completion: nil)
            }
        }
    }
    
    fileprivate func setupNotificationCenter(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.orientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    fileprivate func showAlertView(){
        guard UserDefaults.standard.bool(forKey: Constants.UserDefault.swipe) == false else { return }
        ClassHelper.showAlertView(parent: self, title: PrivateConstants.alertTitle, message: PrivateConstants.alertMessage, tintColor: Colors.darkMode, handlerAction: { _ in
            UserDefaults.standard.set(true, forKey: Constants.UserDefault.swipe)
        })
    }
    
    // MARK: - Custom Functions

    func setRepos(repos: Repos, index: Int){
        viewModel.setDataSource(data: repos)
        viewModel.setCurrentIndex(index: index)
    }
    
    @objc fileprivate func goToSafari(){
        guard let repo = viewModel.getDataFromCurrentIndex(), let url = URL.init(string: repo.url) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc fileprivate func orientationChanged() {
        // handle rotation here
        collectionView.collectionViewLayout.invalidateLayout()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.collectionView.scrollToItem(indexPath: .init(item: self.viewModel.getCurrentIndex(), section: 0), animated: false)
        }
    }
    
    fileprivate func setScrollIndicatorColor(color: UIColor) {
        for view in self.collectionView.subviews {
            if view.isKind(of: UIImageView.self), let imageView = view as? UIImageView  {
                imageView.image = nil
                view.backgroundColor = color
            }
        }
        self.collectionView.flashScrollIndicators()
    }
}

// MARK: - Extension
// MARK: - CollectionView

extension DetailsViewController: CollectionViewProtocol {
    
    func setDataSource(_ collectionView: UICollectionView) -> [[Decodable]?]? {
        return viewModel.getCollectionViewDataSource()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, cell: UICollectionViewCell, data: Decodable?) -> UICollectionViewCell {
        guard let newCell = cell as? DetailsCollectionViewCell, let data = data as? Repo else { return cell }
        newCell.configureCell(data: data, showWebImage: showWebImage)
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView, currentIndex: Int) {
        if viewModel.getCurrentIndex() == currentIndex { return }
        viewModel.setCurrentIndex(index: currentIndex)
        let indexPath = IndexPath.init(item: currentIndex, section: 0)
        self.collectionView.scrollToItem(indexPath: indexPath)
        scrollToIndex?(currentIndex)
    }
}

// MARK: - ProtocolDelegate

extension DetailsViewController: DetailsViewProtocolDelegate {

    func updateTitle(title: String?) {
        self.title = title
    }
}
