//
//  TrendyRequest.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/23.
//  Copyright © 2020 jason. All rights reserved.
//

import Foundation

protocol GiphyRequest: Request { }

struct TrendRequest: GiphyRequest {
    var path: String { "https://api.giphy.com/v1/gifs/trending" }
    var queryItems: [URLQueryItem]? {
        [URLQueryItem(name: "api_key", value: "jzwguAwyjE6meldZ3VssS39SWnNA3kDF"),
        URLQueryItem(name: "limit", value: "24")]
    }
}
