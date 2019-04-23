//
//  Label.swift
//  GithubTrendingReader
//
//  Created by Laurent Grondin on 23/04/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import Foundation
import UIKit

class Label: UILabel {
    
    required init(text: String = "",
                  textColor: UIColor? = nil,
                  fontSize: CGFloat,
                  isBold: Bool = false,
                  isMultiline: Bool = false) {
        super.init(frame: .zero)
        self.text = text
        self.textColor = textColor ?? getModeTextColor()
        self.font = isBold ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
        self.backgroundColor = .clear
        self.numberOfLines = isMultiline ? 0 : 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
