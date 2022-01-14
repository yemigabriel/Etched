//
//  LocationManager.swift
//  Etched
//
//  Created by Yemi Gabriel on 1/11/22.
//

import Foundation
import MapKit
import Combine

enum LocationError: Error {
    case permissionDenied
    case locationServicesDisabled
}

extension LocationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Location permission has been denied."
        case .locationServicesDisabled:
            return "Location service is disabled for this device"
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .permissionDenied:
            return "Please temporarily enable location services for Etched in your Privacy settings"
        case .locationServicesDisabled:
            return "Please enable location services in your Privacy settings"
        }
    }
}

final class LocationManager: NSObject {
    
    let searchResultsPublisher = PassthroughSubject<[MKMapItem], Never>()
    let locationPublisher = PassthroughSubject<Location, LocationError>()
    let locationManager = CLLocationManager()
    var location: CLLocation?
    
    static let shared = LocationManager()
    
    override init(/*center: CLLocationCoordinate2D, radius: CLLocationDistance*/) {
//        self.center = center
        
//        self.radius = radius
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    func requestLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }
    
    func getName(from location: CLLocation) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if error != nil {
                print("Geocoder Error: ", error?.localizedDescription ?? "")
                return
            }
            
            guard let placemarks = placemarks else { return }
            guard placemarks.isNotEmpty() else { return }
            
            if let placemark = placemarks.first {
                let currentlocation = Location(id: UUID(),
                                               name: self.getLocationName(for: placemark),
                                               latitude: location.coordinate.latitude,
                                               longitude: location.coordinate.longitude)
                
                self.locationPublisher.send(currentlocation)
            }
            
        }
    }
    
    func getLocationName(for placemark: CLPlacemark) -> String {
        "\(placemark.name == nil ? "" : "\(placemark.name!)\n" )\(self.getAddress(for: placemark))"
    }
    
    func getAddress(for placemark: CLPlacemark) -> String {
        //space between street number (subThoroughfare) and street name (thoroughfare)
        let firstSpace = (placemark.subThoroughfare != nil && placemark.thoroughfare != nil) ? " " : ""
        //comma between street and city/state
        let comma = (placemark.subThoroughfare != nil || placemark.thoroughfare != nil) && (placemark.subAdministrativeArea != nil || placemark.administrativeArea != nil) ? ", " : ""
        //space between city and state
        let secondSpace = (placemark.subAdministrativeArea != nil && placemark.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            placemark.subThoroughfare ?? "",
            firstSpace,
            placemark.thoroughfare ?? "",
            comma,
            placemark.locality ?? "",
            secondSpace,
            placemark.administrativeArea ?? ""
        )
        return addressLine
    }
    
    
    func search(_ query: String, for region: MKCoordinateRegion) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
//        request.resultTypes = .address
        request.region = region
        let search = MKLocalSearch(request: request)
        
        search.start{ [weak self] response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let response = response else { return }
            print(response.mapItems)
            self?.searchResultsPublisher.send(response.mapItems)
        }
    }
    
    static func getSnapshot(of location: LocationMO?) -> UIImage? {
        var image: UIImage?
        guard let location = location else { return nil }
        let options = MKMapSnapshotter.Options()
        let center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        
        options.camera = MKMapCamera(lookingAtCenter: center, fromDistance: 1000, pitch: 0, heading: 0)
        options.mapType = .standard
        options.size = CGSize(width: 250, height: 100)
        
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { snapshot, _ in
            if let snapshot = snapshot {
                image = snapshot.image
            }
        }
        return image
    }
    
}

extension LocationManager:  CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else { return }
        getName(from: currentLocation)
        stopLocationUpdates()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        print("paused LOC manager")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorized, .authorizedAlways, .authorizedWhenInUse:
            print("AUTH STATUS: ","authorized")
        case .denied:
            locationPublisher.send(completion: .failure(LocationError.permissionDenied))
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
}
