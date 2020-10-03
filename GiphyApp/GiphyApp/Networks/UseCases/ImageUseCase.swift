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

final class ImageUseCase {
    static let shared = ImageUseCase()
    
    private let imageCache: ImageCache
    private let urlSession: URLSession
    private let dispatchQueue = DispatchQueue(label: "imageTask.load.processing.queue")
    private let semaphore = DispatchSemaphore(value: 20)
    
    init(imageCache: ImageCache = .default, urlSession: URLSession = .shared) {
        self.imageCache = imageCache
        self.urlSession = urlSession
    }
    
    func getImageWithRx(with urlString: String, with size: CGSize) -> Observable<UIImage> {
        return Observable.create { [weak self] emitter in
            let task = self?.loadTask(with: urlString, size: size, emitter: emitter)
            
            self?.dispatchQueue.async {
                self?.semaphore.wait()
                let image = self?.imageCache.retrieveImageInMemoryCache(forKey: urlString)
                
                if let image = image {
                    emitter.onNext(image)
                    emitter.onCompleted()
                    return
                }
                
                task?.resume()
            }
            
            return Disposables.create {
                task?.cancel()
                self?.semaphore.signal()
            }
        }
    }
    
    private func loadTask(
        with urlString: String,
        size: CGSize,
        emitter: RxSwift.AnyObserver<UIImage>
    ) -> URLSessionDataTask? {
        guard let url = URL(string: urlString) else { return nil }
        
        return self.urlSession.dataTask(with: url) { data, _, _ in
            guard let imageData = data,
                let imageSource = self.imageSource(with: imageData) else { return }
            
            let cgImages = self.downsizedImages(with: imageSource, for: size, scale: 3)
            guard let animatedImage = UIImage.animatedImage(with: cgImages) else { return }
            
            self.imageCache.store(animatedImage, forKey: urlString)
            emitter.onNext(animatedImage)
            emitter.onCompleted()
        }
    }
    
    private func imageSource(with imageData: Data) -> CGImageSource? {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        
        guard let imageSource = CGImageSourceCreateWithData(
            imageData as CFData,
            imageSourceOptions) else { return nil }
        
        return imageSource
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
