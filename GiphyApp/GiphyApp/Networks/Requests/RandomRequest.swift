//
//  GifRequest.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/25.
//  Copyright © 2020 jason. All rights reserved.
//

import Foundation

protocol GifRequest: Request { }

struct RandomRequest: GifRequest {
    private let tag: String
    
    init(tag: String = "") {
        self.tag = tag
    }
    
    var path: String { "https://api.giphy.com/v1/gifs/random" }
    var queryItems: [URLQueryItem]? {
        [URLQueryItem(name: "api_key", value: "jzwguAwyjE6meldZ3VssS39SWnNA3kDF"),
         URLQueryItem(name: "tag", value: tag)]
    }
}
