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
        
        return CGRect(x: realCotainerView.bounds.width * 0.1,
                      y: realCotainerView.bounds.height * 0.25,
                      width: realCotainerView.bounds.width * 0.8,
                      height: realCotainerView.bounds.height * 0.5)
    }
}
