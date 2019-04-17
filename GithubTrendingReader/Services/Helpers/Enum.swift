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
}

// MARK: - Since

enum Since: String {
    case daily = "daily"
    case weekly = "weekly"
    case monthly = "monthly"
}
