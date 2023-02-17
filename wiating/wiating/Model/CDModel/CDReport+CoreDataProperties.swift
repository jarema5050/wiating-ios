//
//  CDReport+CoreDataProperties.swift
//  wiating
//
//  Created by Jędrzej Sokołowski on 16/01/2023.
//
//

import Foundation
import CoreData


extension CDReport {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDReport> {
        return NSFetchRequest<CDReport>(entityName: "CDReport")
    }

    @NSManaged public var objDescription: String?
    @NSManaged public var type: String?
    @NSManaged public var refers: CDLocation?
    @NSManaged public var reporter: CDUser?

}

extension CDReport : Identifiable {

}
