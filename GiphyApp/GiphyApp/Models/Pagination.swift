//
//  Pagination.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/25.
//  Copyright © 2020 jason. All rights reserved.
//

import Foundation

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
