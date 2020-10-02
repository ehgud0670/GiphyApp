//
//  GifImages.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/10/02.
//  Copyright © 2020 jason. All rights reserved.
//

import Foundation

struct GifImages: Codable {
    var original: GifImage?
    var downsized: GifImage?
    var downsizedLarge: GifImage?
    var downsizedMedium: GifImage?
    var downsizedSmall: GifImage?
    var downsizedStill: GifImage?
    var fixedHeight: GifImage?
    var fixedHeightDownsampled: GifImage?
    var fixedHeightSmall: GifImage?
    var fixedHeightSmallStill: GifImage?
    var fixedHeightStill: GifImage?
    var fixedWidth: GifImage?
    var fixedWidthDownsampled: GifImage?
    var fixedWidthSmall: GifImage?
    var fixedWidthSmallStill: GifImage?
    var fixedWidthStill: GifImage?
    var looping: GifImage?
    var originalStill: GifImage?
    var originalMP4: GifImage?
    var preview: GifImage?
    var previewGIF: GifImage?
    var previewWebp: GifImage?
    var hd: GifImage?
    var w480Still: GifImage?
    
    enum CodingKeys: String, CodingKey {
        case original
        case downsized
        case downsizedLarge = "downsized_large"
        case downsizedMedium = "downsized_medium"
        case downsizedSmall = "downsized_small"
        case downsizedStill = "downsized_still"
        case fixedHeight = "fixed_height"
        case fixedHeightDownsampled = "fixed_height_downsampled"
        case fixedHeightSmall = "fixed_height_small"
        case fixedHeightSmallStill = "fixed_height_small_still"
        case fixedHeightStill = "fixed_height_still"
        case fixedWidth = "fixed_width"
        case fixedWidthDownsampled = "fixed_width_downsampled"
        case fixedWidthSmall = "fixed_width_small"
        case fixedWidthSmallStill = "fixed_width_small_still"
        case fixedWidthStill = "fixed_width_still"
        case looping
        case originalStill = "original_still"
        case originalMP4 = "original_mp4"
        case preview
        case previewGIF = "preview_gif"
        case previewWebp = "preview_webp"
        case hd
        case w480Still = "480w_still"
    }
}
