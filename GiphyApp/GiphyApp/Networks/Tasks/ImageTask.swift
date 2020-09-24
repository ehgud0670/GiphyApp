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
    private var disposeBag = DisposeBag()
    private let dispatchQueue = DispatchQueue(label: "imageTask.queue", attributes: .concurrent)
    
    init(imageCache: ImageCache = .default) {
        self.imageCache = imageCache
    }
    
    func getImageWithRx(with urlString: String, with size: CGSize) -> Observable<UIImage> {
        return Observable.create { emitter in
            let cache = KingfisherManager.shared.cache
            let image = cache.retrieveImageInMemoryCache(forKey: urlString)
            
            if let image = image {
                emitter.onNext(image)
                return Disposables.create()
            }
            
            guard let url = URL(string: urlString) else { return Disposables.create() }
            self.load(with: url)
                .subscribeOn(ConcurrentDispatchQueueScheduler(queue: self.dispatchQueue))
                .flatMap { self.downsizedImages(with: $0, for: size, scale: 3) }
                .compactMap { UIImage.animatedImage(with: $0) }
                .subscribe(onNext: {
                    cache.store($0, forKey: urlString)
                    emitter.onNext($0)
                }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func load(with imageURL: URL) -> Observable<CGImageSource> {
        Observable.create { emitter in
            guard let imageData = try? Data(contentsOf: imageURL)  else { return Disposables.create() }
            let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
            
            guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, imageSourceOptions) else {
                return Disposables.create()
            }
            
            emitter.onNext(imageSource)
            return Disposables.create()
        }
    }
    
    private func downsizedImages(
        with imageSource: CGImageSource,
        for size: CGSize,
        scale: CGFloat
    ) -> Observable<[CGImage]> {
        Observable.create { emitter in
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
            emitter.onNext(cgimages)
            return Disposables.create()
        }
    }
}
