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
    private let gifCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    // MARK: - Properties
    private var _fetchedResultsController: NSFetchedResultsController<CoreDataGiphy>?
    var coreDataManager: CoreDataManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAttributes()
        configureLayout()
    }
}

// MARK: - Attributes & Layout
extension FavoriteViewController {
    private func configureAttributes() {
        self.view.do {
            $0.backgroundColor = .systemPink
        }
        
        gifCollectionView.do {
            $0.backgroundColor = .clear
            $0.register(GifCell.self, forCellWithReuseIdentifier: GifCell.reuseIdentifier)
            $0.dataSource = self
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

// MARK: - UICollectionView DataSource
extension FavoriteViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        guard let fetchedResultsController = fetchedResultsController,
            let sectionInfo = fetchedResultsController.sections?[section]
            else { return 0 }
        
        return sectionInfo.numberOfObjects
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let giphyCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GifCell.reuseIdentifier,
            for: indexPath
            ) as? GifCell else { return GifCell() }
        
        guard let giphy = fetchedResultsController?.object(at: indexPath).giphy
            else { return giphyCell }
        
        giphyCell.onData.onNext(giphy)
        return giphyCell
    }
}

// MARK: - UICollectionView Delegate
extension FavoriteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let coreDatagiphy = fetchedResultsController?.object(at: indexPath) else { return }
        
        let detailViewController = DetailViewController().then {
            $0.giphy = coreDatagiphy.giphy
            $0.coreDataManager = self.coreDataManager
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

// MARK: - NSFetchedResultsController
extension FavoriteViewController {
    var fetchedResultsController: NSFetchedResultsController<CoreDataGiphy>? {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        guard let context = coreDataManager?.context,
            let fetchRequest = self.fetchRequest else { return nil }
        
        let aFetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: "Giphy")
        
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            let nserror = error as NSError
            print(nserror.localizedDescription)
        }
        
        return _fetchedResultsController!
    }
    
    private var fetchRequest: NSFetchRequest<CoreDataGiphy>? {
        let fetchRequest: NSFetchRequest<CoreDataGiphy> = CoreDataGiphy.fetchRequest()
        
        if let coreDataManager = coreDataManager {
            fetchRequest.fetchBatchSize = coreDataManager.countLimit
        }
        
        let sortDescriptor = NSSortDescriptor(key: "favoriteDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return fetchRequest
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
            gifCollectionView.insertItems(at: [newIndexPath!])
        case .delete:
            gifCollectionView.deleteItems(at: [indexPath!])
        default:
            return
        }
    }
}
