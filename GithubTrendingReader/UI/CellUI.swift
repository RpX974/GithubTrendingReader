//
//  CellUI.swift
//  GithubTrendingReader
//
//  Created by Laurent Grondin on 26/06/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import UIKit

class CellUI: Create {
    
    class func label(text: String? = nil, fontSize: CGFloat = 12, isBold: Bool = false, isMultiline: Bool = false) -> Label {
        return self.label(text: text, fontSize: fontSize, isBold: isBold, isMultiline: isMultiline, dropShadow: false)
    }
}
