//
//  CarModelObjectManager.swift
//  CarbonTracker
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import Foundation
import CoreData

/// This class is used to manage CRUD operations
/// in core data for CarModel objects.
/// - Note that the shared static let
/// is used for singleton pattern and uses
/// app's context.
/// - Note that an instance of this class can
/// be initialized with a different context for testing
/// purposes.
final class CarModelObjectManager {
    
    static let sharedCarModelObjectManager = CarModelObjectManager(context: AppDelegate.viewContext)
    
    let carbonTrackerContext: NSManagedObjectContext
    
    public init(context: NSManagedObjectContext) {
        self.carbonTrackerContext =  context
    }
    
    /// This computed property fetches all CarModelObjects entities stored in
    /// core data.
    var all: [CarModelObject] {
        let request: NSFetchRequest<CarModelObject> = CarModelObject.fetchRequest()
        request.sortDescriptors = [
        NSSortDescriptor(key: "vehicle_make", ascending: true),
        NSSortDescriptor(key: "name", ascending: true)
        ]
        var carObjects: [CarModelObject] = []
        if let cars = try? carbonTrackerContext.fetch(request) {
            carObjects = cars
        }
        return carObjects
    }
    
    /// This function saves new CarModelObject in core data.
    /// - Parameter carModel : a CarModel object to save.
    /// - Parameter completion : a closure returning
    /// a boolean value.
    func saveCarModel(with carModel: CarModelDatas, completion: (Bool) -> Void) {
        let carObject = CarModelObject(context: carbonTrackerContext)
        carObject.id = carModel.data.id
        carObject.year = Int16(carModel.data.attributes.year)
        carObject.name = carModel.data.attributes.name
        carObject.vehicle_make = carModel.data.attributes.vehicle_make
        carObject.isCurrentCar = true
        try? carbonTrackerContext.save()
        completion(true)
    }
    
    /// This function deletes a car object stored in core data.
    /// - Parameter carModelToDelete : a CarModel object to delete.
    /// - Parameter completion : a closure returning
    /// a boolean value.
    func deleteCarModel(with carModelToDelete: CarModelDatas, completion: (Bool) -> Void) {
        let request: NSFetchRequest<CarModelObject> = CarModelObject.fetchRequest()
        request.predicate = NSPredicate.init(format: "id == %@", carModelToDelete.data.id)
        if let foundCarModels = try? carbonTrackerContext.fetch(request) {
            for car in foundCarModels {
                carbonTrackerContext.delete(car)
            }
        }
        completion(true)
    }
    
    /// This function updates a car object stored in core data.
    /// - Parameter carModel : a CarModel object to udpate.
    /// - Parameter completion : a closure returning
    /// a boolean value.
    func updateFavouriteCar(with carModel: CarModelDatas, completion: (Bool) -> Void) {
        let request: NSFetchRequest<CarModelObject> = CarModelObject.fetchRequest()
        if let cars = try? carbonTrackerContext.fetch(request) {
            for car in cars {
                if car.id == carModel.data.id {
                    car.isCurrentCar = true
                    try? carbonTrackerContext.save()
                } else {
                    car.isCurrentCar = false
                    try? carbonTrackerContext.save()
                }
            }
        }
        completion(true)
    }
    
    /// This function returns a single CarModel object stored in core data,
    /// which is the user's car to be used later for
    /// footprint calculations.
    func fetchFavouriteCar() -> CarModels?  {
        let request: NSFetchRequest<CarModelObject> = CarModelObject.fetchRequest()
        request.predicate = NSPredicate.init(format: "isCurrentCar == %@", NSNumber(value: true))
        guard let favCars = try? carbonTrackerContext.fetch(request) else { return nil }
        guard let car = favCars.first else { return nil }
        var carModel: CarModels?
        if let id = car.id, let name = car.name, let make = car.vehicle_make {
            carModel = CarModels(id: id, attributes: CarAttributes(name: name, year: Int(car.year), vehicle_make: make))
        }
        return carModel
    }
    
    /// This function returns a boolean.
    /// It checks if a given car is the current favourite car.
    func isCarFavourite(with carModel: CarModels) -> Bool {
        let request: NSFetchRequest<CarModelObject> = CarModelObject.fetchRequest()
        request.predicate = NSPredicate.init(format: "isCurrentCar == %@", NSNumber(value: true))
        guard let favCars = try? carbonTrackerContext.fetch(request) else { return false }
        for favCar in favCars {
            if favCar.id == carModel.id  {
                return true
            }
        }
        return false
    }
    
}
