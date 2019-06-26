//
//  WebView.swift
//  GithubTrendingReader
//
//  Created by Laurent Grondin on 17/04/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import UIKit

// MARK: - Protocol

protocol WebViewProtocolDelegate: class {
    func didTapOnImage(url: String)
    func setImageFormats() -> [String]
    func prefixToAvoid() -> String
}

extension WebViewProtocolDelegate {
    func didTapOnImage(url: String) {}
    func setImageFormats() -> [String] {
        return [".png", ".jpg", ".jpeg"]
    }
    func prefixToAvoid() -> String { return "" }
}

// MARK: - WebView

class WebView: UIWebView {
    
    // MARK: - Deinit
    
    deinit {
        log_done()
    }

    // MARK: - Properties

    weak var globalDelegate: WebViewProtocolDelegate?
    
    // MARK: - Initializers
    
    init(delegate: WebViewProtocolDelegate? = nil) {
        super.init(frame: .zero)
        setup(delegate: delegate)
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup(delegate: WebViewProtocolDelegate? = nil) {
        self.delegate = self
        self.globalDelegate = delegate
        backgroundColor = .clear
        scrollView.backgroundColor = .clear
        isOpaque = false
    }
}

// MARK: - Extension
// MARK: - WebViewDelegate

extension WebView: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        log_done()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        if navigationType == .linkClicked {
            if let url = request.url {
                var showImage = false
                let imageFormats = self.globalDelegate?.setImageFormats()
                imageFormats?.forEach({ string in
                    if url.absoluteString.hasSuffix(string) {
                        if url.absoluteString.hasPrefix(self.globalDelegate?.prefixToAvoid() ?? "") { return }
                        showImage = true
                        return
                    }
                })
                if showImage {
                    self.globalDelegate?.didTapOnImage(url: url.absoluteString)
                    return false
                }
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
            return false
        }
        return true
    }
}

// MARK: - Helper

fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
