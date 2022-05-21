//
//  FootprintCdManager.swift
//  CarbonTracker
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import Foundation
import CoreData

/// This class is used to manage CRUD operations
/// in core data for FootprintCdObjects.
/// - Note that the shared static let
/// is used for singleton pattern and uses
/// app's context.
/// - Note that an instance of this class can
/// be initialized with a different context for testing
/// purposes.
final class FootprintCdManager {
    
    static let sharedFootprintCdManager = FootprintCdManager(context: AppDelegate.viewContext)
    
    let carbonTrackerContext: NSManagedObjectContext
    
    public init(context: NSManagedObjectContext) {
        self.carbonTrackerContext =  context
    }
    
    /// This computed property fetches all FootprintCdObjects entities stored in
    /// core data.
    var all: [FootprintCdObject] {
        let request: NSFetchRequest<FootprintCdObject> = FootprintCdObject.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "date", ascending: false)
        ]
        var footprintObjects: [FootprintCdObject] = []
        if let footprints = try? carbonTrackerContext.fetch(request) {
            footprintObjects = footprints
        }
        return footprintObjects
    }
    
    /// This function saves new FootprintCdObject in core data.
    /// - Parameter footprint : a FootprintDataObject to save.
    /// - Parameter completion : a closure returning
    /// a boolean value.
    func saveFootprint(with footprint: FootprintDataObject, completion: (Bool) -> Void) {
        let footprintObject = FootprintCdObject(context: carbonTrackerContext)
        footprintObject.actualFootprint = footprint.actualFootprint
        footprintObject.carMake = footprint.carMake
        footprintObject.carModel = footprint.carModel
        footprintObject.date = footprint.date
        footprintObject.destAdressLat = footprint.destAdressLat
        footprintObject.destAdressLon = footprint.destAdressLon
        footprintObject.destinationAdress = footprint.destinationAdress
        footprintObject.distance = footprint.distance
        footprintObject.numberOfPax = footprint.numberOfPax
        footprintObject.numberOfSeats = footprint.numberOfSeats
        footprintObject.occupancyScore = footprint.occupancyScore
        footprintObject.startingAdress = footprint.startingAdress
        footprintObject.startingAdressLat = footprint.startingAdressLat
        footprintObject.startingAdressLon = footprint.startingAdressLon
        footprintObject.unoccupiedSeats = footprint.unoccupiedSeats
        footprintObject.wastedCo2 = footprint.wastedCo2
        footprintObject.id = UUID().uuidString
        try? carbonTrackerContext.save()
        completion(true)
    }
    
    /// This function deletes a FootprintCdObject stored in core data.
    /// - Parameter footprintToDelete : a CarModel object to delete.
    /// - Parameter completion : a closure returning
    /// a boolean value.
    func deleteFootprint(with footprintToDelete: FootprintCdObject, completion: (Bool) -> Void) {
        let request: NSFetchRequest<FootprintCdObject> = FootprintCdObject.fetchRequest()
        request.predicate = NSPredicate.init(format: "id == %@", footprintToDelete.id!)
        if let foundFootprints = try? carbonTrackerContext.fetch(request) {
            for footprint in foundFootprints {
                carbonTrackerContext.delete(footprint)
            }
        }
        completion(true)
    }
}
