//
//  TestingFakePersistentContainer.swift
//  CarbonTrackerTests
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import Foundation
import CoreData

/// This class mocks a fake NSPersistentContainer for
/// testing purposes.
/// It also creates a fake viewContext used only for
/// testing purposes.
final class FakeTestingPersistentContainer {
    
    // MARK: - CREATES  A DB MODEL
    static let modelName = "CarbonTracker"
    static let model: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var testingContainer: NSPersistentContainer = {
        // MARK: - CREATES  AN IN MEMORY PERSISTENT STORE
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        
        // MARK: - CREATES AN NSPersistanceContainer INSTANCE,
        // PASSING MODEL CREATED ABOVE
        let container = NSPersistentContainer(name: FakeTestingPersistentContainer.modelName, managedObjectModel: FakeTestingPersistentContainer.model)
        container.persistentStoreDescriptions = [persistentStoreDescription]
        
        // MARK: - ASSIGNS THE IN MEMORY PERSISTENT STORE TO THE CONTAINER
        // CREATED ABOVE
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    // MARK: - CREATES A STATIC VAR RETURNING
    // LAZY VAR CONTAINER TO SIMPLIFY ACCESS
    static var testContainer: NSPersistentContainer {
        return FakeTestingPersistentContainer().testingContainer
    }
    
    // MARK: - CREATES A STATIC VAR RETURNING
    // CONTAINER'S VIEW CONTEXT TO SIMPLIFY CONTEXT USAGE.
    static var testContext: NSManagedObjectContext {
        return testContainer.viewContext
    }
    
}

