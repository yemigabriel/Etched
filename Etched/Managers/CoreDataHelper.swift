//
//  CoreDataHelper.swift
//  Etched
//
//  Created by Yemi Gabriel on 12/26/21.
//

import Foundation
import CoreData
import Combine

protocol CoreDataHelperProtocol {
    func getJournals()
    func add(journal: JournalMO)
    func delete(journal: JournalMO)
    func edit(journal: JournalMO)
    func saveContext()
}

class CoreDataHelper: NSObject, CoreDataHelperProtocol, ObservableObject {
    
    static let shared = CoreDataHelper()
    
    let container = PersistenceController.shared.container
    private(set) var journals = CurrentValueSubject<[JournalMO], Never>([])
//    var journal = CurrentValueSubject<JournalMO, Never>(<#JournalMO#>)
    var journal = PassthroughSubject<JournalMO, Never>()
    private var journalFetchController: NSFetchedResultsController<JournalMO>?
    
    
    override init() {
        super.init()
        
        let journalFetchRequest = JournalMO.fetchRequest()
        journalFetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        journalFetchController = NSFetchedResultsController(
            fetchRequest: journalFetchRequest,
            managedObjectContext: container.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        journalFetchController!.delegate = self
        
        getJournals()
    }
    
}

extension CoreDataHelper: NSFetchedResultsControllerDelegate {
    
    func getJournals() {
        do {
            try journalFetchController!.performFetch()
            journals.value = journalFetchController!.fetchedObjects ?? []
            print(journals.count)
        } catch {
            print("Fetch error: \(error.localizedDescription)")
        }
    }
    
    func add(journal: JournalMO) {
        journal.id = UUID()
        journal.timestamp = Date.now
        
        print(journal.wrappedContent)
        saveContext()
    }
    
    func delete(journal: JournalMO) {
        container.viewContext.delete(journal)
        saveContext()
    }
    
    func edit(journal: JournalMO) {
        if journals.value.contains(where: {
            journal.wrappedId == $0.wrappedId
        }) {
            saveContext()
        }
    }
    
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("Managed Object Context could not save \(error.localizedDescription)")
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let journals = controller.fetchedObjects as? [JournalMO] else { return }
        DispatchQueue.main.async {
            self.journals.value = journals
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let journal = anObject as? JournalMO {
                print("inserting into journal: \(journal.wrappedId)")
                DispatchQueue.main.async {
                    self.journal.send(journal)
                }
            }
        case .update:
            if let journal = anObject as? JournalMO {
                print("updating journal: \(journal.wrappedId)")
                DispatchQueue.main.async {
                    self.journal.send(journal)
                }
            }
        case .delete:
            print("deleting journal")
            if let journal = anObject as? JournalMO {
                print("deleting journal: \(journal.wrappedId)")
            }
        case .move:
            break
        @unknown default:
            print("unknown")
            break
        }
    }
    
}
