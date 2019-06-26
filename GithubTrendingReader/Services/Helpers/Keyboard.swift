//
//  Keyboard.swift
//  Papajokes
//
//  Created by Laurent Grondin on 17/05/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import UIKit

protocol KeyboardDelegate: class {
    func enableKeyboard(_ bool: Bool)
    func keyboardFrame(_ notification: Notification, frame: CGRect)
}

extension KeyboardDelegate where Self: UIViewController {
    
    func enableKeyboard(_ bool: Bool) {
        bool ? createNotification() : NotificationCenter.default.removeObserver(self)
    }
    
    private func createNotification() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: nil) { [weak self] notification in
            self?.keyboardWillChangeFrameNotification(notification)
        }
    }
    
    private func keyboardWillChangeFrameNotification(_ notification: Notification) {
        let userInfo = notification.userInfo
        guard let rect = userInfo!["UIKeyboardFrameEndUserInfoKey"] as? NSValue else { return }
        let keyboardFrame = rect.cgRectValue
        self.keyboardFrame(notification, frame: keyboardFrame)
    }
}
