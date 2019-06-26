//
//  Repo.swift
//  GithubTrendingReader
//
//  Created by Laurent Grondin on 13/04/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import Foundation
import UIKit
import Promises

// MARK: - Typealias

typealias Repos = [Repo]

// MARK: - BuiltBy

struct BuiltBy: Codable {

    // MARK: - Properties

    let username: String
    let href, avatar: String
}

// MARK: - Repo

class Repo: Cloud & Codable {
    
    // MARK: - Properties
    
    let author, name: String
    let url: String
    let description: String
    let language: String?
    let languageColor: String?
    let stars, forks, currentPeriodStars: Int
    let builtBy: [BuiltBy]
    var html: String?

    // MARK: - Custom Functions
    // MARK: - SETTERS
    
    fileprivate func setHTML() -> Promise<String> {
        return Promise<String>(on: .global(qos: .userInitiated), { (fullfill, reject) in
            do {
                typealias HTML = Constants.HTML
                guard let url = URL.init(string: self.url), let contents = try String(contentsOf: url, encoding: .utf8)
                    .slice(from: HTML.sliceFrom, to: HTML.sliceTo)?
                    .replacingOccurrences(of: String(format: HTML.replacingOf, self.author, self.name), with:
                        String(format: HTML.replacingWith, Constants.github, self.author, self.name))
                    else { return }
                let style = Themes.isDarkModeEnabled ? Constants.CSS.darkMode : Constants.CSS.whiteMode
                self.html = String(format: HTML.urlFormat, style, contents)
                fullfill(self.html ?? "")
            } catch let error {
                reject(error)
            }
        })
    }
    
    func createHTML(completion: ResultCompletion<String>? = nil) {
        guard self.html == nil else { completion?(.success(self.html ?? "")); return }
        self.setHTML().then({ (html) in
            completion?(.success(html))
        }).catch({ (error) in
            completion?(.failure(error))
        })
    }
    
    func refreshHTML(){
        self.html = nil
        createHTML()
    }
    
    // MARK: - GETTERS
    
    func getTitle() -> NSMutableAttributedString {
        let attributedText = NSMutableAttributedString(string: author, attributes: [NSAttributedString.Key.font: UIFont.regular(size: 20)])
        attributedText.append(NSAttributedString(string: " / \(name)", attributes: [NSAttributedString.Key.font: UIFont.bold(size: 20)]))
        return attributedText
    }

    func getHTML(_ completion: ResultCompletion<String>?) {
        createHTML(completion: completion)
    }
    
    func getColor() -> UIColor? {
        let color = languageColor != nil ?
                    UIColor.init(hexString: languageColor ?? "#FFFFFF") :
                    nil
        return color
    }
}
