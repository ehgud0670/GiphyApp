//
//  UIImageExtensions.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/23.
//  Copyright © 2020 jason. All rights reserved.
//

import UIKit

import Kingfisher

extension UIImageView {
    func setImage(
        urlString: String,
        with otherSize: CGSize? = nil
    ) {
        let cache = KingfisherManager.shared.cache
        let image = cache.retrieveImageInMemoryCache(forKey: urlString)
        
        if let image = image {
            self.image = image
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        let size = otherSize == nil ? self.bounds.size : otherSize!
        loadAndDownsample(with: url, for: size, scale: 3) { image in
            cache.store(image, forKey: urlString)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
    private func loadAndDownsample(
        with imageURL: URL,
        for size: CGSize,
        scale: CGFloat,
        completionHandler: @escaping (UIImage) -> Void
    ) {
        DispatchQueue.global(qos: .default).async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
            
            guard let imageSource = CGImageSourceCreateWithData(
                imageData as CFData,
                imageSourceOptions) else { return }
            
            let maxDimensionInPixels = max(size.width, size.height) * scale
            let downsampleOptions =
                [kCGImageSourceCreateThumbnailFromImageAlways: true,
                 kCGImageSourceShouldCacheImmediately: true,
                 kCGImageSourceCreateThumbnailWithTransform: true,
                 kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels] as CFDictionary
            
            guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(
                imageSource, 0, downsampleOptions) else { return }
            
            completionHandler(UIImage(cgImage: downsampledImage))
        }
    }
}
