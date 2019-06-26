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
    
    
    // MARK: - Typealias
    
    typealias Create = RepoTableViewCellUI

    
    // MARK: - Deinit
    
    deinit {
        log_done()
    }
    
    // MARK: - Properties
    // MARK: - Views
    
    // MARK: - Labels

    let nameLabel                   = Create.nameLabel()
    let descriptionLabel            = Create.descriptionLabel()
    let languageLabel               = Create.label()
    let starLabel                   = Create.label()
    let starTodayLabel              = Create.label()
    let forkLabel                   = Create.label()
    let buildByLabel                = Create.buildByLabel()
    
    // MARK: - ImageViews
    
    let star                        = Create.star()
    let starToday                   = Create.starToday()
    let fork                        = Create.fork()
    
    // MARK: - UIViews
    
    let shadowView                  = UIView()
    let circle                      = Create.circle()
    lazy var bottomView             = Create.bottomView(firstView: buildByStackView, secondView: starTodayStackView)

    // MARK: - StackViews
    
    lazy var languageStackView      = Create.hstack(circle, languageLabel)
    lazy var starStackView          = Create.hstack(star, starLabel)

    lazy var starTodayStackView     = Create.hstack(starToday, starTodayLabel)
    lazy var forkStackView          = Create.hstack(fork, forkLabel)
    lazy var buildByStackView       = hstack(spacing: 5.0, alignment: .center)

    lazy var horizontalStackView    = hstack(languageStackView, starStackView, forkStackView, spacing: 10.0, alignment: .center)
    lazy var stackView              = Create.stack(nameLabel, descriptionLabel, horizontalStackView, bottomView,
                                                   spacing: 5.0, alignment: .leading)
    
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
    
    fileprivate func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        backgroundColor = Themes.current.color
        selectionStyle = .none
        shadowView.backgroundColor = Themes.current.color
        contentView.addSubview(shadowView)
        shadowView.addSubview(stackView)
    }
    
    fileprivate func setupConstraints() {
        shadowView.fillSuperview(padding: Create.Rect.contentInsets)
        stackView.fillSuperview(padding: Create.Rect.contentInsets)
        bottomView.widthToSuperView()
    }
    
    // MARK: - View Configuration
    
    override func configure(with data: Repo?) {
        guard let data = data else { return }
        self.nameLabel.attributedText = data.getTitle()
        self.descriptionLabel.text = data.description
        self.circle.backgroundColor = data.getColor() ?? Themes.current.color
        self.languageLabel.text = data.language ?? "unknown".localized
        self.starLabel.text = data.stars.description
        self.forkLabel.text = data.forks.description
        self.starTodayLabel.text = String(format: data.currentPeriodStars > 1 ? "stars_today".localized : "star_today".localized, data.currentPeriodStars)
        self.createBuildByImageViews(data: data)
        self.buildByStackView.isHidden = data.builtBy.count > 0 ? false : true
    }
    
    fileprivate func createBuildByImageViews(data: Repo) {
        if self.buildByStackView.arrangedSubviews.count > 0 { return }
        self.buildByStackView.arrangedSubviews.forEach({
            if $0.isKind(of: UIImageView.self) {
                $0.removeFromSuperview()
            }
        })
        let imageViews: [UIImageView] = data.builtBy.map { _ in
            let imageView = UIImageView()
            imageView.withSize(Create.Rect.avatarSize)
            imageView.backgroundColor = .clear
            imageView.addCornerRadius(radius: 2)
            self.buildByStackView.addArrangedSubview(imageView)
            return imageView
        }
        if imageViews.count > 0 {
            switch UIScreen.main.sizeType {
            case .iPhone4, .iPhone5:
                horizontalStackView.addArrangedSubview(buildByLabel)
            default:
                buildByStackView.insertArrangedSubview(buildByLabel, at: 0)
            }
        }
        DispatchQueue.global().async {
            for (index, elem) in imageViews.enumerated() {
                let url = URL(string: data.builtBy[index].avatar)
                elem.sd_setImage(with: url, placeholderImage: nil, options: [SDWebImageOptions.scaleDownLargeImages, SDWebImageOptions.highPriority], completed: nil)
            }
        }
    }
}
