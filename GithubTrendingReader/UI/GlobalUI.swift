//
//  GlobalUI.swift
//  Papajokes
//
//  Created by Laurent Grondin on 17/05/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import UIKit

class GlobalUI: Create {
    
    fileprivate struct PrivateConstants {
        static let defaultTopViewHeight: CGFloat = 70
        static let defaultFontSize: CGFloat = 21
        static let estimateRowHeight: CGFloat = 44.0
        static let sectionHeaderHeight: CGFloat = 44.0
    }
    
    class func tableView<Model, Cell>(backgroundColor: UIColor? = .white,
                                      rowHeight: CGFloat = UITableView.automaticDimension,
                                      estimateRowHeight: CGFloat = 44.0,
                                      sectionHeaderHeight: CGFloat = 0.0,
                                      contentInset: UIEdgeInsets = .zero,
                                      separatorStyle: UITableViewCell.SeparatorStyle = .none,
                                      alpha: CGFloat = 1.0,
                                      enableHighlight: Bool = false,
                                      noDataText: String? = nil,
                                      noDataTextInsets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16),
                                      delegate: TableViewProtocol? = nil) -> TableView<Model, Cell> {
        return TableView<Model, Cell>.init(backgroundColor: backgroundColor, rowHeight: rowHeight, estimateRowHeight: estimateRowHeight, sectionHeaderHeight: sectionHeaderHeight, contentInset: contentInset, separatorStyle: separatorStyle, alpha: alpha, enableHighlight: enableHighlight, noDataText: noDataText, noDataTextInsets: noDataTextInsets, delegate: delegate)
    }
    
    class func collectionView<Model, Cell>(frame: CGRect = .zero,
                                           layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout(),
                                           backgroundColor: UIColor? = .white,
                                           contentInset: UIEdgeInsets = .zero,
                                           isPagingEnabled: Bool = false,
                                           isPrefetchingEnabled: Bool = true,
                                           contentInsetAdjustmentBehavior: UIScrollView.ContentInsetAdjustmentBehavior = .never,
                                           bounces: Bool = true,
                                           alpha: CGFloat = 1.0,
                                           noDataText: String? = nil,
                                           noDataTextInsets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16),
                                           delegate: CollectionViewProtocol? = nil) -> CollectionView<Model, Cell> {
        return CollectionView<Model, Cell>.init(frame: frame, layout: layout,
                                                backgroundColor: backgroundColor,
                                                contentInset: contentInset,
                                                isPagingEnabled: isPagingEnabled, isPrefetchingEnabled: isPrefetchingEnabled,
                                                contentInsetAdjustmentBehavior: contentInsetAdjustmentBehavior,
                                                bounces: bounces, alpha: alpha,
                                                noDataText: noDataText, noDataTextInsets: noDataTextInsets,
                                                delegate: delegate)
        
    }
    
    class func activityIndicator(style: UIActivityIndicatorView.Style = .white,
                                 color: UIColor = .black) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: style)
        activityIndicator.color = color
        return activityIndicator
    }
    
    class func barButton(image: UIImage?, style: UIBarButtonItem.Style = .plain, target: Any?, action: Selector?) -> UIBarButtonItem {
        return UIBarButtonItem(image: image, style: style, target: target, action: action)
    }
}
