//
//  User.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/10/02.
//  Copyright © 2020 jason. All rights reserved.
//

import Foundation

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
