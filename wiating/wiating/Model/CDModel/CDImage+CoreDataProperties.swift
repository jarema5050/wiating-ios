//
//  CDImage+CoreDataProperties.swift
//  wiating
//
//  Created by Jędrzej Sokołowski on 16/01/2023.
//
//

import Foundation
import CoreData


extension CDImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDImage> {
        return NSFetchRequest<CDImage>(entityName: "CDImage")
    }

    @NSManaged public var uri: URL?

}

extension CDImage : Identifiable {

}
