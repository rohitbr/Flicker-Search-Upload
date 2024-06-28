//
//  CoreDataViewModel.swift
//  FlickerSearch
//
//  Created by Bhat, Rohit on 5/28/24.
//

import Foundation
import CoreData

class CoreDataViewModel : ObservableObject {
    let container : NSPersistentContainer
    
    init() {
        // load up coredata
        container = NSPersistentContainer(name: "")
        container.loadPersistentStores { description, error in
            if error != nil {
                print("Returned an error")
            }
        }
    }
    
}
