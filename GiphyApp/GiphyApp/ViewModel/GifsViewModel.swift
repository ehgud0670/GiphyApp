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
    
    private var gifs = [Giphy]()
    var pagination: Pagination?
    
    func updateFirst(with response: GifsResponse) {
        let giphys = response.data.map { Giphy(originalURLString: $0.images.original?.url,
                                             downsizedURLString: $0.images.downsized?.url,
                                             title: $0.title) }
        self.gifs = giphys
        pagination = response.pagination
        
        NotificationCenter.default.post(name: Notification.updateFirst, object: self)
    }
    
    func updateMore(with response: GifsResponse) {
        let giphys = response.data.map { Giphy(originalURLString: $0.images.original?.url,
        downsizedURLString: $0.images.downsized?.url,
        title: $0.title) }
        
        self.gifs.append(contentsOf: giphys)
        pagination = response.pagination
        
        let startIndex = self.gifs.count - giphys.count
        let endIndex = startIndex + response.data.count
        NotificationCenter.default.post(
            name: Notification.updateMore,
            object: self,
            userInfo: ["newItems": (startIndex ..< endIndex).map { IndexPath(item: $0, section: 0) }]
        )
    }
    
    func upgrade(giphy: Giphy, at index: Int) {
        guard index >= 0, index < gifs.count else { return }
        
        gifs[index] = giphy
    }
    
    func clear() {
        gifs = []
        pagination = nil
    }
    
    func giphy(at index: Int) -> Giphy? {
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
        
        let giphy = gifs[indexPath.item]
        giphyCell.onData.onNext(giphy)
        
        return giphyCell
    }
}
