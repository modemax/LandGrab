//
//  Location.swift
//  LandGrab
//
//  Created by Christopher Reese on 1/14/23.
//

import Foundation
import MapKit

struct IdentifiablePlace: Identifiable {
    let id: UUID
    let location: CLLocationCoordinate2D
    let place: Location
    
    init(id: UUID = UUID(), lat: Double = 0.0, long: Double = 0.0, locationID: String = "", place: Location) {
        self.id = id
        self.location = CLLocationCoordinate2D(
            latitude: lat,
            longitude: long)
        self.place = place
    }
}

enum LocationType {
    case CurentPosition
    case POI
    case PickupItem
}

let LocationType_PickupIteam_Image = "coloncurrencysign.circle"

struct Location: Identifiable, Equatable {
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: UUID = UUID()
    let type: LocationType
    let name: String
    let nameSubtitle: String
    let coordinates: CLLocationCoordinate2D
    let description: String
    let imageName: String
    
    // Identifiable
    //var id: String {
//    var id: UUID {    // name = "Deschutes Brewery"
        // nameSubtitle = "Bend"
        // id = "Deschutes BreweryBend"
        //name + nameSubtitle + (UUID() as String)
 //   }
}
