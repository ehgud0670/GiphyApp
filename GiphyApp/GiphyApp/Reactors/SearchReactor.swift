//
//  SearchReactor.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/22.
//  Copyright © 2020 jason. All rights reserved.
//

import UIKit

import ReactorKit

final class SearchReactor: NSObject, Reactor {
    var initialState = State()
    
    enum Action {
        
    }
    
    struct State {
        
    }
}

// MARK: - UICollectionView DataSource
extension SearchReactor: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let giphyCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GiphyCell.reuseIdentifier,
            for: indexPath
            ) as? GiphyCell else { return GiphyCell() }
        
        return giphyCell
    }
}
