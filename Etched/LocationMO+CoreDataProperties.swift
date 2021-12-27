//
//  LocationMO+CoreDataProperties.swift
//  Etched
//
//  Created by Yemi Gabriel on 12/27/21.
//
//

import Foundation
import CoreData


extension LocationMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationMO> {
        return NSFetchRequest<LocationMO>(entityName: "LocationMO")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var journals: NSSet?
    
    var wrappedId: UUID {
        id ?? UUID()
    }
    
    var wrappedName: String {
        name ?? "Earth"
    }
    
//    var wrappedJournals: [Journal] {
//        
//    }

}

// MARK: Generated accessors for journals
extension LocationMO {

    @objc(addJournalsObject:)
    @NSManaged public func addToJournals(_ value: JournalMO)

    @objc(removeJournalsObject:)
    @NSManaged public func removeFromJournals(_ value: JournalMO)

    @objc(addJournals:)
    @NSManaged public func addToJournals(_ values: NSSet)

    @objc(removeJournals:)
    @NSManaged public func removeFromJournals(_ values: NSSet)

}

extension LocationMO : Identifiable {

}
