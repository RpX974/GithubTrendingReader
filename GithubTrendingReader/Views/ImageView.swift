//
//  ImageView.swift
//  Papajokes
//
//  Created by Laurent Grondin on 17/05/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import UIKit

class ImageView: UIImageView {
    
    private var isRounded: Bool!
    var cornerRadius: CGFloat?
    var isShadowEnabled: Bool!

    init(image: UIImage? = nil,
         contentMode: UIView.ContentMode = .scaleAspectFill,
         tintColor: UIColor? = nil,
         cornerRadius: CGFloat? = nil,
         isRounded: Bool = false,
         isShadowEnabled: Bool = false) {
        
        super.init(image: image)
        self.contentMode = contentMode
        self.cornerRadius = cornerRadius
        self.isRounded = isRounded
        self.isShadowEnabled = isShadowEnabled
        guard let tintColor = tintColor else { return }
        self.tintColor = tintColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isRounded { self.addCornerRadius(radius: cornerRadius ?? (height/2) ) }
        if isShadowEnabled { addShadow(offset: .init(width: 0, height: 3), radius: 6, opacity: 0.2) }
    }
}
