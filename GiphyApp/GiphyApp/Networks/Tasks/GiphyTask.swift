//
//  GifTask.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/25.
//  Copyright © 2020 jason. All rights reserved.
//

import Foundation

import Alamofire
import RxSwift

final class GiphyTask {
    typealias Input = GiphyRequest
    typealias Output = GiphyResponse
    
    private let session: Session
    private(set) var isLoading = false
    
    init(session: Session = AF) {
        self.session = session
    }
    
    func setIsLoadingFalse() {
        isLoading = false
    }
    
    func perform(_ request: Input) -> Observable<GiphyResponse> {
        isLoading = true
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
                    emitter.onCompleted()
            }
            return Disposables.create()
        }
    }
}
