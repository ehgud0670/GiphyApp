//
//  GifImage.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/10/02.
//  Copyright © 2020 jason. All rights reserved.
//

import Foundation

struct GifImage: Codable {
    var height: String?
    var width: String?
    var size: String?
    var url: String?
    var mp4Size: String?
    var mp4: String?
    var webpSize: String?
    var webp: String?
    var frames: String?
    var hash: String?
    
    enum CodingKeys: String, CodingKey {
        case height = "height"
        case width = "width"
        case size = "size"
        case url = "url"
        case mp4Size = "mp4_size"
        case mp4 = "mp4"
        case webpSize = "webp_size"
        case webp = "webp"
        case frames = "frames"
        case hash = "hash"
    }
}
