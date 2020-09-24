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
        static let updateFirst = Foundation.Notification.Name("GifsViewModeldDidUpdateFirst")
        static let updateMore = Foundation.Notification.Name("GifsViewModeldDidUpdateMore")
    }
    
    private var gifs = [GiphyData]()
    var pagination: Pagination?
    
    func updateFirst(with response: GiphyResponse) {
        gifs = response.data
        pagination = response.pagination
        
        NotificationCenter.default.post(name: Notification.updateFirst, object: self)
    }
    
    func updateMore(with response: GiphyResponse) {
        gifs.append(contentsOf: response.data)
        pagination = response.pagination
        
        let startIndex = gifs.count - response.data.count
        let endIndex = startIndex + response.data.count
        NotificationCenter.default.post(
            name: Notification.updateMore,
            object: self,
            userInfo: ["newItems": (startIndex ..< endIndex).map { IndexPath(item: $0, section: 0) }]
        )
    }
    
    func clear() {
        gifs = []
        pagination = nil
    }
    
    func giphyData(at index: Int) -> GiphyData? {
        guard index < gifs.count else { return nil }
        return gifs[index]
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
        guard indexPath.item < gifs.count else { return giphyCell }
        
        let giphyData = gifs[indexPath.item]
        giphyCell.onData.onNext(giphyData)
        
        return giphyCell
    }
}
