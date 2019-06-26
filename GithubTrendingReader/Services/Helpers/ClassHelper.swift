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

    class func showAlertView(parent: UIViewController,
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
    
    class func measureTime(completion: SuccessCallBack) {
        let start = CFAbsoluteTimeGetCurrent()
        completion()
        let diff = CFAbsoluteTimeGetCurrent() - start
        log_info("Took \(diff) seconds")
    }
}
