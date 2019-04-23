//
//  NavigationController.swift
//  GithubTrendingReader
//
//  Created by Laurent Grondin on 14/04/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import UIKit

// MARK: - Protocol

protocol NavigationControllerDelegate: class {
    func setTapGestureAction() -> Selector?
}

extension NavigationControllerDelegate {
    func setTapGestureAction() -> Selector? { return nil }
}

extension UIViewController: NavigationControllerDelegate {
    @objc func setTapGestureAction() -> Selector? { return nil }
}

// MARK: - NavigationController

class NavigationController: UINavigationController {
    
    // MARK: - Properties
    
    fileprivate var tapGesture: UITapGestureRecognizer!
    
    weak var globalDelegate: NavigationControllerDelegate?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Constants.isDarkModeEnabled ? .lightContent : .default
    }

    // MARK: - View Configuration

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        extendedLayoutIncludesOpaqueBars = true
        view.backgroundColor = view.getModeColor()
        navigationItem.largeTitleDisplayMode = .automatic
        navigationBar.isTranslucent = false
        navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Gestures
    
    func addTapGesture(target: UIViewController, action: Selector){
        tapGesture = UITapGestureRecognizer.init(target: target, action: action)
        navigationBar.addGestureRecognizer(tapGesture)
    }
    
    func removeTapGesture(){
        guard let tap = tapGesture else { return }
        navigationBar.removeGestureRecognizer(tap)
    }
    
    // MARK: - Custom Functions
    
    func clearNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        view.backgroundColor = .clear
    }
}

// MARK: - Extension
// MARK: - Delegate

extension NavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        globalDelegate = viewController
        guard let action = self.globalDelegate?.setTapGestureAction() else { return }
        removeTapGesture()
        addTapGesture(target: viewController, action: action)
    }
}
