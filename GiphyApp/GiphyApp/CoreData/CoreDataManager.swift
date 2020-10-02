//
//  CoreDataManager.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/26.
//  Copyright © 2020 jason. All rights reserved.
//

import UIKit
import CoreData

final class CoreDataManager: NSObject {
    enum Notification {
        static let dataUpdate = Foundation.Notification.Name("coredata.upate")
    }
    
    private let countLimit = 20
    private let context: NSManagedObjectContext
    private(set) var modelsAllCount = 0 {
        didSet { notify() }
    }
    
    private var _fetchedResultsController: NSFetchedResultsController<CoreDataGiphy>?
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        
        modelsAllCount = countAll
    }
    
    private func notify() {
        NotificationCenter.default.post(
            name: Notification.dataUpdate,
            object: self,
            userInfo: ["isHidden": modelsAllCount != 0])
    }
    
    func insertObject(giphy: Giphy) {
        _ = CoreDataGiphy(context: context).then {
            $0.favoriteDate = Date()
            $0.isFavorite = giphy.isFavorite
            $0.originalURLString = giphy.originalURLString
            $0.downsizedURLString = giphy.downsizedURLString
            $0.title = giphy.title
        }
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        self.modelsAllCount = countAll
    }
    
    func removeObject(coreDataGiphy: CoreDataGiphy) {
        context.delete(coreDataGiphy)
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        self.modelsAllCount = countAll
    }
    
    private var countAll: Int {
        let entityName = String(describing: CoreDataGiphy.self)
        let request = NSFetchRequest<CoreDataGiphy>(entityName: entityName)
        do {
            return try context.count(for: request)
        } catch {
            print(error.localizedDescription)
            return 0
        }
    }
    
    func object(giphy: Giphy) -> CoreDataGiphy? {
        let entityName = String(describing: CoreDataGiphy.self)
        let request = NSFetchRequest<CoreDataGiphy>(entityName: entityName)
        guard let originalURL = giphy.originalURLString else { return nil}
        
        request.predicate = NSPredicate(
            format: "originalURLString == %@",
            originalURL
        )
        let giphys = try? context.fetch(request)
        return giphys?.first
    }
    
    var isLimited: Bool {
        return countAll >= countLimit
    }
}

// MARK: - NSFetchedResultsController
extension CoreDataManager {
    var fetchedResultsController: NSFetchedResultsController<CoreDataGiphy>? {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        guard let fetchRequest = self.fetchRequest else { return nil }
        
        let aFetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
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
        fetchRequest.fetchBatchSize = countLimit
        
        let sortDescriptor = NSSortDescriptor(key: "favoriteDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return fetchRequest
    }
}

// MARK: - UICollectionView DataSource
extension CoreDataManager: UICollectionViewDataSource {
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
        
        guard let giphy = fetchedResultsController?
            .object(at: indexPath).giphy
            else { return giphyCell }
        
        giphyCell.onData.onNext(giphy)
        return giphyCell
    }
}
