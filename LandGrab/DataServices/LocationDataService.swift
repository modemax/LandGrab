//
//  LocationDataService.swift
//  LandGrab
//
//  Created by Christopher Reese on 1/14/23.
//

import SwiftUI
import Foundation
import MapKit


class LocationsDataService {
    static let symCurrentLocation: String = "@"
    static let locations: [Location] = [
   
        Location(
            type: LocationType.POI,
            name: "Deschutes Brewery",
            nameSubtitle: "Bend",
            coordinates: CLLocationCoordinate2D(latitude: 44.059398, longitude: -121.311288),
            description: "Deschutes Brewery.  Goood Beeer!",
            imageName: "Deschutes_001"
          ),
        
        Location(
            type: LocationType.POI,
            name: "Brown Owl",
            nameSubtitle: "Bend",
            coordinates: CLLocationCoordinate2D(latitude: 44.050776, longitude: -121.315514),
            description: "Brown Owl. Good Food. Good Beer. Good People.",
            imageName: "BrownOwl_001"
        ),
        
        Location(
            type: LocationType.POI,
            name: "Blakely Park",
            nameSubtitle: "Bend",
            coordinates: CLLocationCoordinate2D(latitude: 44.037870, longitude: -121.318339),
            description: "Blakely Park",
            imageName: "BlakleyPark_001"
            )
        ]
}
