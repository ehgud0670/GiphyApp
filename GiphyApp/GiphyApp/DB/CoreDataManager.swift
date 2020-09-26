//
//  CoreDataManager.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/26.
//  Copyright © 2020 jason. All rights reserved.
//

import UIKit
import CoreData

final class CoreDataManager {
    enum Notification {
        static let dataUpdate = Foundation.Notification.Name("coredata.upate")
    }
    
    let countLimit = 20
    let context: NSManagedObjectContext
    var modelsAllCount = 0 {
        didSet { notify() }
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
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
