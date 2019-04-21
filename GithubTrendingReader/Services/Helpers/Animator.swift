//
//  Animator.swift
//  GithubTrendingReader
//
//  Created by Laurent Grondin on 15/04/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import UIKit

// MARK: - Animator

class Animator {

    // MARK: - Custom Functions
    
    static func animate(animations: @escaping (()->Void), duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: ((Bool)->())?){
        DispatchQueue.main.async {
            UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: animations, completion: completion)
        }
    }
    
    static func animate(view: UIView, alpha: CGFloat, duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: ((Bool)->())?){
        DispatchQueue.main.async {
            
        }
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            view.alpha = alpha
        }, completion: completion)
    }
    
    static func animate(views: [UIView], alphas: [CGFloat], duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: ((Bool)->())?){
        DispatchQueue.main.async {
            UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                for (index, view) in views.enumerated() {
                    view.alpha = alphas[index]
                }
            }, completion: completion)
        }
    }
    
    static func animate(view: UIView, duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: ((Bool)->())?){
        DispatchQueue.main.async {
            UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                view.layoutIfNeeded()
            }, completion: completion)
        }
    }
    
    static func animate(view: UIView?, transform: CGAffineTransform , duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: ((Bool)->())?){
        guard let view = view else { return }
        DispatchQueue.main.async {
            UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                view.transform = transform
            }, completion: completion)
        }
    }
    
    static func animateReverse(view: UIView?, transform: CGAffineTransform , duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: ((Bool)->())?){
        guard let view = view else { return }
        DispatchQueue.main.async {
            UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: [.curveEaseInOut, .autoreverse], animations: {
                view.transform = transform
            }, completion: completion)
        }
    }
    
    static func addCATransition(view: UIView?, key: String = "kCATransitionFade", type: CATransitionType = CATransitionType.fade, timingFunctionName: CAMediaTimingFunctionName = CAMediaTimingFunctionName.linear, duration: TimeInterval = 0.25){
        guard let view = view else { return }
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction.init(name: timingFunctionName)
        animation.type = type
        animation.duration = duration
        DispatchQueue.main.async {
            view.layer.add(animation, forKey: key)
        }
    }
    
    static func setScrollIndicatorColor(scrollView: UIScrollView, color: UIColor) {
        for view in scrollView.subviews {
            if view.isKind(of: UIImageView.self), let imageView = view as? UIImageView  {
                imageView.image = nil
                view.backgroundColor = color
            }
        }
        DispatchQueue.main.async {
            scrollView.flashScrollIndicators()
        }
    }
}
