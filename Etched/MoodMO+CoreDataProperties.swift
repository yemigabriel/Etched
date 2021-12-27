//
//  MoodMO+CoreDataProperties.swift
//  Etched
//
//  Created by Yemi Gabriel on 12/27/21.
//
//

import Foundation
import CoreData


extension MoodMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MoodMO> {
        return NSFetchRequest<MoodMO>(entityName: "MoodMO")
    }

    @NSManaged public var emoji: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var journals: NSSet?
    
    var wrappedId: UUID {
        id ?? UUID()
    }
    
    var wrappedName: String {
        name ?? ""
    }
    var wrappedEmoji: String {
        emoji ?? ""
    }
}

// MARK: Generated accessors for journals
extension MoodMO {

    @objc(addJournalsObject:)
    @NSManaged public func addToJournals(_ value: JournalMO)

    @objc(removeJournalsObject:)
    @NSManaged public func removeFromJournals(_ value: JournalMO)

    @objc(addJournals:)
    @NSManaged public func addToJournals(_ values: NSSet)

    @objc(removeJournals:)
    @NSManaged public func removeFromJournals(_ values: NSSet)

}

extension MoodMO : Identifiable {

}
