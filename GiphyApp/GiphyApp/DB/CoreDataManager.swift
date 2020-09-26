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
    static let shared = CoreDataManager()
    var managedObjectContext: NSManagedObjectContext? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    func insertObject() { }
}
