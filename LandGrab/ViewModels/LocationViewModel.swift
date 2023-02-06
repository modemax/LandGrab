//
//  LocationViewModel.swift
//  LandGrab
//
//  Created by Christopher Reese on 1/14/23.
//

import SwiftUI
import Foundation
import MapKit
import CoreLocation

class MapCustomDelegate: NSObject, MKMapViewDelegate {
    var parent: MKMapView
    
    init(_ parent: MKMapView) {
        self.parent = parent
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
      if let tileOverlay = overlay as? MKTileOverlay {
        let renderer = MKTileOverlayRenderer(overlay: tileOverlay)
        return renderer
      }
      return MKOverlayRenderer()
    }
}

class LocationViewModel: NSObject, CLLocationManagerDelegate, ObservableObject {
    var locationManager: CLLocationManager
    
    // update / track location City and Neighborhood
    @Published var locationName: String
    @Published var locationNameSubtitle: String
    
    // Stored Locations for Annotation on the Map
    var locations: [Location]
    @Published var shownLocation: Location {
        didSet {
            updateLocationAndRegion()
        }
    }
    
    var mapRegion: MKCoordinateRegion
    
    var mapOverlay: MKTileOverlay
    
    // Flag to show the list of locations.
    @Published var showLocationList: Bool = false
    
    // Flag to determine if current location is being actively shown in view.
    @Published var showCurrentLocation: Bool = true
    @Published var showLocationPreview = false
    @Published var sheetLocation: Location? = nil
    
    override init() {
        let locManager = CLLocationManager()
        locationManager = locManager
        
        locationName = ""
        locationNameSubtitle = LocationsDataService.symCurrentLocation
        
        let locationsList = LocationsDataService.locations
        locations = locationsList
        
        // shownLocation = the currently shownLocation
        shownLocation = locationsList.first!
        
        mapRegion = MKCoordinateRegion()
        
        mapOverlay = MKTileOverlay(urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png")
        mapOverlay.canReplaceMapContent = true;
        
        super.init()
        
        locationManager.delegate = self
        locationManager.distanceFilter = 10
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Update the Region around the current location.
        updateLocationAndRegion()
        updateGeocoder()
        
        print("updateLoc")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Error: \(error)")
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let tileOverlay = overlay as? MKTileOverlay {
            let renderer = MKTileOverlayRenderer(overlay: tileOverlay)
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    func updateGeocoder() {
        guard let location = self.locationManager.location else { return }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard let placemark = placemarks?.first else { return }
            self.locationNameSubtitle = placemark.locality ?? "Unknown Location"
            self.locationName = placemark.subLocality ?? "Unknown Location"
            print("updateGeocoder")
        }
    }
    
    // Update the Location and Region based on either current location or selected location.
    func updateLocationAndRegion() {
        withAnimation(.easeInOut) {
            let currentLocation = self.showCurrentLocation ? self.locationManager.location?.coordinate : self.shownLocation.coordinates
            self.mapRegion = MKCoordinateRegion(center: currentLocation!,
                                                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
            
            // FIX??
            let randomLatitude = currentLocation!.latitude + (Double.random(in: -0.5...0.5) * 0.01)
            let randomLongitude = currentLocation!.longitude + (Double.random(in: -0.5...0.5) * 0.01)
            
            let randomLocation = CLLocationCoordinate2D(latitude: randomLatitude, longitude: randomLongitude)
            
            let randomPickup = Location(type: LocationType.PickupItem, name: "Pickup", nameSubtitle: "BONUS", coordinates: randomLocation, description: "", imageName: "")
            
            locations.append(randomPickup)
        }
    }
    
    // Toggle Showing the list of locations.
    func toggleShowLocationList() {
        withAnimation(.easeInOut) {
            DispatchQueue.main.async {
                self.showLocationList.toggle()
            }
        }
    }
    
    
    func changeLocation(location: Location) {
        withAnimation(.easeInOut) {
            if location.type == LocationType.CurentPosition {
                self.updateGeocoder()
                self.showCurrentLocation = true
                self.showLocationPreview = false
                self.showLocationList.toggle()
            } else if location.type == LocationType.PickupItem {
                self.showCurrentLocation = false
                self.showLocationPreview = true
                self.shownLocation = location
            } else {
                self.showLocationList.toggle()
                self.showCurrentLocation = false
                self.showLocationPreview = true
                self.shownLocation = location
                self.locationName = location.name
                self.locationNameSubtitle = location.nameSubtitle
            }
            // Updating the Region is causing a runtime error (Publishing changes from within view updates is not allowed, this will cause undefined behavior.
            self.updateLocationAndRegion()
        }
    }
    
    func showLocationDetail(locationID: String) {
        self.sheetLocation = locations.first!
    }
    
    func PickupItem(location: Location) {
        locations.removeAll(where: { $0.id == location.id })
    }
}



