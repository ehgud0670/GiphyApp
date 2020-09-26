//
//  Shadow.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/22.
//  Copyright © 2020 jason. All rights reserved.
//

import UIKit

protocol Shadow where Self: UIView { }

extension Shadow {
    func configureShadow(
        color: UIColor = .lightGray,
        offset: CGSize = CGSize(width: 0, height: 0),
        radius: CGFloat = 5,
        opacity: Float = 0.2
    ) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
    }
}
