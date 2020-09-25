//
//  Meta.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/25.
//  Copyright © 2020 jason. All rights reserved.
//

import Foundation

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
