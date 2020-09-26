//
//  CloseButton.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/22.
//  Copyright © 2020 jason. All rights reserved.
//

import UIKit

import Then

final class CloseButton: UIButton {
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
            let cancelImage = UIImage(systemName: "x.circle")
            $0.setImage(cancelImage, for: .normal)
            $0.imageView?.contentMode = .scaleAspectFit
            $0.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
            $0.tintColor = .black
        }
    }
}
