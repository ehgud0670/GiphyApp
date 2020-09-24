//
//  UIImageExtension.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/25.
//  Copyright © 2020 jason. All rights reserved.
//
import UIKit

extension UIImage {
    static func animatedImage(with cgImages: [CGImage]) -> UIImage? {
        let images = cgImages.map { UIImage(cgImage: $0) }
        return UIImage.animatedImage(with: images, duration: 5)
    }
}
