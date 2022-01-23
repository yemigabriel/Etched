//
//  PlacesCoreDataHelper.swift
//  Etched
//
//  Created by Yemi Gabriel on 1/20/22.
//

import Combine
import CoreData

class PlacesCoreDataHelper: NSObject {
    
    static let shared = PlacesCoreDataHelper()
    
    private var fetchController: NSFetchedResultsController<LocationMO>?
    let container = PersistenceController.shared.container
    private(set) var places = CurrentValueSubject<[LocationMO], Never>([])
    
    override init() {
        super.init()
        let fetchRequest = LocationMO.fetchRequest()
        fetchRequest.sortDescriptors = []
        fetchController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: container.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchController!.delegate = self
        
        getPlaces()
    }
    
    func getPlaces() {
        do {
            try fetchController!.performFetch()
            places.value = fetchController?.fetchedObjects ?? []
        } catch {
            print("Error fetching places: \(error.localizedDescription)")
        }
    }
    
    func getPlaceByJournal() {
        
    }

}

extension PlacesCoreDataHelper: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let fetchedObjects = controller.fetchedObjects as? [LocationMO] else { return }
        DispatchQueue.main.async { [weak self] in
            self?.places.value = fetchedObjects
        }
    }
}
