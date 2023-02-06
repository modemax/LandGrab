//
//  LocationView.swift
//  LandGrab
//
//  Created by Christopher Reese on 1/14/23.
//

import SwiftUI
import MapKit


struct LocationView: View {
    @EnvironmentObject private var vm: LocationViewModel
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var playerProfile: FetchedResults<Profile>
    
    let maxWidthForIpad: CGFloat = 700
    
    @State private var trackingMode: MapUserTrackingMode = .follow
    @State private var updateMap: Bool = true
    
    // Bind vm.mapRegion w/ state variable to prevent region update during view.
    private var region : Binding<MKCoordinateRegion> {
        Binding {
            vm.mapRegion
        } set: { region in
            DispatchQueue.main.async {
                vm.mapRegion = region
            }
        }
    }
    
    private let mapAppearanceInstance = MKMapView.appearance()
    private var mapCustomDelegate: MapCustomDelegate = MapCustomDelegate(MKMapView.appearance())
    
   
    var body: some View {
        ZStack {
            mapLayer
                .ignoresSafeArea()
          
            VStack {
                HStack {
                    profile
                    
                    header
                        .padding()
                        .frame(maxWidth: maxWidthForIpad)
                }
                
                Spacer()
                
                if vm.showLocationPreview {
                    locationPreviewStack
                }
            }
            .sheet(item: $vm.sheetLocation, onDismiss: nil) { location in
                LocationDetailView(location: location)
            }
        }
        .onChange(of: self.updateMap) {newValue in
            DispatchQueue.main.async {
                self.mapLayer
            }
        }
    }
}


//
// Preview
struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
            .environmentObject(LocationViewModel())
    }
}

//
// Extension: LocationView
extension LocationView {
    //
    // profile
    private var profile: some View {
        HStack {
            Button {
                
            } label: {
                ZStack {
                    Image(systemName: "person.crop.circle")
                        .fontWeight(.regular)
                        .imageScale(.large)
                        .opacity(100)
                        .foregroundColor(.blue)
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: "person.crop.circle.fill")
                        .fontWeight(.regular)
                        .imageScale(.medium)
                        .foregroundColor(.primary)
                        .opacity(0)
                }
                //.background(.red) //-- DEBUG VIEW.
            }
            .buttonStyle(.bordered)
            .cornerRadius(32)
            //.background(.blue)  //-- DEBUG VIEW.
        }
        .frame(width: 64, height: 64)
        //.background(.green)  //-- DEBUG VIEW.
    }
    
    //
    // header
    private var header: some View {
            VStack {
                Button(action: vm.toggleShowLocationList) {
                    VStack(spacing: 0) {
                        Text(vm.locationName)
                            .font(.headline)
                            .fontWeight(.black)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                            .offset(y: 10)
                        
                        Text(vm.locationNameSubtitle)
                            .font(.subheadline)
                            .fontWeight(.black)
                            .foregroundColor(.primary)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .animation(.none, value: vm.shownLocation)
                            .overlay(alignment: .leading) {
                                Image(systemName: "arrow.down")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .padding()
                                    .rotationEffect(Angle(degrees: vm.showLocationList ? 180 : 0))
                            }
                    }
                }
                
                if vm.showLocationList {
                    LocationListView()
                }
            }
            .background(.thickMaterial)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.3), radius: 20, x:0, y:15)
            
    }
    
    // mapLayer
    //
    private var mapLayer: some View {
        VStack {
            let placeLocations = vm.locations
            let annotations = placeLocations.map {
                IdentifiablePlace(id: $0.id, lat: $0.coordinates.latitude, long: $0.coordinates.longitude, place: $0.self)
            }
            
            Map(coordinateRegion: region,
                showsUserLocation: true,
                userTrackingMode: $trackingMode,
                annotationItems: annotations,
                annotationContent: { annotation in
                MapAnnotation(coordinate: annotation.location) {
                    if annotation.place.type == LocationType.PickupItem {
                        PickupAnnotationView()
                            .shadow(radius: 10)
                            .onTapGesture {
                                vm.changeLocation(location: annotation.place)
                            }
                    } else { // LocationType.POI
                        LocationMapAnnotationView()
                            .shadow(radius: 10)
                            .scaleEffect(vm.shownLocation.id == annotation.id ? 1 : 0.7)
                            .onTapGesture {
                                vm.shownLocation = annotation.place
                                vm.sheetLocation = annotation.place
                            }
                    }
                }
            }
            )
        }
        .onAppear {
            self.mapAppearanceInstance.delegate = mapCustomDelegate
            self.mapAppearanceInstance.addOverlay(vm.mapOverlay)
        }
    }
    
    private var locationPreviewStack: some View {
        ZStack {
            ForEach(vm.locations) { location in
                if vm.shownLocation == location {
                    LocationPreviewView(location: location)
                        .shadow(color: Color.black.opacity(0.3), radius: 20)
                        .padding()
                        .frame(maxWidth: maxWidthForIpad)
                        .frame(maxWidth: .infinity)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)))
                }
            }
        }
    }
}
