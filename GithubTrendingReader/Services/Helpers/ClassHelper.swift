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
    
    static func setupUIAppareance(isDarkModeEnabled: Bool = false) {
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

    static func showAlertView(parent: UIViewController,
                              title: String,
                              message: String,
                              preferredStyle: UIAlertController.Style = .alert,
                              tintColor: UIColor = .black,
                              handlerAction: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: preferredStyle)
        alert.view.tintColor = tintColor
        alert.addAction(UIAlertAction(title: PrivateConstants.AlertView.defaultTitleButton, style: .default, handler: handlerAction))
        DispatchQueue.main.async {
            parent.present(alert, animated: true)
        }
    }
    
    static func changeColorView(view: UIView) {
        view.backgroundColor = view.getModeColor()
        view.subviews.forEach { (view) in
            if view.subviews.count > 0 { changeColorView(view: view) }
            switch view {
            case is UILabel:
                if let label = view as? UILabel {
                    label.textColor = label.getModeTextColor()
                    label.setNeedsDisplay()
                }
            case is UIImageView:
                if let imageView = view as? UIImageView {
                    imageView.tintColor = imageView.getModeTextColor()
                    imageView.setNeedsDisplay()
                }
            default:
                view.backgroundColor = view.getModeColor()
                view.setNeedsDisplay()
            }
        }
    }

    static func changeModeColor(isDarkModeEnabled: Bool, viewController: UIViewController) {
        UserDefaults.standard.set(isDarkModeEnabled, forKey: Constants.UserDefault.darkMode)
        ClassHelper.setupUIAppareance(isDarkModeEnabled: isDarkModeEnabled)
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
    
    static func measureTime(completion: SuccessCallBack) {
        let start = CFAbsoluteTimeGetCurrent()
        completion()
        let diff = CFAbsoluteTimeGetCurrent() - start
        log_info("Took \(diff) seconds")
    }
}
