//
//  Giphy+CoreDataProperties.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/26.
//  Copyright © 2020 jason. All rights reserved.
//
//

import Foundation
import CoreData

extension Giphy {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Giphy> {
        return NSFetchRequest<Giphy>(entityName: "Giphy")
    }

    @NSManaged public var downsizedURLString: String?
    @NSManaged public var originalURLString: String?
    @NSManaged public var title: String?
}
