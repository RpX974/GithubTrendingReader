//
//  Create.swift
//  Papajokes
//
//  Created by Laurent Grondin on 16/05/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import Foundation
import UIKit

class Create {

    // MARK: - Label

    class func label(text: String? = nil,
                     textColor: UIColor? = nil,
                     backgroundColor: UIColor = .clear,
                     fontSize: CGFloat,
                     isBold: Bool = false,
                     isMultiline: Bool = false,
                     dropShadow: Bool = false)
                -> Label {
        return Label(text: text, textColor: textColor, fontSize: fontSize, isBold: isBold, isMultiline: isMultiline)
    }
    
    // MARK: - Buttons

    class func button(text: String? = nil,
                      image: UIImage? = nil,
                      size: CGSize? = nil,
                      titleColor: UIColor = .black,
                      backgroundColor: UIColor = .clear,
                      font: UIFont = UIFont.bold(size: 18),
                      addTitleInset: Bool = false,
                      isShadowEnabled: Bool = true,
                      target: Any? = nil,
                      action: Selector? = nil) -> Button {
        return Button(text: text, image: image, size: size, titleColor: titleColor, backgroundColor: backgroundColor, font: font, addTitleInset: addTitleInset, isShadowEnabled: isShadowEnabled, target: target, action: action)
    }
    
    class func button(image: UIImage? = nil,
                      size: CGSize? = nil,
                      backgroundColor: UIColor = .clear,
                      isShadowEnabled: Bool = true,
                      target: Any? = nil,
                      action: Selector? = nil) -> Button {
        return Button(image: image, size: size, backgroundColor: backgroundColor, isShadowEnabled: isShadowEnabled, target: target, action: action)
    }
    
    class func rbutton(text: String? = nil,
                       image: UIImage? = nil,
                       size: CGSize? = nil,
                       titleColor: UIColor = .black,
                       backgroundColor: UIColor = .white,
                       font: UIFont = UIFont.bold(size: 18),
                       cornerRadius: CGFloat = 12, addTitleInset: Bool = false,
                       isShadowEnabled: Bool = true,
                       target: Any? = nil,
                       action: Selector? = nil) -> RoundedButton {
        return RoundedButton(text: text, image: image, size: size, titleColor: titleColor, backgroundColor: backgroundColor, font: font, cornerRadius: cornerRadius, addTitleInset: addTitleInset, isShadowEnabled: isShadowEnabled, target: target, action: action)
    }

    class func rbutton(image: UIImage? = nil,
                       size: CGSize? = nil,
                       backgroundColor: UIColor = .clear,
                       cornerRadius: CGFloat = 12,
                       isShadowEnabled: Bool = true,
                       target: Any? = nil,
                       action: Selector? = nil) -> RoundedButton {
        return RoundedButton(image: image, size: size, backgroundColor: backgroundColor, cornerRadius: cornerRadius, isShadowEnabled: isShadowEnabled, target: target, action: action)
    }
    
    // MARK: - StackViews
    
    class func stack(_ views: UIView..., backgroundColor: UIColor = .clear, spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill, margins: UIEdgeInsets = .zero) -> UIView {
        let view = UIView(backgroundColor: backgroundColor)
        view.stack(views, spacing: spacing, alignment: alignment, distribution: distribution)
            .withMargins(margins)
        return view
    }
    
    class func hstack(_ views: UIView..., backgroundColor: UIColor = .clear, spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill, margins: UIEdgeInsets = .zero) -> UIView {
        let view = UIView(backgroundColor: backgroundColor)
        view.hstack(views, spacing: spacing, alignment: alignment, distribution: distribution)
            .withMargins(margins)
        return view
    }
    
    class func stack(_ views: [UIView], backgroundColor: UIColor = .clear, spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill, margins: UIEdgeInsets = .zero) -> UIView {
        let view = UIView(backgroundColor: backgroundColor)
        view.stack(views, spacing: spacing, alignment: alignment, distribution: distribution)
            .withMargins(margins)
        return view
    }
    
    class func hstack(_ views: [UIView], backgroundColor: UIColor = .clear, spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill, margins: UIEdgeInsets = .zero) -> UIView {
        let view = UIView(backgroundColor: backgroundColor)
        view.hstack(views, spacing: spacing, alignment: alignment, distribution: distribution)
            .withMargins(margins)
        return view
    }
    
    // MARK: - ImageViews

    class func imageView(image: UIImage? = nil, tintColor: UIColor? = nil, contentMode: UIView.ContentMode = .scaleAspectFill, cornerRadius: CGFloat? = nil, isRounded: Bool = false, isShadowEnabled: Bool = false) -> ImageView {
        return ImageView(image: image, contentMode: contentMode, tintColor: tintColor, cornerRadius: cornerRadius, isRounded: isRounded, isShadowEnabled: isShadowEnabled)
    }
}

extension UIEdgeInsets {
    static public func allSides(side: CGFloat) -> UIEdgeInsets {
        return .init(top: side, left: side, bottom: side, right: side)
    }
}

extension UIView {
    
    fileprivate func _stack(_ axis: NSLayoutConstraint.Axis = .vertical, views: [UIView], spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.alignment = alignment
        stackView.distribution = distribution
        addSubview(stackView)
        stackView.fillSuperview()
        return stackView
    }
    
    @discardableResult
    func stack(_ views: [UIView], spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill) -> UIStackView {
        return _stack(.vertical, views: views, spacing: spacing, alignment: alignment, distribution: distribution)
    }
    
    @discardableResult
    func hstack(_ views: [UIView], spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill) -> UIStackView {
        return _stack(.horizontal, views: views, spacing: spacing, alignment: alignment, distribution: distribution)
    }
    
    @discardableResult
    func stack(_ views: UIView..., spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill) -> UIStackView {
        return _stack(.vertical, views: views, spacing: spacing, alignment: alignment, distribution: distribution)
    }
    
    @discardableResult
    func hstack(_ views: UIView..., spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill) -> UIStackView {
        return _stack(.horizontal, views: views, spacing: spacing, alignment: alignment, distribution: distribution)
    }
    
    @discardableResult
    func widthToSuperView<T>() -> T where T : UIView {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = self.superview {
            widthAnchor.constraint(equalTo: superview.widthAnchor).isActive = true
        }
        return self as! T
    }
    
    @discardableResult
    func heightToSuperView<T>() -> T where T : UIView {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = self.superview {
            heightAnchor.constraint(equalTo: superview.heightAnchor).isActive = true
        }
        return self as! T
    }
    
    @discardableResult
    func sizeToSuperView<T>() -> T where T : UIView {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = self.superview {
            widthAnchor.constraint(equalTo: superview.widthAnchor).isActive = true
            heightAnchor.constraint(equalTo: superview.heightAnchor).isActive = true
        }
        return self as! T
    }
    
    @discardableResult
    func withWidth<T>(_ width: CGFloat) -> T where T : UIView {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
        return self as! T
    }
    
    @discardableResult
    func withHeight<T>(_ height: CGFloat) -> T where T : UIView {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        return self as! T
    }
    
    @discardableResult
    open func withSize<T: UIView>(_ size: CGSize) -> T {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: size.width).isActive = true
        heightAnchor.constraint(equalToConstant: size.height).isActive = true
        return self as! T
    }
    
    @discardableResult
    func withBorder<T: UIView>(width: CGFloat, color: UIColor) -> T {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        return self as! T
    }
    
    @discardableResult
    open func withCornerRadius<T: UIView>(_ radius: CGFloat) -> T {
        layer.cornerRadius = radius
        clipsToBounds = true
        return self as! T
    }

}

extension UIStackView {
    
    @discardableResult
    open func withMargins(_ margins: UIEdgeInsets) -> UIStackView {
        layoutMargins = margins
        isLayoutMarginsRelativeArrangement = true
        return self
    }
    
    @discardableResult
    open func padLeft(_ left: CGFloat) -> UIStackView {
        isLayoutMarginsRelativeArrangement = true
        layoutMargins.left = left
        return self
    }
    
    @discardableResult
    open func padTop(_ top: CGFloat) -> UIStackView {
        isLayoutMarginsRelativeArrangement = true
        layoutMargins.top = top
        return self
    }
    
    @discardableResult
    open func padBottom(_ bottom: CGFloat) -> UIStackView {
        isLayoutMarginsRelativeArrangement = true
        layoutMargins.bottom = bottom
        return self
    }
    
    @discardableResult
    open func padRight(_ right: CGFloat) -> UIStackView {
        isLayoutMarginsRelativeArrangement = true
        layoutMargins.right = right
        return self
    }
}
