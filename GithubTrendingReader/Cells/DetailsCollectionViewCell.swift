//
//  DetailsCollectionViewCell.swift
//  GithubTrendingReader
//
//  Created by Laurent Grondin on 14/04/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import Foundation
import UIKit
import TinyConstraints

class DetailsCollectionViewCell: GenericCollectionViewCell<Repo>, WebViewProtocolDelegate {
    
    // MARK: - Deinit

    deinit {
        log_done()
    }

    // MARK: - Constants

    struct PrivateConstants {
        static let imagesFormat: [String] = [".png", ".jpg", ".jpeg"]
        static let prefixToAvoid: String = Constants.HTML.prefixToAvoid
    }
    
    // MARK: - Views

    fileprivate lazy var webView: WebView = {
        let w = WebView()
        w.globalDelegate = self
        return w
    }()

    // MARK - Closures

    var showWebImage: ((String) -> Void)?

    // MARK - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Layout

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        webView.scrollView.setScrollIndicatorColor(color: self.getModeTextColor())
    }
    
    // MARK: - View Configuration

    
    fileprivate func setup() {
        contentView.addSubview(webView)
        webView.edgesToSuperview(usingSafeArea: true)
    }
    
    func configureCell(data: Repo?, showWebImage: ((String) -> Void)?) {
        guard let repo = data else { return }
        self.showWebImage = showWebImage
        loadWebView(repo: repo)
    }
    
    // MARK: - Custom Functions
    
    fileprivate func loadWebView(repo: Repo){
        repo.getHTML { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .success (let url):
                self.webView.loadHTMLString(url, baseURL: Bundle.main.bundleURL)
            case .failure(let error):
                log_error(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Delegate
    // MARK: - WebView
    
    func didTapOnImage(url: String) {
        self.showWebImage?(url)
    }
    
    func prefixToAvoid() -> String {
        return PrivateConstants.prefixToAvoid
    }
    
    func scrollToTop(){
        webView.scrollView.scrollToTop(animated: true)
    }
}
