//
//  LocationViewModel.swift
//  Etched
//
//  Created by Yemi Gabriel on 1/11/22.
//

import Combine
import MapKit

class AddPlaceViewModel: ObservableObject {
    
    @Published var error: LocationError?
    @Published var currentLocation: Location?
    @Published var annotationItems = [Location]()
    @Published var searchText = ""
    @Published var searchResults:[MKMapItem] = []
    
    private var cancellable: AnyCancellable?
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40, longitude: 40), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    // easier for testing
    init(locationPublisher: AnyPublisher<Location, LocationError> =
         LocationManager.shared.locationPublisher.eraseToAnyPublisher()) {
        cancellable = locationPublisher.sink(receiveCompletion: { [self] (completion:
                                                                    Subscribers.Completion<LocationError>) in
            switch completion {
            case .failure(.permissionDenied):
                error = .permissionDenied
            case .failure(.locationServicesDisabled):
                error = .locationServicesDisabled
            case .finished:
                error = nil
                print("error is nil... finished!")
            }
        }, receiveValue: { [self] location in
            currentLocation = location
            region.center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            annotationItems.removeAll()
            annotationItems.append(location)
        })
    }
    
    func requestLocation() {
        LocationManager.shared.requestLocation()
    }
    
    func stopLocationUpdates() {
        LocationManager.shared.stopLocationUpdates()
    }
    
    func addLocation(to journal: JournalMO?, _ action: ()->Void) {
        guard let journal = journal else { return }
        guard let currentLocation = currentLocation else { return }
        clearSearch()
        
        journal.location = LocationMO(context: PersistenceController.shared.container.viewContext)
        journal.location?.id = currentLocation.id
        journal.location?.name = currentLocation.name
        journal.location?.latitude = currentLocation.latitude
        journal.location?.longitude = currentLocation.longitude
    }
    
    func updateCurrentLocation(with placemark: MKPlacemark) {
        currentLocation?.name = getLocationName(for: placemark)
        currentLocation?.latitude = placemark.coordinate.latitude
        currentLocation?.longitude = placemark.coordinate.longitude
    }
    
    func clearSearch() {
        searchText = ""
    }
    
    func search() {
        LocationManager.shared.search(searchText, for: region)
        cancellable = LocationManager.shared.searchResultsPublisher.sink { [weak self] searchResults in
            self?.searchResults = searchResults
            print("got value \(searchResults.count)")
            searchResults.forEach { result in
                print(result.placemark)
            }
        }
    }
    
    func getAddress(for placemark: CLPlacemark) -> String {
        LocationManager.shared.getAddress(for: placemark)
    }
    
    func getLocationName(for placemark: CLPlacemark) -> String {
        LocationManager.shared.getLocationName(for: placemark)
    }
    
}
