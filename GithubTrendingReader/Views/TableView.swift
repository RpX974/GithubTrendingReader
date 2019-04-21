//
//  TableViewController.swift
//  GithubTrendingReader
//
//  Created by Laurent Grondin on 16/04/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Protocol

protocol TableViewProtocol: class {
    func setDataSource(_ tableView: UITableView) -> [[Decodable]?]?
    func setTitleHeaders(_ tableView: UITableView) -> [String]?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, cell: UITableViewCell, data: Decodable?) -> UITableViewCell?
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat?
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, data: Decodable?)
    func tableViewDidScroll(_ scrollView: UIScrollView, isScrollViewDown: Bool)
    func tableViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>, isScrollingDown: Bool)
}

// MARK: - Protocol Optional Methods

extension TableViewProtocol {
    func setTitleHeaders(_ tableView: UITableView) -> [String]? { return nil }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, cell: UITableViewCell, data: Decodable?) -> UITableViewCell? { return nil }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat? { return nil }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {}
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, data: Decodable?) {}
    func tableViewDidScroll(_ scrollView: UIScrollView, isScrollViewDown: Bool) {}
    func tableViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>, isScrollingDown: Bool) {}
}

// MARK: - GenericCell

protocol GenericTableViewCellProtocol {
    associatedtype Data
    func configure(with data: Data?)
}

class GenericTableViewCell<Data: Decodable>: UITableViewCell, GenericTableViewCellProtocol {
    func configure(with data: Data?) {}
}

class TableView<Data: Decodable, CellType: GenericTableViewCell<Data>>: UITableView, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Deinit

    deinit {
        NotificationCenter.default.removeObserver(self)
        log_done()
    }
    
    // MARK: - Views

    fileprivate lazy var noDataLabel: UILabel = {
        let label = UILabel()
        label.font = .bold(size: 20)
        label.textAlignment = .left
        label.textColor = getModeTextColor()
        label.isHidden = true
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Properties
    
    fileprivate var _dataSource: [[Data]?]? {
        return self.globalDelegate?.setDataSource(self) as? [[Data]]
    }
    
    fileprivate var titleHeaders: [String]? {
        return self.globalDelegate?.setTitleHeaders(self)
    }

    fileprivate var defaultYOffset: CGFloat {
        if UIDevice.current.orientation.isPortrait, let portraitYOffset = portraitYOffset {
            return portraitYOffset
        } else if let landscapeYOffset = landscapeYOffset {
            return landscapeYOffset
        }
        return 0
    }

    fileprivate var portraitYOffset: CGFloat?
    fileprivate var landscapeYOffset: CGFloat?

    fileprivate lazy var lastYOffset: CGFloat = self.defaultYOffset
    fileprivate lazy var currentOrientation: UIDeviceOrientation = .portrait

    fileprivate var enableHighlight: Bool?
    var isUpdateScrollViewEnabled = true

    weak var globalDelegate: TableViewProtocol?
    
    // MARK: - Initializers
    
    convenience init(){
        self.init(nil)
    }
    
    convenience init(_ removeOrNil: Bool? = nil,
                     backgroundColor: UIColor? = .white,
                     rowHeight: CGFloat = UITableView.automaticDimension,
                     estimateRowHeight: CGFloat = 44.0,
                     sectionHeaderHeight: CGFloat = 0.0,
                     contentInset: UIEdgeInsets = .zero,
                     separatorStyle: UITableViewCell.SeparatorStyle = .none,
                     alpha: CGFloat = 1.0,
                     enableHighlight: Bool = false,
                     noDataText: String? = nil,
                     noDataTextInsets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)) {
        self.init(frame: .zero)
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = backgroundColor
        self.rowHeight = rowHeight
        self.estimatedRowHeight = estimateRowHeight
        self.sectionHeaderHeight = sectionHeaderHeight
        self.contentInset = contentInset
        self.separatorStyle = separatorStyle
        self.alpha = alpha
        self.enableHighlight = enableHighlight
        self.register(CellType.self, forCellReuseIdentifier: CellType.stringClass)
        self.addNoDataLabel(noDataText: noDataText, insets: noDataTextInsets)
        NotificationCenter.default.addObserver(self, selector: #selector(self.orientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        switch UIDevice.current.orientation {
        case .portrait:
            if portraitYOffset == nil { portraitYOffset = yOffSet }
        default:
            if landscapeYOffset == nil { landscapeYOffset = yOffSet }
        }
        self.setScrollIndicatorColor(color: self.getModeTextColor())
    }
    
    fileprivate func addNoDataLabel(noDataText: String?, insets: UIEdgeInsets){
        guard let text = noDataText else { return }
        self.noDataLabel.text = text
        self.addSubview(noDataLabel)
        self.noDataLabel.centerXToSuperview()
        self.noDataLabel.edgesToSuperview(excluding: [.top, .bottom], insets: insets)
        self.noDataLabel.topToSuperview(offset: insets.top)
    }
    
    // MARK: - Custom Functions
    
    @objc fileprivate func orientationChanged() {
        currentOrientation = UIDevice.current.orientation
    }
    
    func register(cellClasses: [UITableViewCell.Type]){
        cellClasses.forEach({self.register($0.self, forCellReuseIdentifier: $0.stringClass)})
    }
    
    func getData(with indexPath: IndexPath) -> Data?{
        guard let dataSource = _dataSource, let data = dataSource[indexPath.section] else { return nil }
        if indexPath.section < dataSource.count && indexPath.row < data.count {
            return data[indexPath.item]
        }
        return nil
    }
    
    func showNoDataLabel(count: Int){
        noDataLabel.isHidden = count > 0 ? true : false
    }
    
    // MARK: - DATASOURCE
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return _dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = _dataSource?[section]?.count ?? 0
        showNoDataLabel(count: count)
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellType.stringClass, for: indexPath) as? CellType
            else { return CellType() }
        let data = getData(with: indexPath)
        cell.configure(with: data)
        guard let overrideCell = self.globalDelegate?.tableView(tableView, cellForRowAt: indexPath, cell: cell, data: data) else {
            return cell
        }
        return overrideCell
    }
    
    // MARK: - DELEGATE
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = getData(with: indexPath)
        self.globalDelegate?.tableView(tableView, didSelectRowAt: indexPath, data: data)
    }
    
    // MARK: - HEADER
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let overrideHeight = self.globalDelegate?.tableView(tableView, heightForHeaderInSection: section)
        else { return tableView.sectionHeaderHeight }
        return overrideHeight
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleHeaders?[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        self.globalDelegate?.tableView(tableView, willDisplayHeaderView: view, forSection: section)
    }
    
    // MARK: - HIGHLIGHT
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        guard enableHighlight == true, let cell = tableView.cellForRow(at: indexPath) else { return true }
        Animator.animate(view: cell, transform: .init(scaleX: 0.95, y: 0.95), completion: nil)
        return true
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard enableHighlight == true, let cell = tableView.cellForRow(at: indexPath) else { return }
        Animator.animate(view: cell, transform: .identity, completion: nil)
    }
    
    // MARK: - SCROLLVIEW

    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if scrollView.contentOffset.y <= defaultYOffset || targetContentOffset.pointee.y < scrollView.contentOffset.y {
            // move up
            self.globalDelegate?.tableViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset, isScrollingDown: false)
        } else {
            // move down
            self.globalDelegate?.tableViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset, isScrollingDown: true)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.yOffSet == defaultYOffset {
            self.globalDelegate?.tableViewDidScroll(scrollView, isScrollViewDown: false)
        } else if lastYOffset > scrollView.contentOffset.y && lastYOffset < scrollView.contentSize.height - scrollView.frame.height {
            // move up
            self.globalDelegate?.tableViewDidScroll(scrollView, isScrollViewDown: false)
        } else if lastYOffset < scrollView.contentOffset.y && scrollView.contentOffset.y > 0 {
            // move down
            self.globalDelegate?.tableViewDidScroll(scrollView, isScrollViewDown: true)
        }
        lastYOffset = scrollView.contentOffset.y
    }
    
    @objc override func scrollToTop(animated: Bool = true) {
        log_info("TableView scolled to top")
        DispatchQueue.main.async {
            self.setContentOffset(.init(x: 0, y: self.defaultYOffset), animated: animated)
        }
    }
}
