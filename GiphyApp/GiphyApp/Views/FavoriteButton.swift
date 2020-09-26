//
//  FavoriteButton.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/24.
//  Copyright © 2020 jason. All rights reserved.
//

import UIKit

import Then

final class FavoriteButton: UIButton {
    private var bounceAnimation: CAKeyframeAnimation = {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.4, 0.9, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(0.3)
        bounceAnimation.calculationMode = .cubic
        return bounceAnimation
    }()
    
    var isFavorited: Bool = false {
        didSet { setAttribute(isFavorited: isFavorited) }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureAttributes()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureAttributes()
    }
    
    private func configureAttributes() {
        self.do {
            $0.imageView?.contentMode = .scaleAspectFit
            $0.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        }
        
        self.do {
            let normalImage = UIImage(
                systemName: "star"
                )?.withRenderingMode(.alwaysTemplate)
            $0.setImage(normalImage, for: .normal)
        }
        
        self.do {
            let selectedImage = UIImage(
                systemName: "star.fill"
                )?.withRenderingMode(.alwaysTemplate)
            $0.setImage(selectedImage, for: .selected)
        }
        
        tintColor = .systemYellow
    }
    
    private func setAttribute(isFavorited: Bool) {
        isSelected = isFavorited
        layer.add(bounceAnimation, forKey: nil)
    }
}
