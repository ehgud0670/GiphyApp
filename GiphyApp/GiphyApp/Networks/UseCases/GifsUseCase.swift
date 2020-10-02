//
//  GifsUseCase.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/10/03.
//  Copyright © 2020 jason. All rights reserved.
//

import Foundation

import RxSwift

final class GifsUseCase {
    private let gifsTask: GifsTask
    
    init(gifsTask: GifsTask) {
        self.gifsTask = gifsTask
    }
    
    private func loadGifs(with gifsRequest: GifsRequest) -> Observable<GifsResponse>? {
        guard !gifsTask.isLoading else { return nil }
        
        return gifsTask.perform(gifsRequest)
            .take(1)
            .do { [weak self] in self?.gifsTask.setIsLoadingFalse() }
    }
    
    func loadFirstTrendyGIFs() -> Observable<GifsResponse>? {
        return loadGifs(with: TrendRequest())
    }
    
    func loadMoreTrendyGIFs(with nextOffset: Int) -> Observable<GifsResponse>? {
        return loadGifs(with: TrendRequest(offset: nextOffset))
    }
    
    func loadFirstSearchGIFs(with query: String) -> Observable<GifsResponse>? {
        return loadGifs(with: SearchRequest(query: query))
    }
    
    func loadMoreSearchGIFs(with query: String, nextOffset: Int) -> Observable<GifsResponse>? {
        return loadGifs(with: SearchRequest(query: query, offset: nextOffset))
    }
}
