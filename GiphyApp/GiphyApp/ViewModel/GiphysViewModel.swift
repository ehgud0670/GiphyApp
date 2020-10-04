//
//  GiphyReactor.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/22.
//  Copyright © 2020 jason. All rights reserved.
//

import UIKit

import RxSwift

final class GiphysViewModel: NSObject {
    enum Notification {
        static let updateFirst = Foundation.Notification.Name("GiphysViewModeldDidUpdateFirst")
        static let updateMore = Foundation.Notification.Name("GiphysViewModeldDidUpdateMore")
    }
    
    private var giphys = [Giphy]()
    var pagination: Pagination?
    
    func updateFirst(with response: GiphysResponse) {
        let giphys = response.data.map { Giphy(originalURLString: $0.images.original?.url,
                                             downsizedURLString: $0.images.downsized?.url,
                                             title: $0.title) }
        self.giphys = giphys
        pagination = response.pagination
        
        NotificationCenter.default.post(name: Notification.updateFirst, object: self)
    }
    
    func updateMore(with response: GiphysResponse) {
        let giphys = response.data.map { Giphy(originalURLString: $0.images.original?.url,
        downsizedURLString: $0.images.downsized?.url,
        title: $0.title) }
        
        self.giphys.append(contentsOf: giphys)
        pagination = response.pagination
        
        let startIndex = self.giphys.count - giphys.count
        let endIndex = startIndex + response.data.count
        NotificationCenter.default.post(
            name: Notification.updateMore,
            object: self,
            userInfo: ["newItems": (startIndex ..< endIndex).map { IndexPath(item: $0, section: 0) }]
        )
    }
    
    func clear() {
        giphys = []
        pagination = nil
    }
    
    func giphy(at index: Int) -> Giphy? {
        guard index < giphys.count else { return nil }
        return giphys[index]
    }
}

extension GiphysViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return giphys.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let giphyCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GiphyCell.reuseIdentifier,
            for: indexPath
            ) as? GiphyCell else { return GiphyCell() }
        guard indexPath.item < giphys.count else { return giphyCell }
        
        let giphy = giphys[indexPath.item]
        giphyCell.onData.onNext(giphy)
        
        return giphyCell
    }
}
