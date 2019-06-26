//
//  ViewControllerUI.swift
//  Papajokes
//
//  Created by Laurent Grondin on 16/05/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import Foundation
import UIKit

class ViewControllerUI: GlobalUI {
    
    typealias Text  = PrivateConstants.Text
    typealias Font  = PrivateConstants.Font
    typealias Rect  = PrivateConstants.Rect
    typealias Image = PrivateConstants.Image
    
    struct PrivateConstants {
        struct Text {
            static let searchControllerPlaceHolder: String  = "other_language".localized
            static let titleToSet: String                   = "loading".localized
            static let noDataText: String                   = "no_repo".localized
            static let segmentedControlItems: [String]      = ["daily".localized, "weekly".localized, "monthly".localized]
        }
        struct Image {
            static let darkModeEnabledImage: UIImage?       = "moon".image
            static let darkModeDisabledImage: UIImage?      = "moonFull".image
            static let rightBarButtonImage: UIImage?        = "favorite_full".image
            static var leftBarButtonImage: UIImage? {
                return (Themes.isDarkModeEnabled ? Image.darkModeEnabledImage : Image.darkModeDisabledImage)
            }
        }
        struct Rect {
            static let segmentedControlInsets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 0, right: 16)
        }
        struct Font {}
    }
    
    class func segmentedControl(selectedIndex: Int,
                          delegate: SegmentedControlDelegate? = nil) -> SegmentedControl {
        let textAttributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14, weight: .semibold)]
        return SegmentedControl(items: Text.segmentedControlItems,
                                backgroundColor: Themes.current.color, tintColor: Themes.current.textColor,
                                textAttributes: textAttributes,
                                selectedIndex: selectedIndex, delegate: delegate)
    }
    
    class func searchController<Model>(delegate: SearchControllerDelegate? = nil) -> SearchController<Model> {
        return SearchController<Model>(placeholder: Text.searchControllerPlaceHolder,
                                   tintColor: Themes.current.textColor,
                                   obscuresBackgroundDuringPresentation: false,
                                   delegate: delegate)
    }
    
    class func languagesTableView(delegate: TableViewProtocol? = nil) -> TableView<Language, LanguageTableViewCell> {
        return self.tableView(backgroundColor: Themes.current.color, sectionHeaderHeight: 44.0, alpha: 0.0, delegate: delegate)
    }
    
    class func activityIndicator() -> UIActivityIndicatorView {
        return activityIndicator(style: .white, color: Themes.current.textColor)
    }
}
