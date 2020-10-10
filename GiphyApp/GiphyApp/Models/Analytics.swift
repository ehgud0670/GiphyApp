//
//  Analytics.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/10/02.
//  Copyright © 2020 jason. All rights reserved.
//

import Foundation

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
