//
//  Protocols.swift
//  GithubTrendingReader
//
//  Created by Laurent Grondin on 14/04/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

// MARK: - GenericProtocol

protocol GenericProtocol: class {}

// MARK: - TableView

protocol GenericTableViewDelegate: GenericProtocol {
    func reloadTableView(isUpdating: Bool)
}

// MARK: - Home

protocol HomeProtocolDelegate: GenericTableViewDelegate {
    func reloadLanguagesTableView()
    func updateLeftButtonBarTitle(languageName: String?)
    func showActivityIndicator(bool: Bool)
}

protocol DetailsViewProtocolDelegate: GenericProtocol {
    func updateTitle(title: String?)
}
