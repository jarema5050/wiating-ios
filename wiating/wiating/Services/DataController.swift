//
//  DataController.swift
//  wiating
//
//  Created by Jędrzej Sokołowski on 16/01/2023.
//

import CoreData

class CoreDataStack: ObservableObject {
    let container: NSPersistentContainer
    
    lazy var managedContext = self.container.viewContext
    
    init(modelName: String) {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { description, error in
            if let error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        self.container = container
    }
    
    func saveContext() {
        guard managedContext.hasChanges else { return }
        
        do {
            try managedContext.save()
        } catch {
            print("Unresolved error \(error.localizedDescription)")
        }
    }
}
