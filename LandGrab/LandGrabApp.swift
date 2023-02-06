//
//  LandGrabApp.swift
//  LandGrab
//
//  Created by Christopher Reese on 12/30/22.
//

import SwiftUI

    
@main
struct LandGrabApp: App {
    
    @StateObject private var vm = LocationViewModel()
    @StateObject private var dc = DataController()
    
    var body: some Scene {
        WindowGroup {
            LocationView()
                .environmentObject(vm)
                .environment(\.managedObjectContext, dc.container.viewContext)
        }
    }
}
    

