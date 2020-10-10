//
//  UIImageExtensionsTest.swift
//  GiphyAppTests
//
//  Created by kimdo2297 on 2020/10/06.
//  Copyright © 2020 jason. All rights reserved.
//

import XCTest
@testable import GiphyApp

final class UIImageExtensionsTest: XCTestCase {
    func testUIImage_gcdForPair_메소드_성공() {
        XCTAssertEqual(UIImage.gcdForPair(lhs: 4, rhs: 12), 4)
        XCTAssertEqual(UIImage.gcdForPair(lhs: 12, rhs: 4), 4)
    }
}
