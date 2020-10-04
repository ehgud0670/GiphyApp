//
//  UIImageExtension.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/25.
//  Copyright © 2020 jason. All rights reserved.
//
import UIKit

extension UIImage {
    static func animatedImage(with cgImages: [CGImage], source: CGImageSource) -> UIImage? {
        let delays = Self.delays(with: source, count: cgImages.count)
        let duration = Self.duration(with: delays)
        let gcd = Self.gcd(for: delays)
        let frames = Self.frames(with: cgImages, delays: delays, gcd: gcd)
        
        return UIImage.animatedImage(with: frames, duration: Double(duration) / 1000.0)
    }
    
    private static func delays(with source: CGImageSource, count: Int) -> [Int] {
        let delays = (0 ..< count)
            .map { delayForImage(at: $0, source: source)}
            .map { Int($0 * 1000.0) }
        return delays
    }
    
    private static func delayForImage(at index: Int, source: CGImageSource) -> Double {
        var delay = 0.01
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(
                cfProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()
            ),
            to: CFDictionary.self
        )
        
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(
                gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()
            ),
            to: AnyObject.self)
        
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(
                CFDictionaryGetValue(
                    gifProperties,
                    Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()
                ),
                to: AnyObject.self)
        }
        
        delay = delayObject as? Double ?? 0
        
        if delay < 0.01 {
            delay = 0.01
        }
        
        return delay
    }
    
    private static func duration(with delays: [Int]) -> Int {
        let sum = delays.reduce(0) { $0 + $1 }
        return sum
    }
    
    // GCD: 최대공약수 Great Common Divisor
    private static func gcd(for array: [Int]) -> Int {
        guard !array.isEmpty else { return 1 }
        
        var gcd = array[0]
        for value in array {
            gcd = gcdForPair(lhs: value, rhs: gcd)
        }
    
        return gcd
    }
    
    // GCD: 최대공약수 Great Common Divisor
    private static func gcdForPair(lhs: Int, rhs: Int) -> Int {
        var lhs = lhs
        var rhs = rhs
        if lhs < rhs {
            let temp = lhs
            lhs = rhs
            rhs = temp
        }
        
        var rest: Int
        while true {
            rest = lhs % rhs
            guard rest != 0 else { break }
            
            lhs = rhs
            rhs = rest
            
        }
        return rhs
    }
    
    private static func frames(with cgImages: [CGImage], delays: [Int], gcd: Int) -> [UIImage] {
        var frames = [UIImage]()
        (0 ..< cgImages.count).forEach {
            let frame = UIImage(cgImage: cgImages[$0])
            let frameCount = Int(delays[$0] / gcd)
            
            (0 ..< frameCount).forEach { _ in
                frames.append(frame)
            }
        }
        return frames
    }
    
    static func imageSource(with imageData: Data) -> CGImageSource? {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        
        guard let imageSource = CGImageSourceCreateWithData(
            imageData as CFData,
            imageSourceOptions) else { return nil }
        
        return imageSource
    }
    
    static func downsizedImages(
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
