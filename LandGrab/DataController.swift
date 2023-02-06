//
//  DataController.swift
//  LandGrab
//
//  Created by Christopher Reese on 2/5/23.
//

import SwiftUI
import CoreData
import Foundation

class DataController: ObservableObject {
    // Storage for Core Data
    let container = NSPersistentContainer(name: "dataPlayer")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
 
}
