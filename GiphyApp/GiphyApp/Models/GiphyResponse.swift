//
//  GifResponse.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/25.
//  Copyright © 2020 jason. All rights reserved.
//

import Foundation

struct GiphyResponse: Codable {
    let data: GiphyData
    let meta: Meta
}
