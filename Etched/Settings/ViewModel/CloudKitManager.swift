//
//  CloudKitManager.swift
//  Etched
//
//  Created by Yemi Gabriel on 1/31/22.
//

import SwiftUI
import CloudKit
import CoreData

class CloudKitManager {
    
    init() {
        
    }
    
    func syncToCloud() {
    }
    
    func setupCloudContainer() -> NSPersistentCloudKitContainer{
        let container = NSPersistentCloudKitContainer(name: "JournalMO")
        
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("Failed to retrieve a persistent store description")
        }

        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        })

        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }

}
