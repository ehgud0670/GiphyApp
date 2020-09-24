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
    func setImageWithMemoryCache(urlString: String, placeholder: Placeholder?) {
        let cache = KingfisherManager.shared.cache
        let image = cache.retrieveImageInMemoryCache(forKey: urlString)
        
        if let image = image {
            self.image = image
            return
        }
        
        guard let url = URL(string: urlString) else { return}
        
        self.kf.setImage(with: url, placeholder: placeholder) { response in
            switch response {
            case .success(let result):
                self.image = result.image
                cache.store(result.image, forKey: urlString)
            default:
                break
            }
        }
    }
}
