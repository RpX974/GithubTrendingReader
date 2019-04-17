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

    let popular, all: [All]
}

// MARK: - All

class All: Codable {
    // MARK: - Properties

    let urlParam, name: String
    
    // MARK - Initializers

    init(urlParam:String, name:String) {
        self.name = name
        self.urlParam = urlParam
    }
}
