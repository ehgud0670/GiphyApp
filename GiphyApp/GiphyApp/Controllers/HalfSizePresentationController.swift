//
//  HalfSizePresentationController.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/22.
//  Copyright © 2020 jason. All rights reserved.
//

import UIKit

final class HalfSizePresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let realCotainerView = containerView else { return .null }
        
        let presentedViewX = realCotainerView.bounds.width * 0.15
        let presentedViewWidth = realCotainerView.bounds.width * 0.7
        let presentedViewY = realCotainerView.bounds.height * 0.28
        let presentedViewHeight = realCotainerView.bounds.height * 0.44
        
        return CGRect(x: presentedViewX,
                      y: presentedViewY,
                      width: presentedViewWidth,
                      height: presentedViewHeight)
    }
}
