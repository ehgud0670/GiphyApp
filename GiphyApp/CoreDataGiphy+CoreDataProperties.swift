//
//  CoreDataGiphy+CoreDataProperties.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/26.
//  Copyright © 2020 jason. All rights reserved.
//
//

import Foundation
import CoreData

extension CoreDataGiphy {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataGiphy> {
        return NSFetchRequest<CoreDataGiphy>(entityName: "CoreDataGiphy")
    }

    @NSManaged public var favoriteDate: Date?
    @NSManaged public var downsizedURLString: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var originalURLString: String?
    @NSManaged public var title: String?
    
    var giphy: Giphy? {
        guard let title = title else { return nil }
        
        return Giphy(
            isFavorite: isFavorite,
            originalURLString: originalURLString,
            downsizedURLString: downsizedURLString,
            title: title
        )
    }
}
