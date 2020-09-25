//
//  GiphyResponse.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/23.
//  Copyright © 2020 jason. All rights reserved.
//

import Foundation

struct GifsResponse: Codable {
    let data: [GiphyData]
    let pagination: Pagination
    let meta: Meta
}

struct GiphyData: Codable {
    let type: String
    let id: String
    let url: String
    let bitlyGifURL: String
    let bitlyURL: String
    let embedURL: String
    let username: String
    let source: String
    let title: String
    let rating: String
    let contentURL: String
    let tags: [String]
    let featuredTags: [String]
    let userTags: [String]
    let sourceTLD: String
    let sourcePostURL: String
    let isSticker: Int
    let importDatetime: String
    let trendingDatetime: String
    let images: GifImages
    let analyticsResponsePayload: String
    let analytics: Analytics
    var user: User?
    
    enum CodingKeys: String, CodingKey {
        case type
        case id
        case url
        case bitlyGifURL = "bitly_gif_url"
        case bitlyURL = "bitly_url"
        case embedURL = "embed_url"
        case username
        case source
        case title
        case rating
        case contentURL = "content_url"
        case tags
        case featuredTags =  "featured_tags"
        case userTags =  "user_tags"
        case sourceTLD =  "source_tld"
        case sourcePostURL =   "source_post_url"
        case isSticker = "is_sticker"
        case importDatetime =  "import_datetime"
        case trendingDatetime =  "trending_datetime"
        case images
        case analyticsResponsePayload = "analytics_response_payload"
        case analytics
        case user
    }
}

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

struct Analytics: Codable {
    let onLoad: Analytic
    let onClick: Analytic
    let onSent: Analytic
    
    enum CodingKeys: String, CodingKey {
        case onLoad = "onload"
        case onClick = "onclick"
        case onSent = "onsent"
    }
}

struct Analytic: Codable {
    let url: String
}

struct User: Codable {
    let avatarURL: String
    let bannerImage: String
    let bannerURL: String
    let profileURL: String
    let username: String
    let displayName: String
    let isVerified: Bool
    
    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
        case bannerImage = "banner_image"
        case bannerURL = "banner_url"
        case profileURL = "profile_url"
        case username
        case displayName = "display_name"
        case isVerified = "is_verified"
    }
}

struct Pagination: Codable {
    let totalCount: Int
    let count: Int
    let offset: Int
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case count
        case offset
    }
}

struct Meta: Codable {
    let status: Int
    let msg: String
    let responseID: String
    
    enum CodingKeys: String, CodingKey {
        case status
        case msg
        case responseID = "response_id"
    }
}
