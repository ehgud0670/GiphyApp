//
//  FavoriteViewController.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/22.
//  Copyright © 2020 jason. All rights reserved.
//

import UIKit
import CoreData

import Then
import SnapKit

final class FavoriteViewController: UIViewController {
    // MARK: - UI
    private let giphysCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    private let emptyTitleLabel = UILabel()
    private let emptySubTitleLabel = UILabel()
    
    // MARK: - Properties
    var coreDataGiphyViewModel: CoreDataGiphyViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAttributes()
        configureLayout()
        configureObserver()
    }
    
    private func configureObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateEmptyViews(notification:)),
            name: CoreDataGiphyViewModel.Notification.dataUpdate,
            object: coreDataGiphyViewModel)
    }
    
    @objc private func updateEmptyViews(notification: Notification) {
        guard let isHidden = notification.userInfo?["isHidden"] as? Bool else { return }
        
        DispatchQueue.main.async {
            self.emptyTitleLabel.isHidden = isHidden
            self.emptySubTitleLabel.isHidden = isHidden
        }
    }
}

// MARK: - Attributes & Layout
extension FavoriteViewController {
    private func configureAttributes() {
        self.view.do {
            $0.backgroundColor = .systemPink
        }
        
        coreDataGiphyViewModel?.fetchedResultsController?.delegate = self
        
        giphysCollectionView.do {
            $0.backgroundColor = .clear
            $0.register(GiphyCell.self, forCellWithReuseIdentifier: GiphyCell.reuseIdentifier)
            $0.dataSource = coreDataGiphyViewModel
            $0.delegate = self
        }
        
        emptyTitleLabel.do {
            $0.text = "즐겨찾기 한 이미지가 없습니다."
            $0.textAlignment = .center
            $0.font = .preferredFont(forTextStyle: .title2)
            $0.adjustsFontForContentSizeCategory = true
            $0.adjustsFontSizeToFitWidth = true
            
            if coreDataGiphyViewModel?.modelsAllCount != 0 {
                $0.isHidden = true
            }
        }
        
        emptySubTitleLabel.do {
            $0.text = "별 모양을 눌러 즐겨찾기 기능을 이용해 보세요."
            $0.textAlignment = .center
            $0.font = .preferredFont(forTextStyle: .headline)
            $0.adjustsFontForContentSizeCategory = true
            $0.adjustsFontSizeToFitWidth = true
            
            if coreDataGiphyViewModel?.modelsAllCount != 0 {
                $0.isHidden = true
            }
        }
    }
    
    private func configureLayout() {
        self.view.addSubview(giphysCollectionView)
        giphysCollectionView.snp.makeConstraints {
            let constant: CGFloat = 10
            
            $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(constant)
            $0.leading.trailing.bottom.equalTo(self.view).inset(constant)
        }
        
        self.view.addSubview(emptyTitleLabel)
        emptyTitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(self.view).inset(10)
            $0.centerY.equalTo(self.view).multipliedBy(0.8)
        }
        
        self.view.addSubview(emptySubTitleLabel)
        emptySubTitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(self.view).inset(10)
            $0.top.equalTo(emptyTitleLabel.snp.bottom).offset(15)
        }
    }
}

// MARK: - UICollectionView Delegate
extension FavoriteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let coreDatagiphy = coreDataGiphyViewModel?
            .fetchedResultsController?
            .object(at: indexPath) else { return }
        
        let detailViewController = DetailViewController().then {
            $0.giphy = coreDatagiphy.giphy
            $0.coreDataManager = self.coreDataGiphyViewModel
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

extension FavoriteViewController: NSFetchedResultsControllerDelegate {
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any, at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            giphysCollectionView.insertItems(at: [newIndexPath!])
        case .delete:
            giphysCollectionView.deleteItems(at: [indexPath!])
        default:
            return
        }
    }
}
