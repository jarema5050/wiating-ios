//
//  CDLocation+CoreDataProperties.swift
//  wiating
//
//  Created by Jędrzej Sokołowski on 16/01/2023.
//
//

import Foundation
import CoreData


extension CDLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDLocation> {
        return NSFetchRequest<CDLocation>(entityName: "CDLocation")
    }

    @NSManaged public var category: String?
    @NSManaged public var destroyed: Bool
    @NSManaged public var fireplaceAccess: String?
    @NSManaged public var fireplaceDescription: String?
    @NSManaged public var hints: String?
    @NSManaged public var lastUpdate: Date?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var objDescription: String?
    @NSManaged public var waterAccess: String?
    @NSManaged public var waterDescription: String?
    @NSManaged public var owner: CDUser?
    @NSManaged public var photos: NSSet?
    @NSManaged public var reports: CDReport?

}

// MARK: Generated accessors for photos
extension CDLocation {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: CDImage)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: CDImage)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)

}

extension CDLocation : Identifiable {

}
