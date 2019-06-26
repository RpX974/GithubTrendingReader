//
//  RepoTableViewCellUI.swift
//  GithubTrendingReader
//
//  Created by Laurent Grondin on 26/06/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import UIKit

class RepoTableViewCellUI: CellUI {
    
    typealias Image = PrivateConstants.Image
    typealias Font  = PrivateConstants.Font
    typealias Rect  = PrivateConstants.Rect
    
    struct PrivateConstants {
        
        struct Image {
            static let star: UIImage? = "star".image
            static let fork: UIImage? = "fork".image
        }
        
        struct Font {
            static let nameSize: CGFloat = 20
            static let descriptionSize: CGFloat = 14
        }
        
        struct Rect {
            static let contentInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16.0)
            static let circleSize: CGSize = .init(width: 15, height: 15)
            static let forkSize: CGSize = .init(width: 12, height: 12)
            static let avatarSize: CGSize = .init(width: 20, height: 20)
        }
    }
    
    // MARK: - Labels
    
    class func nameLabel() -> Label {
        return label(fontSize: PrivateConstants.Font.nameSize, isBold: true, isMultiline: true)
    }
    
    class func descriptionLabel() -> Label {
        return label(fontSize: PrivateConstants.Font.descriptionSize, isMultiline: true)
    }
    
    class func buildByLabel() -> Label {
        return label(text: "build_by".localized)
    }
    
    // MARK: - ImageViews
    
    class func star() -> ImageView {
        return imageView(image: Image.star,
                         tintColor: Themes.current.textColor.withAlphaComponent(0.8),
                         contentMode: .scaleAspectFit)
            .withSize(Rect.circleSize)
    }
    
    class func starToday() -> ImageView {
        return imageView(image: Image.star,
                         tintColor: Themes.current.textColor.withAlphaComponent(0.8),
                         contentMode: .scaleAspectFit)
            .withSize(Rect.circleSize)
    }
    
    class func fork() -> ImageView {
        return imageView(image: Image.fork,
                         tintColor: Themes.current.textColor.withAlphaComponent(0.8),
                         contentMode: .scaleAspectFit)
            .withSize(Rect.forkSize)
    }
    
    // MARK: - Views
    
    class func circle() -> UIView {
        return UIView().withSize(Rect.circleSize)
            .withCornerRadius(Rect.circleSize.height / 2)
    }
    
    class func bottomView(firstView: UIView, secondView: UIView) -> UIView {
        let view = UIView(backgroundColor: .clear)
        view.addSubview(firstView)
        view.addSubview(secondView)
        firstView.fillSuperview().trailing?.isActive = false
        secondView.fillSuperview().leading?.isActive = false
        return view
    }
    
    class func hstack(_ views: UIView...) -> UIView {
        return self.hstack(views, spacing: 5.0, alignment: .center)
    }
}
