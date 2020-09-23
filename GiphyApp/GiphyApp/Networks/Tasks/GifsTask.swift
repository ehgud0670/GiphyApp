//
//  GifsTask.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/23.
//  Copyright © 2020 jason. All rights reserved.
//

import Foundation

import Alamofire

final class GifsTask: NetworkTask {
    typealias Input = GiphyRequest
    typealias Output = GiphyResponse
    
    private let session: Session
    
    init(session: Session = AF) {
        self.session = session
    }
    
    func perform(_ request: Input, completionHandler: @escaping (Output?, Error?) -> Void) {
        guard let urlRequest = request.urlRequest() else { return }
        
        session.request(urlRequest).validate().responseDecodable(of: Output.self) { response in
            completionHandler(response.value, response.error)
        }
    }
}
