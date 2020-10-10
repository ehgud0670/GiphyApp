//
//  GifsUseCase.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/10/03.
//  Copyright © 2020 jason. All rights reserved.
//

import Foundation

import RxSwift

final class GiphysUseCase {
    private let giphysTask: GiphysTask
    
    init(giphysTask: GiphysTask) {
        self.giphysTask = giphysTask
    }
    
    var isNotLoading: Bool {
        return !giphysTask.isLoading
    }
    
    private func loadGiphys(with giphysRequest: GiphysRequest) -> Observable<GiphysResponse> {
        return giphysTask.perform(giphysRequest)
            .take(1)
            .do { [weak self] in self?.giphysTask.setIsLoadingFalse() }
    }
    
    func loadFirstTrendyGiphys() -> Observable<GiphysResponse> {
        return loadGiphys(with: TrendRequest())
    }
    
    func loadMoreTrendyGiphys(with nextOffset: Int) -> Observable<GiphysResponse> {
        return loadGiphys(with: TrendRequest(offset: nextOffset))
    }
    
    func loadFirstSearchGiphys(with query: String) -> Observable<GiphysResponse> {
        return loadGiphys(with: SearchRequest(query: query))
    }
    
    func loadMoreSearchGiphys(with query: String, nextOffset: Int) -> Observable<GiphysResponse> {
        return loadGiphys(with: SearchRequest(query: query, offset: nextOffset))
    }
}
