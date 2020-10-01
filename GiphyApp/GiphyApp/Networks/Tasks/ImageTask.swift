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
    private let dispatchQueue = DispatchQueue.global(qos: .utility)
    
    init(imageCache: ImageCache = .default) {
        self.imageCache = imageCache
    }
    
    func getImageWithRx(with urlString: String, with size: CGSize) -> Observable<UIImage> {
        return Observable.create { [weak self] emitter in
            self?.dispatchQueue.async {
                let image = self?.imageCache.retrieveImageInMemoryCache(forKey: urlString)
                
                if let image = image {
                    emitter.onNext(image)
                    return
                }
                
                guard let url = URL(string: urlString) else { return }
                self?.load(with: url) { imageResource in
                    guard let cgImages = self?.downsizedImages(with: imageResource, for: size, scale: 3),
                    let animatedImage = UIImage.animatedImage(with: cgImages) else { return }
                    
                    self?.imageCache.store(animatedImage, forKey: urlString)
                    emitter.onNext(animatedImage)
                    return
                }
            }
            return Disposables.create()
        }
    }
    
    private func load(with imageURL: URL, completionHandler: @escaping (CGImageSource) -> Void) {
        guard let imageData = try? Data(contentsOf: imageURL)  else { return }
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        
        guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, imageSourceOptions) else { return }
        
        completionHandler(imageSource)
    }
    
    private func downsizedImages(
        with imageSource: CGImageSource,
        for size: CGSize,
        scale: CGFloat
    ) -> [CGImage] {
        let maxDimensionInPixels = max(size.width, size.height) * scale
        let downsampleOptions =
            [kCGImageSourceCreateThumbnailFromImageAlways: true,
             kCGImageSourceShouldCacheImmediately: true,
             kCGImageSourceCreateThumbnailWithTransform: true,
             kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels] as CFDictionary
        
        let count = CGImageSourceGetCount(imageSource)
        let cgimages = (0 ..< count).compactMap {
            CGImageSourceCreateThumbnailAtIndex(imageSource, $0, downsampleOptions)
        }
        return cgimages
    }
}
