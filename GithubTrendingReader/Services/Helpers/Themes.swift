//
//  Themes.swift
//  GithubTrendingReader
//
//  Created by Laurent Grondin on 20/06/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import UIKit

// MARK: - Colors

struct Colors {
    static let lineGray: UIColor = UIColor.init(hex: 0x9B9B9B).withAlphaComponent(0.10)
    static let darkMode: UIColor = UIColor.black
}

// MARK: - Themes

struct Theme {
    let color: UIColor
    let textColor: UIColor
}

struct Themes {
    
    // MARK: - Properties

    static var isDarkModeEnabled: Bool {
        get { return UserDefaults.standard.bool(forKey: Constants.UserDefault.darkMode) }
        set { UserDefaults.standard.set(newValue, forKey: Constants.UserDefault.darkMode) }
    }
    static var preferredStatusBarStyle: UIStatusBarStyle { return isDarkModeEnabled ? .lightContent : .default }
    static var keyboardAppearence: UIKeyboardAppearance { return isDarkModeEnabled ? .dark : .light }
    
    // MARK: - Theme

    static var current: Theme {
        return isDarkModeEnabled ? black : white
    }
    static let white = Theme(color: .white, textColor: .black)
    static let black = Theme(color: .black, textColor: .white)

    // MARK: - Custom Functions
    
    static func setupUIAppareance() {
        let barTintColor: UIColor = current.color
        let tintColor: UIColor = current.textColor
        let attrs = [NSAttributedString.Key.foregroundColor: tintColor]
        UINavigationBar.appearance().titleTextAttributes = attrs
        UINavigationBar.appearance().largeTitleTextAttributes = attrs
        UINavigationBar.appearance().tintColor = tintColor
        UINavigationBar.appearance().barTintColor = barTintColor
        UIBarButtonItem.appearance().setTitleTextAttributes(attrs, for: .normal)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = attrs
        UITextField.appearance().keyboardAppearance = keyboardAppearence
    }
    
    static func changeColorView(view: UIView) {
        view.backgroundColor = Themes.current.color
        view.subviews.forEach { (view) in
            if view.subviews.count > 0 { changeColorView(view: view) }
            switch view {
            case is UILabel:
                if let label = view as? UILabel {
                    label.textColor = Themes.current.textColor
                    label.setNeedsDisplay()
                }
            case is UIImageView:
                if let imageView = view as? UIImageView {
                    imageView.tintColor = Themes.current.textColor
                    imageView.setNeedsDisplay()
                }
            default:
                view.backgroundColor = Themes.current.color
                view.setNeedsDisplay()
            }
        }
    }
    
    static func changeCurrentTheme(viewController: UIViewController) {
        isDarkModeEnabled = !isDarkModeEnabled
        setupUIAppareance()
        let view: UIView = viewController.view
        let windows = UIApplication.shared.windows
        changeColorView(view: view)
        for window in windows {
            for view in window.subviews {
                view.removeFromSuperview()
                window.addSubview(view)
            }
        }
        viewController.setNeedsStatusBarAppearanceUpdate()
    }
}
