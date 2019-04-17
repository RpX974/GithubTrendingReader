//
//  StackView.swift
//  GithubTrendingReader
//
//  Created by Laurent Grondin on 14/04/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import UIKit

class HorizontalStackView: UIStackView {
    
    // MARK - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Configuration

    private func setupUI(){
        backgroundColor = .clear
        axis = .horizontal
        alignment = .center
        spacing = 5.0
        translatesAutoresizingMaskIntoConstraints = false
    }
}

class VerticalStackView: UIStackView {
    
    // MARK - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Configuration

    private func setupUI(){
        backgroundColor = .clear
        axis = .vertical
        alignment = .leading
        spacing = 5.0
        translatesAutoresizingMaskIntoConstraints = false
    }
}
