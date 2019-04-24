//
//  Enum.swift
//  GithubTrendingReader
//
//  Created by Laurent Grondin on 15/04/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import Foundation

// MARK: - SinceIndex

enum SinceIndex: Int {
    case daily
    case weekly
    case monthly
    
    func asString() -> String {
        switch self {
        case .daily: return "daily"
        case .weekly: return "weekly"
        case .monthly: return "monthly"
        }
    }
}

// MARK: - Since

enum Since: String {
    case daily
    case weekly
    case monthly
    
    static func with(index: Int) -> Since {
        let rawValue = (SinceIndex(rawValue: index) ?? .daily).asString()
        return Since.init(rawValue: rawValue) ?? .daily
    }
    
    func asInt() -> Int {
        switch self {
        case .daily: return 0
        case .weekly: return 1
        case .monthly: return 2
        }
    }
}

// MARK: - TableViewType

enum TableViewType {
    case repo, languages
}

// MARK: - LanguagesType

enum LanguagesType {
    case recents, popular, all
}
