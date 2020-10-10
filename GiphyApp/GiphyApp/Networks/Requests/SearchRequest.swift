//
//  SearchRequest.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/23.
//  Copyright © 2020 jason. All rights reserved.
//

import Foundation

struct SearchRequest: GiphysRequest {
    private let query: String
    private let offset: String
    
    init(query: String, offset: Int = 0) {
        self.query = query
        self.offset = String(offset)
    }
    
    var path: String { "https://api.giphy.com/v1/gifs/search" }
    var queryItems: [URLQueryItem]? {
        [URLQueryItem(name: "api_key", value: "jzwguAwyjE6meldZ3VssS39SWnNA3kDF"),
            URLQueryItem(name: "q", value: query),
        URLQueryItem(name: "limit", value: "24"),
        URLQueryItem(name: "offset", value: offset)]
    }
}
