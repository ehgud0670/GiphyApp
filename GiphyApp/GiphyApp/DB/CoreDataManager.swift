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
    let countLimit = 20
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
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
    }
    
    func removeObject(coreDataGiphy: CoreDataGiphy) {
        context.delete(coreDataGiphy)
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
