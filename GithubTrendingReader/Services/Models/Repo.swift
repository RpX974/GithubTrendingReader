//
//  Repo.swift
//  GithubTrendingReader
//
//  Created by Laurent Grondin on 13/04/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Typealias

typealias Repos = [Repo]

// MARK: - BuiltBy

struct BuiltBy: Codable {
    let username: String
    let href, avatar: String
}

// MARK: - Repo

class Repo: Codable {
    
    // MARK: - Properties

    let author, name: String
    let url: String
    let description: String
    let language: String?
    let languageColor: String?
    let stars, forks, currentPeriodStars: Int
    let builtBy: [BuiltBy]
    var urlString: String?

    // MARK: - Custom Functions

    func getTitle() -> NSMutableAttributedString {
        let attributedText = NSMutableAttributedString(string: author, attributes: [NSAttributedString.Key.font: UIFont.regular(size: 20)])
        attributedText.append(NSAttributedString(string: " / \(name)", attributes: [NSAttributedString.Key.font: UIFont.bold(size: 20)]))
        return attributedText
    }
    
    func setUrlString(){
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            guard self.urlString == nil else {
//                log_info("urlString already exists")
                return
            }
            do {
                guard let url = URL.init(string: self.url), let contents = try String(contentsOf: url, encoding: .utf8)
                    .slice(from: Constants.HTML.sliceFrom, to: Constants.HTML.sliceTo)?
                    .replacingOccurrences(of: String(format: Constants.HTML.replacingOf, self.author, self.name), with:
                        String(format: Constants.HTML.replacingWith, Constants.github, self.author, self.name))
                    else { return }
                let style = Constants.isDarkModeEnabled ? Constants.CSS.darkMode : Constants.CSS.whiteMode
                self.urlString = String(format: Constants.HTML.urlFormat, style, contents)
            } catch let error {
                log_error(error.localizedDescription)
            }
        }
    }
    
    func refreshUrlString(){
        self.urlString = nil
        setUrlString()
    }
    
    func getUrlString() -> String? {
        guard let url = urlString else {
            setUrlString()
            return urlString
        }
        return url
    }
}
