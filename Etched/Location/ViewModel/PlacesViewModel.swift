//
//  PlacesViewModel.swift
//  Etched
//
//  Created by Yemi Gabriel on 1/20/22.
//

import Combine
import MapKit

class PlacesViewModel: ObservableObject {
    
    @Published var places: [LocationMO] = []
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40, longitude: 40), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @Published var showCallout = false
    @Published var showDetail = false
    @Published var selectedJournal: JournalMO?
    @Published var selectedPlace: LocationMO?
    
    var cancellable: AnyCancellable?
    
    init(places: AnyPublisher<[LocationMO], Never> =
         PlacesCoreDataHelper.shared.places.eraseToAnyPublisher()) {
        cancellable = places.sink(receiveValue: { [weak self] places in
            self?.places = places.filter{$0.wrappedJournals.isNotEmpty()}
            print("Places: ", self?.places.count)
            try? places.forEach {
                if let journals = $0.journals?.allObjects as? [JournalMO] {
                    print("Place ", $0.wrappedId, journals.count)
                    try? journals.forEach {
                        print("Journal: ", $0.wrappedTimestamp)
                    }
                }
            }
            if let place = places.first {
                self?.region.center.latitude = place.latitude
                self?.region.center.longitude = place.longitude
            }
            print(places.first?.latitude)
        })
    }
    
    
    func getJournalByPlace() {
        
    }
    
    
}
