//
//  CoreDataStack.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 24/04/2019.
//  Copyright © 2019 Zdeno Bacik. All rights reserved.
//

import CoreData

class CoreDataStack {
    
    private let modelName: String
    
    lazy var mainContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    lazy var storeContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        return container
    }()
    
    init(modelName: String) {
        self.modelName = modelName
    }
}


extension CoreDataStack {
    
    func saveContext () {
        guard mainContext.hasChanges else { return }
        
        do {
            try mainContext.save()
        } catch let nserror as NSError {
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

