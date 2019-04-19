//
//  SegmentedControl.swift
//  GithubTrendingReader
//
//  Created by Laurent Grondin on 16/04/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import UIKit

// MARK: - Protocol

protocol SegmentedControlDelegate: class {
    func indexChanged(_ sender: UISegmentedControl)
}

// MARK: - SegmentedControl

class SegmentedControl: UISegmentedControl {
    
    // MARK: - Deinit
    
    deinit {
        log_done()
    }

    // MARK: - Properties

    weak var delegate: SegmentedControlDelegate?

    // MARK - Initializers

    convenience init(items: [Any]?, backgroundColor: UIColor = .white, tintColor: UIColor = .blue, textAttributes: [NSAttributedString.Key : Any]?, selectedIndex: Int = 0) {
        self.init(items: items)

        self.backgroundColor = backgroundColor
        self.tintColor = tintColor
        self.selectedSegmentIndex = selectedIndex
        self.addTarget(self, action: #selector(self.indexChanged(_:)), for: .valueChanged)
        guard let attrs = textAttributes else { return }
        self.setTitleTextAttributes(attrs, for: .normal)
    }
    
    // MARK: - Custom Functions

    @objc fileprivate func indexChanged(_ sender: UISegmentedControl){
        self.delegate?.indexChanged(sender)
    }
}
