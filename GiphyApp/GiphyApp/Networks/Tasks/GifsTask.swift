//
//  GifsTask.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/23.
//  Copyright © 2020 jason. All rights reserved.
//

import Foundation

import Alamofire
import RxSwift

final class GifsTask {
    typealias Input = GiphyRequest
    typealias Output = GiphyResponse
    
    private let session: Session
    
    init(session: Session = AF) {
        self.session = session
    }
    
    func perform(_ request: Input) -> Observable<GiphyResponse> {
        return Observable.create { [weak self] emitter in
            guard let self = self,
            let urlRequest = request.urlRequest() else { return Disposables.create() }
            self.session.request(urlRequest)
                .validate()
                .responseDecodable(of: Output.self) { response in
                    guard response.error == nil else {
                        emitter.onError(response.error!)
                        return
                    }
                    
                    guard let giphyResponse = response.value else { return }
                    emitter.onNext(giphyResponse)
            }
            return Disposables.create()
        }
    }
}
