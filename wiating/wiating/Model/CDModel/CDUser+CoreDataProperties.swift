//
//  CDUser+CoreDataProperties.swift
//  wiating
//
//  Created by Jędrzej Sokołowski on 16/01/2023.
//
//

import Foundation
import CoreData


extension CDUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDUser> {
        return NSFetchRequest<CDUser>(entityName: "CDUser")
    }

    @NSManaged public var displayName: String?
    @NSManaged public var ownedLocations: NSSet?

}

// MARK: Generated accessors for ownedLocations
extension CDUser {

    @objc(addOwnedLocationsObject:)
    @NSManaged public func addToOwnedLocations(_ value: CDLocation)

    @objc(removeOwnedLocationsObject:)
    @NSManaged public func removeFromOwnedLocations(_ value: CDLocation)

    @objc(addOwnedLocations:)
    @NSManaged public func addToOwnedLocations(_ values: NSSet)

    @objc(removeOwnedLocations:)
    @NSManaged public func removeFromOwnedLocations(_ values: NSSet)

}

extension CDUser : Identifiable {

}
