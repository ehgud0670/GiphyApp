//
//  GifResponseTests.swift
//  GiphyAppTests
//
//  Created by kimdo2297 on 2020/09/23.
//  Copyright © 2020 jason. All rights reserved.
//

import XCTest
@testable import GiphyApp

final class GiphyResponseTests: XCTestCase {
    func test_giphyResonse_디코딩_성공() throws {
        let jsonData = try XCTUnwrap(Data.readJSON(for: "GiphyResponse"))
        
        _ = try XCTUnwrap(JSONDecoder().decode(GiphyResponse.self, from: jsonData))
    }
}
