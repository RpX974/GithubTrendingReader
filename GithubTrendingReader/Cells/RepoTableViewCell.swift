//
//  RepoTableViewCell.swift
//  GithubTrendingReader
//
//  Created by Laurent Grondin on 13/04/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class RepoTableViewCell: GenericTableViewCell<Repo> {
    
    // MARK: - Deinit
    
    deinit {
        log_done()
    }
    
    // MARK: - Constants

    struct PrivateConstants {
        static let contentInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16.0)
        static let circleSize: CGFloat = 15
        static let avatarSize: CGFloat = 20
        static let forkSize: CGFloat = 12
        
        struct Image {
            static let star: UIImage? = "star".image
            static let fork: UIImage? = "fork".image
        }
    }
    
    // MARK: - Properties
    
    // MARK: - Views
    
    // MARK: - Labels

    lazy var nameLabel: Label = {
        let label = Label.init(fontSize: 20, isBold: true, isMultiline: true)
        return label
    }()
    
    lazy var descriptionLabel: Label = {
        let label = Label.init(fontSize: 14, isBold: false, isMultiline: true)
        return label
    }()
    
    lazy var languageLabel: Label = {
        let label = Label.init(fontSize: 12, isBold: false)
        return label
    }()

    lazy var starLabel: Label = {
        let label = Label.init(fontSize: 12, isBold: false)
        return label
    }()
    
    lazy var starTodayLabel: Label = {
        let label = Label.init(fontSize: 12, isBold: false)
        return label
    }()
    
    lazy var forkLabel: Label = {
        let label = Label.init(fontSize: 12, isBold: false)
        return label
    }()
    
    lazy var buildByLabel: Label = {
        let label = Label.init(text: "build_by".localized, fontSize: 12, isBold: false)
        return label
    }()
    
    // MARK: - ImageViews

    lazy var star: UIImageView = {
        let iv = UIImageView.init(image: PrivateConstants.Image.star)
        iv.height(PrivateConstants.circleSize)
        iv.width(PrivateConstants.circleSize)
        iv.contentMode = .scaleAspectFit
        iv.tintColor = iv.getModeTextColor().withAlphaComponent(0.8)
        return iv
    }()

    lazy var starToday: UIImageView = {
        let iv = UIImageView.init(image: PrivateConstants.Image.star)
        iv.height(PrivateConstants.circleSize)
        iv.width(PrivateConstants.circleSize)
        iv.contentMode = .scaleAspectFit
        iv.tintColor = iv.getModeTextColor().withAlphaComponent(0.8)
        return iv
    }()
    
    lazy var fork: UIImageView = {
        let iv = UIImageView.init(image: PrivateConstants.Image.fork)
        iv.height(PrivateConstants.forkSize)
        iv.width(PrivateConstants.forkSize)
        iv.contentMode = .scaleAspectFit
        iv.tintColor = iv.getModeTextColor().withAlphaComponent(0.8)
        return iv
    }()
    
    
    // MARK: - UIViews
    
    let shadowView = UIView()

    lazy var circle: UIView = {
        let v = UIView()
        v.height(PrivateConstants.circleSize)
        v.width(PrivateConstants.circleSize)
        v.addCornerRadius(radius: PrivateConstants.circleSize/2)
        return v
    }()
    
    lazy var bottomView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.addSubview(buildByStackView)
        v.addSubview(starTodayStackView)
        starTodayStackView.edgesToSuperview(excluding: .left)
        buildByStackView.edgesToSuperview(excluding: .right)
        return v
    }()

    // MARK: - StackViews
    
    lazy var languageStackView: HorizontalStackView = {
        let stack = HorizontalStackView(arrangedSubviews: [circle, languageLabel])
        return stack
    }()
    
    lazy var starStackView: HorizontalStackView = {
        let stack = HorizontalStackView(arrangedSubviews: [star, starLabel])
        return stack
    }()

    lazy var starTodayStackView: HorizontalStackView = {
        let stack = HorizontalStackView(arrangedSubviews: [starToday, starTodayLabel])
        return stack
    }()

    lazy var forkStackView: HorizontalStackView = {
        let stack = HorizontalStackView(arrangedSubviews: [fork, forkLabel])
        return stack
    }()
    
    lazy var buildByStackView: HorizontalStackView = {
        let stack = HorizontalStackView(arrangedSubviews: [])
        return stack
    }()
    
    lazy var horizontalStackView: HorizontalStackView = {
        let stack = HorizontalStackView(arrangedSubviews: [languageStackView, starStackView, forkStackView])
        stack.spacing = 10
        return stack
    }()
    
    lazy var stackView: VerticalStackView = {
        let stack = VerticalStackView(arrangedSubviews: [nameLabel, descriptionLabel, horizontalStackView, bottomView])
        return stack
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        shadowView.addCornerRadius(radius: 7)
        shadowView.addShadow(offset: CGSize.init(width: 0, height: 2), radius: 5, opacity: 0.3)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bottomView.sizeToFit()
        buildByStackView.sizeToFit()
    }
    
    // MARK: - Layout
    fileprivate func setupUI(){
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        backgroundColor = getModeColor()
        selectionStyle = .none
        shadowView.backgroundColor = getModeColor()
        shadowView.addSubview(stackView)
        contentView.addSubview(shadowView)
    }
    
    fileprivate func setupConstraints() {
        shadowView.edgesToSuperview(excluding: .none, insets: PrivateConstants.contentInsets)
        stackView.edgesToSuperview(excluding: .none, insets: PrivateConstants.contentInsets)
        bottomView.widthToSuperview()
    }
    
    // MARK: - View Configuration
    
    override func configure(with data: Repo?) {
        guard let data = data else { return }
        self.nameLabel.attributedText = data.getTitle()
        self.descriptionLabel.text = data.description
        self.circle.backgroundColor = data.getColor() ?? getModeColor()
        self.languageLabel.text = data.language ?? "unknown".localized
        self.starLabel.text = data.stars.description
        self.forkLabel.text = data.forks.description
        self.starTodayLabel.text = String(format: data.currentPeriodStars > 1 ? "stars_today".localized : "star_today".localized, data.currentPeriodStars)
        self.createBuildByImageViews(data: data)
        self.buildByStackView.isHidden = data.builtBy.count > 0 ? false : true
    }
    
    fileprivate func createBuildByImageViews(data: Repo){
        self.buildByStackView.arrangedSubviews.forEach( {
            if $0.isKind(of: UIImageView.self) {
                $0.removeFromSuperview()
            }
        })
        let ivs: [UIImageView] = data.builtBy.map { (buildBy) in
            let iv = UIImageView()
            iv.height(PrivateConstants.avatarSize)
            iv.width(PrivateConstants.avatarSize)
            iv.backgroundColor = .clear
            iv.addCornerRadius(radius: 2)
            self.buildByStackView.addArrangedSubview(iv)
            return iv
        }
        if ivs.count > 0 {
            switch UIScreen.main.sizeType {
            case .iPhone4, .iPhone5:
                horizontalStackView.addArrangedSubview(buildByLabel)
            default:
                buildByStackView.insertArrangedSubview(buildByLabel, at: 0)
            }
        }
        DispatchQueue.global().async {
            for (index, iv) in ivs.enumerated() {
                let url = URL(string: data.builtBy[index].avatar)
                iv.sd_setImage(with: url, placeholderImage: nil, options: [SDWebImageOptions.scaleDownLargeImages, SDWebImageOptions.highPriority], completed: nil)
            }
        }
    }
}
