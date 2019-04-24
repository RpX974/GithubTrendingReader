//
//  CollectionView.swift
//  GithubTrendingReader
//
//  Created by Laurent Grondin on 17/04/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import UIKit

// MARK: - Protocol

protocol CollectionViewProtocol: class {
    func setDataSource(_ collectionView: UICollectionView) -> [[Decodable]?]?
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath, data: Decodable?)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, cell: UICollectionViewCell, data: Decodable?) -> UICollectionViewCell?
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView, currentIndex: Int)
}

// MARK: - Protocol Optional Methods

extension CollectionViewProtocol {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath, data: Decodable?) {}
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, cell: UICollectionViewCell, data: Decodable?) -> UICollectionViewCell? { return nil }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView, currentIndex: Int) {}
}

// MARK: - GenericCell

class GenericCollectionViewCell<Data: Decodable>: UICollectionViewCell {
    func configure(with data: Data?) {}
}

// MARK: - CollectionView

class CollectionView<Data: Decodable, CellType: GenericCollectionViewCell<Data>>: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Deinit
    
    deinit {
        log_done()
    }

    // MARK: - Views

    fileprivate lazy var noDataLabel: UILabel = {
        let label = UILabel()
        label.font = .bold(size: 20)
        label.textAlignment = .left
        label.isHidden = true
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Properties
    
    fileprivate var _dataSource: [[Data]?]? {
        return self.globalDelegate?.setDataSource(self) as? [[Data]]
    }
    
    fileprivate var defaultYOffset: CGFloat = 0.0
    weak var globalDelegate: CollectionViewProtocol?
    
    // MARK: - Initializers
    
    convenience init(frame: CGRect = .zero,
                     layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout(),
                     backgroundColor: UIColor? = .white,
                     contentInset: UIEdgeInsets = .zero,
                     isPagingEnabled: Bool = false,
                     isPrefetchingEnabled: Bool = true,
                     contentInsetAdjustmentBehavior: UIScrollView.ContentInsetAdjustmentBehavior = .never,
                     bounces: Bool = true,
                     alpha: CGFloat = 1.0,
                     noDataText: String? = nil,
                     noDataTextInsets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)) {
        self.init(frame: frame, collectionViewLayout: layout)
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = backgroundColor
        self.bounces = bounces
        self.isPagingEnabled = isPagingEnabled
        self.isPrefetchingEnabled = isPrefetchingEnabled
        self.contentInsetAdjustmentBehavior = contentInsetAdjustmentBehavior
        self.contentInset = contentInset
        self.alpha = alpha
        self.register(CellType.self, forCellWithReuseIdentifier: CellType.stringClass)
        self.addNoDataLabel(noDataText: noDataText, insets: noDataTextInsets)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        defaultYOffset = yOffSet > 0.0 ? 0.0 : yOffSet
    }
    
    fileprivate func addNoDataLabel(noDataText: String?, insets: UIEdgeInsets) {
        guard let text = noDataText else { return }
        self.noDataLabel.text = text
        self.addSubview(noDataLabel)
        self.noDataLabel.centerXToSuperview()
        self.noDataLabel.edgesToSuperview(excluding: [.top, .bottom], insets: insets)
        self.noDataLabel.topToSuperview(offset: insets.top)
    }
    
    // MARK: - Custom Functions
    
    func getData(with indexPath: IndexPath) -> Data? {
        guard let dataSource = _dataSource, let data = dataSource[indexPath.section] else { return nil }
        if indexPath.section < dataSource.count && indexPath.row < data.count {
            return data[indexPath.item]
        }
        return nil
    }
    
    func showNoDataLabel(count: Int) {
        noDataLabel.isHidden = count > 0 ? true : false
    }

    // MARK: - DATASOURCE
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return _dataSource?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = _dataSource?[section]?.count ?? 0
        showNoDataLabel(count: count)
        return count
    }
    
    // MARK: - DELEGATE
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellType.stringClass, for: indexPath) as? CellType
            else { return CellType() }
        let data = getData(with: indexPath)
        cell.configure(with: data)
        guard let overrideCell = self.globalDelegate?.collectionView(collectionView, cellForItemAt: indexPath, cell: cell, data: data) else {
            return cell
        }
        return overrideCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = getData(with: indexPath)
        self.globalDelegate?.collectionView(collectionView, didSelectItemAt: indexPath, data: data)
    }
    
    // MARK: - FLOW_LAYOUT
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    // MARK: - ScrollView
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewDidEndDecelerating(scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        visibleRect.origin = self.contentOffset
        visibleRect.size = self.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let visibleIndexPath: IndexPath = self.indexPathForItem(at: visiblePoint) else { return }
        log_info("CollectionView scrolled to cell at \(visibleIndexPath)")
        globalDelegate?.scrollViewDidEndDecelerating(scrollView, currentIndex: visibleIndexPath.item)
    }
    
    @objc override func scrollToTop(animated: Bool = true) {
        DispatchQueue.main.async {
            self.setContentOffset(.init(x: 0, y: self.defaultYOffset), animated: animated)
        }
    }
}
