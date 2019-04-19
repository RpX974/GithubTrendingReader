//
//  Language.swift
//  GithubTrendingReader
//
//  Created by Laurent Grondin on 14/04/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import Foundation

// MARK: - Language

struct Language: Codable {
    // MARK: - Properties

    var popular, all: [All]
}

// MARK: - All

struct All: Codable {
    // MARK: - Properties

    let urlParam, name: String
    
    // MARK - Initializers

    init(urlParam: String, name: String) {
        self.urlParam = urlParam
        self.name = name
    }
}
