//
//  TrendRequestTests.swift
//  GiphyAppTests
//
//  Created by kimdo2297 on 2020/09/23.
//  Copyright © 2020 jason. All rights reserved.
//

import XCTest
@testable import GiphyApp

final class TrendRequestTests: XCTestCase {
    private var request: TrendRequest!
    
    override func setUp() {
        super.setUp()
        request = TrendRequest()
    }
    
    override func tearDown() {
        request = nil
        super.tearDown()
    }
    
    func test_isCorrectAttributes() {
        XCTAssertEqual(request.path, "api.giphy.com/v1/gifs/trending")
        XCTAssertEqual(request.method, HTTPMethod.get)
        XCTAssertEqual(
            request.queryItems!,
            [URLQueryItem(name: "api_key", value: "jzwguAwyjE6meldZ3VssS39SWnNA3kDF"),
             URLQueryItem(name: "limit", value: "24")]
        )
    }
    
    func test_isCorrectURL() throws {
        let urlRequest = try XCTUnwrap(request.urlRequest())
        let url = try XCTUnwrap(urlRequest.url)
        XCTAssertEqual(
            url.absoluteString,
            "api.giphy.com/v1/gifs/trending?api_key=jzwguAwyjE6meldZ3VssS39SWnNA3kDF&limit=24"
        )
    }
}
