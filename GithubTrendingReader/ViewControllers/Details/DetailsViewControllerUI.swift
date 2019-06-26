//
//  DetailsViewControllerUI.swift
//  GithubTrendingReader
//
//  Created by Laurent Grondin on 06/06/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import Foundation
import UIKit

class DetailsViewControllerUI: GlobalUI {
    
    typealias Text  = PrivateConstants.Text
    typealias Font  = PrivateConstants.Font
    typealias Rect  = PrivateConstants.Rect
    typealias Image = PrivateConstants.Image
    
    struct PrivateConstants {
        struct Text {
            static let noDataText: String = "no_repo".localized
            static let alertTitle: String = "swipe_title".localized
            static let alertMessage: String = "swipe_message".localized
        }
        struct Image {
            static let favorite: UIImage? = "favorite".image
            static let favoriteFull: UIImage? = "favorite_full".image
            static let darkModeEnabledImage: UIImage? = "moon".image
            static let darkModeDisabledImage: UIImage? = "moonFull".image
            static let rightBarButtonImage: UIImage? = "web".image
            static var leftBarButtonImage: UIImage? {
                return (Themes.isDarkModeEnabled ? Image.darkModeEnabledImage : Image.darkModeDisabledImage)
            }
        }
        struct Rect {}
        struct Font {}
    }
    
    class func collectionView(delegate: CollectionViewProtocol? = nil) -> CollectionView<Repo, DetailsCollectionViewCell> {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        return self.collectionView(layout: layout,
                                   backgroundColor: UIColor.clear,
                                   isPagingEnabled: true,
                                   noDataText: Text.noDataText,
                                   delegate: delegate)
    }
    
    class func favoriteButton(target: Any?, action: Selector?) -> UIBarButtonItem {
        return self.barButton(image: Image.favorite, target: target, action: action)
    }
}
