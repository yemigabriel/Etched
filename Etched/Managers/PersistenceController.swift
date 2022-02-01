//
//  PersistenceController.swift
//  Etched
//
//  Created by Yemi Gabriel on 12/30/21.
//

import Foundation
import CoreData
import SwiftUI

struct PersistenceController {
    // A singleton for our entire app to use
    static var shared = PersistenceController()
    static let syncCloudKey = "SYNC_CLOUD"
    
    // Storage for Core Data
//    let container: NSPersistentCloudKitContainer
    lazy var container: NSPersistentCloudKitContainer = {
        setUpContainer()
    }()

    // A test configuration for SwiftUI previews
    static var preview: PersistenceController = {
        var controller = PersistenceController(inMemory: true)

        // Create 10 example programming languages.
        for _ in 0..<10 {
            let journal = JournalMO(context: controller.container.viewContext)
            journal.id = UUID()
            journal.timestamp = Date.now
            journal.content = "Random Content"
        }

        return controller
    }()

    // An initializer to load Core Data, optionally able
    // to use an in-memory store.
    init(inMemory: Bool = false) {
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }
    
    func setUpContainer(inMemory: Bool = false) -> NSPersistentCloudKitContainer {
        let isCloudSync = UserDefaults.standard.bool(forKey: Self.syncCloudKey)
        
        let container = NSPersistentCloudKitContainer(name: "JournalMO")
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("No store descriptions found")
        }
        
        if inMemory {
            description.url = URL(fileURLWithPath: "/dev/null")
        } else {
            description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
            description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
            if !isCloudSync {
                description.cloudKitContainerOptions = nil
            } else {
                description.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.com.yemigabriel.etched")
            }
            
        }
        
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Error: \(error), \(error.userInfo)")
            }
        }
        
//        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        
        return container
    }
}
