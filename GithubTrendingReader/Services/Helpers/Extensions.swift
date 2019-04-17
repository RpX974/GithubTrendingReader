//
//  Extensions.swift
//  Way
//
//  Created by Laurent Grondin on 17/03/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import UIKit

// MARK: - Sequence
 extension Sequence {
    func find( predicate: (Self.Iterator.Element) throws -> Bool) rethrows -> Self.Iterator.Element? {
        for element in self {
            if try predicate(element) {
                return element
            }
        }
        return nil
    }
    func findIndex( predicate: (Self.Iterator.Element) throws -> Bool) rethrows -> Int? {
        var x = 0
        for element in self {
            if try predicate(element) {
                return x
            }
            x+=1
        }
        return nil
    }
}

// MARK: - Localizable
protocol Localizable {
    var localized: String { get }
}

extension String: Localizable {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

// MARK: - String
extension String {
    var image : UIImage? {
        let image = UIImage.init(named: self)
        return image
    }
    
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}

// MARK: - UIButton
extension UIButton {
    
    var font: UIFont? {
        get {
            return titleLabel?.font
        }
        set(newValue) {
            titleLabel?.font = newValue
        }
    }
    
    private func image(withColor color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        self.setBackgroundImage(image(withColor: color), for: state)
    }
}

// MARK: - UIFont
extension UIFont {
    
    static func title(size: CGFloat) -> UIFont {
        return UIFont.init(name: "GothamRounded-Bold", size: size) ?? .boldSystemFont(ofSize: size)
    }
    
    static func bold(size: CGFloat) -> UIFont {
        return .boldSystemFont(ofSize: size)
    }
    
    static func regular(size: CGFloat) -> UIFont {
        return .systemFont(ofSize: size)
    }
}

// MARK: - UIScrollView
extension UIScrollView {
    var yOffSet: CGFloat { return contentOffset.y }
    var xOffSet: CGFloat { return contentOffset.x }
    
    func setScrollIndicatorColor(color: UIColor){
        for view in self.subviews {
            if view.isKind(of: UIImageView.self), let imageView = view as? UIImageView  {
                imageView.image = nil
                view.backgroundColor = color
            }
        }
    }
    
    func scrollToTop(animated: Bool = false){
        DispatchQueue.main.async {
            self.setContentOffset(.zero, animated: animated)
        }
    }
}

// MARK: - UITableView
extension UITableView {
    func scrollToFirstItem(animated: Bool = true){
        guard self.visibleCells.count > 0 else { return }
        self.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: animated)
    }
    
    func scrollToRow(indexPath: IndexPath, at position: UITableView.ScrollPosition = .bottom, animated: Bool = true) {
        guard self.visibleCells.count > 0 else { return }
        self.scrollToRow(at: indexPath, at: position, animated: animated)
    }
}

// MARK: - UICollectionView
extension UICollectionView {
    func scrollToFirstItem(animated: Bool = true){
        guard self.visibleCells.count > 0 else { return }
        self.scrollToItem(at: IndexPath.init(row: 0, section: 0), at: .top, animated: animated)
    }
    
    func scrollToItem(indexPath: IndexPath, at position: UICollectionView.ScrollPosition = .centeredHorizontally, animated: Bool = true) {
        guard self.visibleCells.count > 0 else { return }
        self.scrollToItem(at: indexPath, at: position, animated: animated)
    }
}

// MARK: - UIView
extension UIView {
    var height: CGFloat { return frame.height }
    var width: CGFloat { return frame.width }
    var x: CGFloat { return frame.origin.x }
    var y: CGFloat { return frame.origin.y }
    
    func addShadow(offset: CGSize? = nil, radius: CGFloat = 3.0, opacity: Float = 0.15){
        self.layer.shadowPath =
            UIBezierPath(roundedRect: self.bounds,
                         cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowColor = getModeTextColor().cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset ?? CGSize.init(width: 0, height: 3)
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
    }
    
    func addCornerRadius(radius: CGFloat){
        layer.cornerRadius = radius
        clipsToBounds = true
    }
    
    static var stringClass: String {
        return "\(self)"
    }
    
    func getModeColor() -> UIColor {
        return Constants.isDarkModeEnabled ? Colors.darkMode : .white
    }
    
    func getModeTextColor() -> UIColor {
        return Constants.isDarkModeEnabled ? .white : Colors.darkMode
    }

}

// MARK: - UIViewController
 extension UIViewController {
    func addCornerRadius(radius: CGFloat) {
        self.view.layer.cornerRadius = radius
        self.view.clipsToBounds = true
    }
    
    func hideNavigationBar(_ hidden: Bool = true) {
        self.navigationController?.setNavigationBarHidden(hidden, animated: true)
    }
    
    func prefersLargeTitles(_ bool: Bool = true) {
        self.navigationController?.navigationBar.prefersLargeTitles = bool
    }
    
    func getSafeArea() -> UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero
        } else {
            return .zero
        }
    }
 
    func adjustLargeTitleSize() {
        guard let title = title, #available(iOS 11.0, *) else { return }
        
        let maxWidth = UIScreen.main.bounds.size.width - 60
        var fontSize = UIFont.preferredFont(forTextStyle: .largeTitle).pointSize
        var width = title.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]).width
        
        while width > maxWidth {
            fontSize -= 1
            width = title.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]).width
        }
        
        navigationController?.navigationBar.largeTitleTextAttributes =
            [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize)
        ]
    }
}


extension UINavigationController {
    func multiLineNavigationTitle() {
        navigationBar.subviews.forEach {
            $0.subviews.forEach { item in
                if let largeLabel = item as? UILabel {
                    largeLabel.text = navigationItem.title
                    largeLabel.numberOfLines = 0
                    largeLabel.lineBreakMode = .byWordWrapping
                }
            }
        }
    }
}

// MARK: - UILabel
extension UILabel {
    func textDropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 3.0
        self.layer.shadowOpacity = 0.25
        self.layer.shadowOffset = CGSize(width: 1, height: 2)
    }
}

// MARK: - UIColor
extension UIColor {
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }

    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    class func rbg(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        let color = UIColor.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
        return color
    }

    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

// MARK: - UISearchBar
extension UISearchBar {
    
    private func getViewElement<T>(type: T.Type) -> T? {
        
        let svs = subviews.flatMap { $0.subviews }
        guard let element = (svs.filter { $0 is T }).first as? T else { return nil }
        return element
    }
    
    func setTextFieldColor(color: UIColor) {
        
        if let textField = getViewElement(type: UITextField.self) {
            switch searchBarStyle {
            case .minimal:
                textField.layer.backgroundColor = color.cgColor
                textField.layer.cornerRadius = 6
                
            case .prominent, .default:
                textField.backgroundColor = color
            }
        }
    }
}

// MARK: - UINavigationItem
extension UINavigationItem {
    
    func setRightBarButton(image: UIImage?, target: Any?, action: Selector?, tintColor: UIColor = .black){
        let rightButtonBar = UIBarButtonItem.init(image: image, style: .plain, target: target, action: action)
        rightButtonBar.tintColor = tintColor
        self.rightBarButtonItem = rightButtonBar
    }
    
    func setLeftBarButton(image: UIImage?, target: Any?, action: Selector?, tintColor: UIColor = .black){
        let leftButtonBar = UIBarButtonItem.init(image: image, style: .plain, target: target, action: action)
        leftButtonBar.tintColor = tintColor
        self.leftBarButtonItem = leftButtonBar
    }
}

