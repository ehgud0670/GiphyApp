//
//  FavoriteViewController.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/22.
//  Copyright © 2020 jason. All rights reserved.
//

import UIKit

import Then
import SnapKit

final class FavoriteViewController: UIViewController {
    // MARK: - UI
    private let giphyCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    // MARK: - Properties
    private let giphyViewModel = GiphyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAttributes()
        configureLayout()
    }
}

// MARK: - Attributes & Layout
extension FavoriteViewController {
    private func configureAttributes() {
        giphyCollectionView.do {
            $0.backgroundColor = .systemBackground
            $0.register(GiphyCell.self, forCellWithReuseIdentifier: GiphyCell.reuseIdentifier)
            $0.dataSource = giphyViewModel
            $0.delegate = self
        }
    }
    
    private func configureLayout() {
        self.view.addSubview(giphyCollectionView)
        giphyCollectionView.snp.makeConstraints {
            let constant: CGFloat = 10
            
            $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(constant)
            $0.leading.trailing.bottom.equalTo(self.view).inset(constant)
        }
    }
}

// MARK: - UICollectionView Delegate
extension FavoriteViewController: UICollectionViewDelegate { }

// MARK: - UICollectionView Delegate FlowLayout
extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let constant = (self.view.bounds.width - collectionView.frame.width) / 2
        let diameter = (collectionView.frame.width - 2 * constant) / 3
        return CGSize(width: diameter.rounded(.down), height: diameter)
    }
}
