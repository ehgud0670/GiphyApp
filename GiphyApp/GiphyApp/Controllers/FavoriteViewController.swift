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
    private let gifCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    // MARK: - Properties
    private let giphyViewModel = GifsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAttributes()
        configureLayout()
    }
}

// MARK: - Attributes & Layout
extension FavoriteViewController {
    private func configureAttributes() {
        gifCollectionView.do {
            $0.backgroundColor = .systemBackground
            $0.register(GifCell.self, forCellWithReuseIdentifier: GifCell.reuseIdentifier)
            
            $0.delegate = self
        }
    }
    
    private func configureLayout() {
        self.view.addSubview(gifCollectionView)
        gifCollectionView.snp.makeConstraints {
            let constant: CGFloat = 10
            
            $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(constant)
            $0.leading.trailing.bottom.equalTo(self.view).inset(constant)
        }
    }
}

// MARK: - UICollectionView Delegate
extension FavoriteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailViewController().then {
            $0.modalPresentationStyle = .custom
            $0.transitioningDelegate = self
        }
        
        self.present(detailViewController, animated: true)
    }
}

// MARK: - UIViewController Transitioning Delegate 
extension FavoriteViewController: UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        return HalfSizePresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
    }
}

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
