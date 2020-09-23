//
//  NetworkTask.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/23.
//  Copyright © 2020 jason. All rights reserved.
//

import Foundation

protocol NetworkTask {
    associatedtype Input
    associatedtype Output

    func perform(_ request: Input, completionHandler: @escaping (Output?, Error?) -> Void)
}
