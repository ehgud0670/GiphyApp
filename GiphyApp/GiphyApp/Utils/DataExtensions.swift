//
//  DataExtensions.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/23.
//  Copyright © 2020 jason. All rights reserved.
//

import Foundation

extension Data {
    static func readJSON(of bundle: Bundle = .main, for name: String) -> Data? {
        guard let url = bundle.url(
            forResource: name,
            withExtension: "json"
            ) else { return nil }
        return try? Data(contentsOf: url)
    }
}
