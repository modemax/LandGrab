//
//  LocationListView.swift
//  LandGrab
//
//  Created by Christopher Reese on 1/15/23.
//

import SwiftUI
import CoreLocation

struct LocationListView: View {
    @EnvironmentObject private var vm: LocationViewModel
   
    var body: some View {
        List {
            let currentLocation = Location(type: LocationType.CurentPosition,
                                           name: LocationsDataService.symCurrentLocation, nameSubtitle: "", coordinates: CLLocationCoordinate2D(), description: "", imageName: "")
            
            Button {
                vm.changeLocation(location: currentLocation)
            } label: {
                listRowView(location: currentLocation)
            }
            .padding(.vertical, 4)
            .listRowBackground(Color.clear)
            
            ForEach(vm.locations) { location in
                Button {
                    vm.changeLocation(location: location)
                } label: {
                    listRowView(location: location)
                }
                .padding(.vertical, 4)
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(PlainListStyle())
    }
}


struct LocationListView_Previews: PreviewProvider {
    static var previews: some View {
        LocationListView()
           .environmentObject(LocationViewModel())
    }
}



extension LocationListView {
    
    private func listRowView(location: Location) -> some View {
        withAnimation(.easeInOut) {
            HStack {
                if location.type == LocationType.CurentPosition {
                    Image(systemName: "location")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 45, height: 45)
                        .cornerRadius(10)
                }
                else {
                    Image(location.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 45, height: 45)
                        .cornerRadius(10)
                }
                
                VStack(alignment: .leading) {
                    if location.type == LocationType.CurentPosition {
                        Text("Current Location")
                            .font(.headline)
                        Text(vm.locationNameSubtitle)
                            .font(.subheadline)
                    } else {
                        Text(location.name)
                            .font(.headline)
                        Text(location.nameSubtitle)
                            .font(.subheadline)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

