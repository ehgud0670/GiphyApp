//
//  ImageUsecase.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/25.
//  Copyright © 2020 jason. All rights reserved.
//

import UIKit

import Kingfisher
import RxSwift

final class ImageTask {
    private let imageCache: ImageCache
    
    init(imageCache: ImageCache = .default) {
        self.imageCache = imageCache
    }
    
    func getImageWithRx(with urlString: String,
                        with size: CGSize) -> Observable<UIImage> {
        return Observable.create { emitter in
            let cache = KingfisherManager.shared.cache
            let image = cache.retrieveImageInMemoryCache(forKey: urlString)
            
            if let image = image {
                emitter.onNext(image)
                return Disposables.create()
            }
            
            guard let url = URL(string: urlString) else { return Disposables.create() }
            self.loadAndDownsample(with: url, for: size, scale: 3) { image in
                cache.store(image, forKey: urlString)
                emitter.onNext(image)
            }
            return Disposables.create()
        }
    }

    private func loadAndDownsample(
        with imageURL: URL,
        for size: CGSize,
        scale: CGFloat,
        completionHandler: @escaping (UIImage) -> Void
    ) {
        DispatchQueue.global(qos: .userInitiated).async {
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
