//
//  RepoViewModel.swift
//  GithubTrendingReader
//
//  Created by Laurent Grondin on 21/04/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import Foundation
import Promises

class RepoViewModel: GenericDataSourceViewModel<Repo> {
    // MARK: - Typealias
    
    typealias RequestResult = Repos
    
    // MARK: - Deinit
    deinit {
        log_done()
    }
    
    // MARK: - Properties
    
    func getTrending(with language: Language, since: Since) -> Promise<()> {
        dataSource.removeAll()
        return Promise<()>(on: .global(qos: .userInitiated), { [weak self] (fullfill, reject) in
            guard let `self` = self else { return }
            API.shared.getTrending(fromLanguage: language.urlParam,
                                   since: since,
                                   completion: { [weak self] (result: Result<RequestResult>) in
                guard let `self` = self else { return }
                switch result {
                case .success(let data):
                    log_info("\(since.rawValue.capitalized) repos retrieved from \(language.name)")
                    self.dataSource.append(contentsOf: data)
                    fullfill(())
                case .failure(let error):
                    reject(error)
                }
            })
        })
    }
}
