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
    enum Notification {
        static let update = Foundation.Notification.Name("GifsViewModeldDidUpdate")
    }
    
    var gifs = [GiphyData]() {
        didSet { NotificationCenter.default.post(name: Notification.update, object: self) }
    }
    var pagination: Pagination?
    
    func update(with response: GiphyResponse) {
        gifs.append(contentsOf: response.data)
        pagination = response.pagination
    }
    
    func clear() {
        gifs = []
        pagination = nil
    }
}

extension GifsViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifs.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let giphyCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GifCell.reuseIdentifier,
            for: indexPath
            ) as? GifCell else { return GifCell() }
        
        let giphyData = gifs[indexPath.item]
        giphyCell.onData.onNext(giphyData)
        
        return giphyCell
    }
}
