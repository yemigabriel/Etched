//
//  CoreDataHelper.swift
//  Etched
//
//  Created by Yemi Gabriel on 12/26/21.
//

import Foundation
import CoreData

class CoreDataHelper: ObservableObject {
    let container = NSPersistentContainer(name: "JournalMO")
    static let shared = CoreDataHelper()
    
    private init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core data error: \(error.localizedDescription)")
            }
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
    }
}
