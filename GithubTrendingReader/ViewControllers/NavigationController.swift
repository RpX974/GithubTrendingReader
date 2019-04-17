//
//  NavigationController.swift
//  GithubTrendingReader
//
//  Created by Laurent Grondin on 14/04/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    // MARK: - Properties

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Constants.isDarkModeEnabled ? .lightContent : .default
    }

    // MARK: - View Configuration

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = view.getModeColor()
        navigationBar.isTranslucent = false
        navigationBar.prefersLargeTitles = true
    }
}
