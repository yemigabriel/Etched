//
//  JournalMO+CoreDataProperties.swift
//  Etched
//
//  Created by Yemi Gabriel on 12/26/21.
//
//

import Foundation
import CoreData


extension JournalMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<JournalMO> {
        return NSFetchRequest<JournalMO>(entityName: "JournalMO")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var content: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var images: String?
    @NSManaged public var video: String?
    @NSManaged public var audio: String?
    @NSManaged public var location: LocationMO?
    @NSManaged public var mood: MoodMO?
    
    var wrappedId: UUID {
        id ?? UUID()
    }
    
    var wrappedContent: String {
        content ?? "unknown content"
    }
    
    var wrappedTimestamp: Date {
        timestamp ?? Date()
    }
    
    var wrappedImages: [String] {
        var imagesArray:[String] = []
        if let images = images {
            for subString in images.split(separator: ",") {
                imagesArray.append(String(subString))
            }
        }
        return imagesArray
    }
    
    var wrappedVideo: String {
        video ?? "unknown video"
    }
    
    var wrappedAudio: String {
        audio ?? "unknown audio"
    }
    
    var wrappedLocation: Location? {
        if let location = location {
            return Location(id: location.wrappedId ,
                            name: location.wrappedName,
                            latitude: location.latitude ,
                            longitude: location.longitude )
        }
        return nil
    }

    var wrappedMood: Mood? {
        if let mood = mood {
            return Mood(id: mood.wrappedId,
                        name: mood.wrappedName,
                        emoji: mood.wrappedEmoji)
        }
        return nil
    }
}

extension JournalMO : Identifiable {

}
