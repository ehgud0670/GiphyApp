//
//  ErrorExtensions.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/25.
//  Copyright © 2020 jason. All rights reserved.
//

import Foundation

import Alamofire

extension Error {
    var isSessionError: Bool {
        return (self.asAFError)?.isSessionTaskError ?? false
    }
}
