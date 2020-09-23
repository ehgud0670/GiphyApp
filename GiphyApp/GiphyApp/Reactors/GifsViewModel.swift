//
//  GiphyReactor.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/22.
//  Copyright © 2020 jason. All rights reserved.
//

import UIKit

import RxSwift

final class GifsViewModel: NSObject {
    let gifs = BehaviorSubject<[GiphyData]>(value: [])
    let pagination = PublishSubject<Pagination>()
    
    func update(with response: GiphyResponse) {
        gifs.onNext(response.data)
        pagination.onNext(response.pagination)
    }
}
