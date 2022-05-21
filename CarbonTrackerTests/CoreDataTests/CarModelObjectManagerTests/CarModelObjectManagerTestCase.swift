//
//  CarModelObjectManagerTestCase.swift
//  CarbonTrackerTests
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import XCTest
@testable import CarbonTracker
import CoreData

// - MARK: CLASS

class CarModelObjectManagerTestCase: XCTestCase {
    
    // - MARK: PROPERTIES
    
    var carModelManager: CarModelObjectManager!
    
    // - MARK: FUNCTIONS OVERRIDES
    
    override func setUp() {
        super.setUp()
        carModelManager = CarModelObjectManager(context: FakeTestingPersistentContainer.testContext)
    }
    
    // - MARK: TESTING FUNCTIONS
    
    func testGivenCoreDataIsEmpty_WhenSavingACar_AllShouldCount1() {
        carModelManager.saveCarModel(with: SampleCarModelObjects.f50) { success in
            XCTAssertTrue(carModelManager.all.count == 1)
            XCTAssertEqual(carModelManager.all[0].year, Int16(SampleCarModelObjects.f50.data.attributes.year))
        }
    }

    func testGivenCoreDataContains2Cars_WhenDeleting1_AllShouldCount1() {
        carModelManager.saveCarModel(with: SampleCarModelObjects.f50) { success in
            XCTAssertTrue(success)
        }
        carModelManager.saveCarModel(with: SampleCarModelObjects.maranello) { success in
            XCTAssertTrue(success)
        }
        carModelManager.deleteCarModel(with: SampleCarModelObjects.maranello) { success in
            XCTAssertEqual(carModelManager.all.count, 1)
        }
    }

    func testGivenCoreDataContains3Objects_WhenUpdatingFavouriteCar_UpdatedCarShouldHaveTrueAndOthersFalse() {
        carModelManager.saveCarModel(with: SampleCarModelObjects.f50) { success in
            XCTAssertTrue(success)
        }
        carModelManager.saveCarModel(with: SampleCarModelObjects.maranello) { success in
            XCTAssertTrue(success)
        }
        carModelManager.saveCarModel(with: SampleCarModelObjects.modena) { success in
            XCTAssertTrue(success)
        }

        carModelManager.updateFavouriteCar(with: SampleCarModelObjects.f50) { success in
            XCTAssertTrue(success)
        }
        XCTAssertEqual(carModelManager.all[2].isCurrentCar, true)
        XCTAssertEqual(carModelManager.all[1].isCurrentCar, false)
        XCTAssertEqual(carModelManager.all[0].isCurrentCar, false)
    }
    
    func testGivenCoreDataContains3Objects_WhenFetchingUsersFavCar_FavouriteCarShouldBeFerrariF50() {
        carModelManager.saveCarModel(with: SampleCarModelObjects.f50) { success in
            XCTAssertTrue(success)
        }
        carModelManager.saveCarModel(with: SampleCarModelObjects.maranello) { success in
            XCTAssertTrue(success)
        }
        carModelManager.saveCarModel(with: SampleCarModelObjects.modena) { success in
            XCTAssertTrue(success)
        }
        carModelManager.updateFavouriteCar(with: SampleCarModelObjects.f50) { success in
            XCTAssertTrue(success)
        }

        let favCar = carModelManager.fetchFavouriteCar()
        guard let car = favCar else { return }

        XCTAssertEqual(car.attributes.name, "Ferrari F50")
    }
    
    func testGivenCoreDataContains3Objects_WhenFetchingFavCarWhileNoCarIsFav_FetchFavouriteFunctionShouldReturnNil() {
        carModelManager.saveCarModel(with: SampleCarModelObjects.f50) { success in
            XCTAssertTrue(success)
        }
        carModelManager.saveCarModel(with: SampleCarModelObjects.maranello) { success in
            XCTAssertTrue(success)
        }
        carModelManager.saveCarModel(with: SampleCarModelObjects.modena) { success in
            XCTAssertTrue(success)
        }

        for car in carModelManager.all {
            car.isCurrentCar = false
            try? carModelManager.carbonTrackerContext.save()
        }
        let favCar = carModelManager.fetchFavouriteCar()

        XCTAssertNil(favCar)
    }
    
    func testGivenCoreDataContains1FavCar_WhenCheckingIfThisCarIsFav_TrueShouldBeReturned() {
        carModelManager.saveCarModel(with: SampleCarModelObjects.f50) { success in
            XCTAssertTrue(success)
        }
        carModelManager.updateFavouriteCar(with: SampleCarModelObjects.f50) { success in
            XCTAssertTrue(success)
        }
        
        let isFavourite = carModelManager.isCarFavourite(with: SampleCarModelObjects.f50.data)
        XCTAssertTrue(isFavourite)
    }
    
    func testGivenCoreDataContains1FavCarOutof2cars_WhenCheckingIfThisCarIsFavWhileItsActuallyNot_FalseShouldBeReturned() {
        carModelManager.saveCarModel(with: SampleCarModelObjects.f50) { success in
            XCTAssertTrue(success)
        }
        carModelManager.saveCarModel(with: SampleCarModelObjects.modena) { success in
            XCTAssertTrue(success)
        }
        carModelManager.updateFavouriteCar(with: SampleCarModelObjects.modena) { success in
            XCTAssertTrue(success)
        }
        
        let isFavourite = carModelManager.isCarFavourite(with: SampleCarModelObjects.f50.data)
        XCTAssertFalse(isFavourite)
    }
}
