//
//  LanguageTableViewCell.swift
//  GithubTrendingReader
//
//  Created by Laurent Grondin on 14/04/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import Foundation
import UIKit

class LanguageTableViewCell: GenericTableViewCell<Language> {
    deinit {
        log_done()
    }
    
    // MARK: - Views

    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.lineGray
        return view
    }()
    
    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Configuration

    fileprivate func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        textLabel?.textColor = getModeTextColor()
        selectionStyle = .none
        self.addSubview(separator)
    }
    
    fileprivate func setupConstraints() {
        separator.edgesToSuperview(excluding: .top, insets: .zero)
        separator.height(0.5)
    }
    
    override func configure(with data: Language?) {
        guard let data = data else { return }
        self.textLabel?.text = data.name
    }
}
