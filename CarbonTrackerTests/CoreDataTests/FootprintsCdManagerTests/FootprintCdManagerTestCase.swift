//
//  FootprintCdManagerTestCase.swift
//  CarbonTrackerTests
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import XCTest
@testable import CarbonTracker
import CoreData

// - MARK: CLASS

class FootprintCdManagerTestCase: XCTestCase {
    
    // - MARK: PROPERTIES
    
    var footprintModelManager: FootprintCdManager!
    
    // - MARK: FUNCTIONS OVERRIDES
    
    override func setUp() {
        super.setUp()
        footprintModelManager = FootprintCdManager(context: FakeTestingPersistentContainer.testContext)
    }
    
    // - MARK: TESTING FUNCTIONS
    
    func testGivenCoreDataIsEmpty_WhenSavingAFootprint_AllShouldCount1() {
        footprintModelManager.saveFootprint(with: SampleFootprintDataObjects.footprint1) { success in
            XCTAssertTrue(footprintModelManager.all.count == 1)
            XCTAssertEqual(footprintModelManager.all[0].startingAdressLat, SampleFootprintDataObjects.footprint1.startingAdressLat)
        }
    }
    
    func testGivenCoreDataContains2Footprints_WhenDeleting1_AllShouldCount1() {
        // Given - Saving 2 entities
        footprintModelManager.saveFootprint(with: SampleFootprintDataObjects.footprint1) { success in
            XCTAssertTrue(footprintModelManager.all.count == 1)
        }
        footprintModelManager.saveFootprint(with: SampleFootprintDataObjects.footprint2) { success in
            XCTAssertTrue(footprintModelManager.all.count == 2)
        }
        // Given - Retrieving UUID of entity to delete, to be able to find the correct entity.
        let footprintToDelete = footprintModelManager.all[1]
        let footprintToKeep = footprintModelManager.all[0]
        //When
        footprintModelManager.deleteFootprint(with: footprintToDelete) { success in
            // Then
            XCTAssertEqual(footprintModelManager.all.count, 1)
        }
        // Then
        XCTAssertEqual(footprintModelManager.all[0].id, footprintToKeep.id)
    }
    
    
}
