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
    
    func animatedImageWithRx(with urlString: String, with size: CGSize) -> Observable<UIImage> {
        return Observable.create { [weak self] emitter in
            let task = self?.loadAndMakeAnimatedImageTask(with: urlString, size: size, emitter: emitter)
            
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
    
    private func loadAndMakeAnimatedImageTask(
        with urlString: String,
        size: CGSize,
        emitter: RxSwift.AnyObserver<UIImage>
    ) -> URLSessionDataTask? {
        guard let url = URL(string: urlString) else { return nil }
        
        return self.urlSession.dataTask(with: url) { data, _, _ in
            guard let imageData = data,
                let imageSource = UIImage.imageSource(with: imageData) else { return }
            
            let cgImages = UIImage.downsizedImages(with: imageSource, for: size, scale: 3)
            guard let animatedImage = UIImage.animatedImage(with: cgImages) else { return }
            
            self.imageCache.store(animatedImage, forKey: urlString)
            emitter.onNext(animatedImage)
            emitter.onCompleted()
        }
    }
}
