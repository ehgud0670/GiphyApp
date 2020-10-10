//
//  GiphyResponse.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/23.
//  Copyright © 2020 jason. All rights reserved.
//

import Foundation

struct GiphysResponse: Codable {
    let data: [GiphyData]
    let pagination: Pagination
    let meta: Meta
}
