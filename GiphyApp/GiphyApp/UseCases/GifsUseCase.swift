//
//  GifsUseCase.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/23.
//  Copyright © 2020 jason. All rights reserved.
//

import Foundation

final class GifsUseCase {
    private let gifsTask: GifsTask
    
    init(gifsTask: GifsTask) {
        self.gifsTask = gifsTask
    }
    
    func request(
        _ request: GiphyRequest,
        completionHandler: @escaping (GiphyResponse) -> Void,
        failureHandler: @escaping (Error) -> Void
    ) {
        gifsTask.perform(request) { response, error in
            guard error == nil else {
                failureHandler(error!)
                return
            }
            
            guard let response = response else { return }
            completionHandler(response)
        }
    }
}
