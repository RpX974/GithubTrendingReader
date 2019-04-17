//
//  Constants.swift
//  Way
//
//  Created by Laurent Grondin on 18/03/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import UIKit

// MARK: - Colors

struct Colors {
    static let lineGray: UIColor = UIColor.init(hex: 0x9B9B9B).withAlphaComponent(0.10)
    static let darkMode: UIColor = UIColor.black
}

// MARK: - Constants

struct Constants {
    static var isDarkModeEnabled: Bool { return UserDefaults.standard.bool(forKey: Constants.UserDefault.darkMode) }
    static let baseUrl: String = "https://github-trending-api.now.sh/repositories?language=%@&since=%@"
    static let github: String = "https://github.com"
    static let languageURL: String = "https://github-trending-api.now.sh/languages"
    static let defaultLanguage: String = "Swift"
    static let defaultLanguageUrlParam: String = "swift"
    static let maxRecentsCount: Int = 10
    // MARK: - UserDefault
    
    struct UserDefault {
        static let darkMode: String = "darkMode"
        static let language: String = "language"
        static let since: String = "since"
        static let swipe: String = "swipe"
    }
    
    // MARK: - CSS
    
    struct CSS {
        static let darkMode: String = "dark_mode_css".localized
        static let whiteMode: String = "white_mode_css".localized
    }
    
    // MARK: - HTML
    
    struct HTML {
        static let aboutBlank: String = "about:blank"
        static let google: String = "https://www.google.com/"
        static let prefixToAvoid: String = "https://github.com/"
        
        static let sliceFrom: String = "slice_from".localized
        static let sliceTo: String = "slice_to".localized
        static let replacingOf: String = "replacing_of".localized
        static let replacingWith: String = "replacing_with".localized
        static let urlFormat: String = "url_format".localized
    }
}
