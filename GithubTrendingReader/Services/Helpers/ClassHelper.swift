//
//  ClassHelper.swift
//  GithubTrendingReader
//
//  Created by Laurent Grondin on 17/04/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import UIKit

class ClassHelper {
    
    // MARK: - Constants
    
    struct PrivateConstants {
        struct AlertView {
            static let defaultTitleButton: String = "OK"
        }
    }
    
    // MARK: - Custom Functions
    
    static func setupUIAppareance(isDarkModeEnabled: Bool = false){
        let barTintColor: UIColor = isDarkModeEnabled ? Colors.darkMode : .white
        let tintColor: UIColor = isDarkModeEnabled ? .white : Colors.darkMode
        let attrs = [NSAttributedString.Key.foregroundColor: tintColor]
//        let largeAttrs = [NSAttributedString.Key.foregroundColor: tintColor,
//                          NSAttributedString.Key.font: UIFont.bold(size: 30)]
        UINavigationBar.appearance().titleTextAttributes = attrs
        UINavigationBar.appearance().largeTitleTextAttributes = attrs
        UINavigationBar.appearance().tintColor = tintColor
        UINavigationBar.appearance().barTintColor = barTintColor
        UIBarButtonItem.appearance().setTitleTextAttributes(attrs, for: .normal)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = attrs
        UITextField.appearance().keyboardAppearance = isDarkModeEnabled ? .dark : .light
    }

    static func showAlertView(parent: UIViewController, title: String, message: String, preferredStyle: UIAlertController.Style = .alert, tintColor: UIColor = .black, handlerAction: ((UIAlertAction) -> Void)?){
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: preferredStyle)
        alert.view.tintColor = tintColor
        alert.addAction(UIAlertAction(title: PrivateConstants.AlertView.defaultTitleButton, style: .default, handler: handlerAction))
        DispatchQueue.main.async {
            parent.present(alert, animated: true)
        }
    }
}
