//
//  MoodCoreDataHelper.swift
//  Etched
//
//  Created by Yemi Gabriel on 1/25/22.
//

import Combine
import CoreData
import MapKit

class MoodCoreDataHelper: NSObject {
    
    static let shared = MoodCoreDataHelper()
    
    private(set) var moods = CurrentValueSubject<[MoodMO], Never>([])
    private let container = PersistenceController.shared.container
    private let sortDescriptors = [NSSortDescriptor]()
    private var moodFetchController: NSFetchedResultsController<MoodMO>?
    
    override init() {
        super.init()
        let fetchRequest = MoodMO.fetchRequest()
        fetchRequest.sortDescriptors = []
        moodFetchController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: container.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        moodFetchController?.delegate = self
        
        getMoods()
    }
    
    func getMoods() {
        do {
            try moodFetchController?.performFetch()
            moods.value = moodFetchController?.fetchedObjects ?? []
        } catch {
            print("Error fetching mood \(error.localizedDescription)")
        }
    }
}

extension MoodCoreDataHelper: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let fetchedObjects = controller.fetchedObjects as? [MoodMO] else { return }
        DispatchQueue.main.async { [weak self] in
            self?.moods.value = fetchedObjects
        }
    }
}
