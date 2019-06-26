//
//  RoundedButton.swift
//  Way
//
//  Created by Laurent Grondin on 17/03/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import UIKit

class RoundedButton: Button {
    
    fileprivate var cornerRadius: CGFloat!
    
    required init(text: String? = nil,
         image: UIImage? = nil,
         size: CGSize? = nil,
         titleColor: UIColor = .black,
         backgroundColor: UIColor = .white,
         font: UIFont = UIFont.bold(size: 18),
         cornerRadius: CGFloat = 12, addTitleInset: Bool = false,
         isShadowEnabled: Bool = true,
         target: Any? = nil,
         action: Selector? = nil) {
        
        self.cornerRadius = cornerRadius
        super.init(text: text, image: image, size: size, titleColor: titleColor, backgroundColor: backgroundColor, font: font, addTitleInset: addTitleInset, isShadowEnabled: isShadowEnabled, target: target, action: action)
    }
    
    required init(image: UIImage? = nil,
         size: CGSize? = nil,
         backgroundColor: UIColor = .clear,
         cornerRadius: CGFloat = 12,
         isShadowEnabled: Bool = true,
         target: Any? = nil,
         action: Selector? = nil) {
        
        self.cornerRadius = cornerRadius
        super.init(image: image, size: size, backgroundColor: backgroundColor, isShadowEnabled: isShadowEnabled, target: target, action: action)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func customUI() {
        addCornerRadius(radius: cornerRadius)
        super.customUI()
    }
}


class Button: UIButton {
    
    var realBackgroundColor: UIColor? = .clear {
        didSet {
            backgroundColor = realBackgroundColor
        }
    }

    var isShadowEnabled: Bool!

    init(text: String? = nil,
         image: UIImage? = nil,
         size: CGSize? = nil,
         titleColor: UIColor = .black,
         backgroundColor: UIColor = .clear,
         font: UIFont = UIFont.bold(size: 18),
         addTitleInset: Bool = false,
         isShadowEnabled: Bool = true,
         target: Any? = nil,
         action: Selector? = nil) {
        
        super.init(frame: .zero)
        
        self.backgroundColor = backgroundColor
        self.realBackgroundColor = backgroundColor
        self.setTitle(text, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.setImage(image, for: .normal)
        self.font = font
        self.isShadowEnabled = isShadowEnabled
        self.imageView?.contentMode = .scaleAspectFill
        if let action = action {
            self.addTarget(target, action: action, for: .touchUpInside)
        }
        if addTitleInset {
            self.contentHorizontalAlignment = .left
            self.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 0)
        }
        if let size = size { self.withSize(size) }
        else { sizeToFit() }
    }
    
    init(image: UIImage? = nil,
         size: CGSize? = nil,
         backgroundColor: UIColor = .clear,
         isShadowEnabled: Bool = true,
         target: Any? = nil,
         action: Selector? = nil) {
        
        super.init(frame: .zero)
        
        self.backgroundColor = backgroundColor
        self.realBackgroundColor = backgroundColor
        self.setImage(image, for: .normal)
        self.isShadowEnabled = isShadowEnabled
        self.imageView?.contentMode = .scaleAspectFill
        if let action = action {
            self.addTarget(target, action: action, for: .touchUpInside)
        }
        if let size = size {
            self.withSize(size)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        customUI()
    }
    
    fileprivate func customUI() {
        if isShadowEnabled { addShadow(offset: .init(width: 0, height: 3), radius: 6, opacity: 0.2) }
    }

    override var isHighlighted: Bool {
        didSet {
            guard realBackgroundColor != .clear else { return }
            backgroundColor = isHighlighted ? realBackgroundColor?.withAlphaComponent(0.8)
                : realBackgroundColor
        }
    }
}
