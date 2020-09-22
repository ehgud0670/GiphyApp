//
//  ViewController.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/22.
//  Copyright © 2020 jason. All rights reserved.
//

import UIKit

import Then
import RxSwift
import SnapKit

final class SearchViewController: UIViewController {
    // MARK: - UI
    private let searchView: SearchView = SearchTextField()
    private let searchCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    private let searchViewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAttributes()
        configureLayout()
    }
}

// MARK: - Attributes & Layout
extension SearchViewController {
    private func configureAttributes() {
        searchCollectionView.do {
            $0.backgroundColor = .systemBackground
            $0.register(GiphyCell.self, forCellWithReuseIdentifier: GiphyCell.reuseIdentifier)
            $0.dataSource = searchViewModel.giphyViewModel
            $0.delegate = self
        }
    }
    
    private func configureLayout() {
        self.view.addSubview(searchView)
        searchView.snp.makeConstraints {
            let safeArea = self.view.safeAreaLayoutGuide
            let constant: CGFloat = 10
            
            $0.top.equalTo(safeArea).inset(constant)
            $0.leading.trailing.equalTo(self.view).inset(constant)
            $0.height.equalTo(searchView.snp.width).dividedBy(7)
        }
        
        self.view.addSubview(searchCollectionView)
        searchCollectionView.snp.makeConstraints {
            let constant: CGFloat = 10
            
            $0.top.equalTo(searchView.snp.bottom).offset(constant)
            $0.leading.trailing.bottom.equalTo(self.view).inset(constant)
        }
    }
}

// MARK: - UICollectionView Delegate
extension SearchViewController: UICollectionViewDelegate { }

// MARK: - UICollectionView Delegate FlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
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
