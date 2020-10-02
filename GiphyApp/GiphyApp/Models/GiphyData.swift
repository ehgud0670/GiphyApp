//
//  GiphyData.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/25.
//  Copyright © 2020 jason. All rights reserved.
//

import Foundation

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
    var tags: [String]?
    var featuredTags: [String]?
    var userTags: [String]?
    let sourceTLD: String
    let sourcePostURL: String
    let isSticker: Int
    let importDatetime: String
    let trendingDatetime: String
    let images: GifImages
    var analyticsResponsePayload: String?
    var analytics: Analytics?
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
