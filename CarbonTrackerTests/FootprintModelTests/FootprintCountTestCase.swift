//
//  FootprintCountTestCase.swift
//  CarbonTrackerTests
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import XCTest
import CoreData
@testable import CarbonTracker

// MARK: - Class
class FootprintCountTestCase: XCTestCase {
        
        // MARK: - Properties
    var footprintModelManager: FootprintCdManager!
    var footprintCountManager: FootprintCountManager!
        
    // MARK: - Setup override
    override func setUp() {
        super.setUp()
        footprintCountManager = FootprintCountManager()
        footprintModelManager = FootprintCdManager(context: FakeTestingPersistentContainer.testContext)
    }
    
    // MARK: - Tests functions
    
    func testGivenCoreDataContainsObjects_WhenCalculatingCo2Count_ResultShouldBeCorrect() {
        // Given - Saving 2 entities
        footprintModelManager.saveFootprint(with: SampleFootprintDataObjects.footprint1) { success in
            XCTAssertTrue(footprintModelManager.all.count == 1)
        }
        footprintModelManager.saveFootprint(with: SampleFootprintDataObjects.footprint2) { success in
            XCTAssertTrue(footprintModelManager.all.count == 2)
        }
        // When
        footprintCountManager.calculateFootprintsCo2Count(from: footprintModelManager.all)
        // Then
        XCTAssertEqual(footprintCountManager.co2Count, 10.6)
    }

    func testGivenCoreDataContainsObjects_WhenCalculatingWastedCo2Count_ResultShouldBeCorrect() {
        // Given - Saving 2 entities
        footprintModelManager.saveFootprint(with: SampleFootprintDataObjects.footprint1) { success in
            XCTAssertTrue(footprintModelManager.all.count == 1)
        }
        footprintModelManager.saveFootprint(with: SampleFootprintDataObjects.footprint3) { success in
            XCTAssertTrue(footprintModelManager.all.count == 2)
        }
        // When
        footprintCountManager.calculateFootprintsWastedCo2Count(from: footprintModelManager.all)
        // Then
        XCTAssertEqual(footprintCountManager.wastedCo2Count, 14.9)
    }
    
    func testGivenCoreDataContainsObjects_WhenCalculatingAverageOccupancyScore_ResultShouldBeCorrect() {
        // Given - Saving 2 entities
        footprintModelManager.saveFootprint(with: SampleFootprintDataObjects.footprint1) { success in
            XCTAssertTrue(footprintModelManager.all.count == 1)
        }
        footprintModelManager.saveFootprint(with: SampleFootprintDataObjects.footprint3) { success in
            XCTAssertTrue(footprintModelManager.all.count == 2)
        }
        footprintModelManager.saveFootprint(with: SampleFootprintDataObjects.footprint2) { success in
            XCTAssertTrue(footprintModelManager.all.count == 3)
        }
        // When
        footprintCountManager.calculateAverageCarOccupancy(from: footprintModelManager.all)
        // Then
        XCTAssertEqual(footprintCountManager.occupancyAverage, 79)
    }
    
    func testGivenCoreDataContainsObjects_WhenCalculatingTotalDistance_ResultShouldBeCorrect() {
        // Given - Saving 2 entities
        footprintModelManager.saveFootprint(with: SampleFootprintDataObjects.footprint1) { success in
            XCTAssertTrue(footprintModelManager.all.count == 1)
        }
        footprintModelManager.saveFootprint(with: SampleFootprintDataObjects.footprint3) { success in
            XCTAssertTrue(footprintModelManager.all.count == 2)
        }
        // When
        footprintCountManager.calculateTotalDistanceTraveled(from: footprintModelManager.all)
        // Then
        XCTAssertEqual(footprintCountManager.totalDistance, 70.0)
    }
    
    func testGivenCOreDataCOntainsObjectsAndTotalDistanceAndTotalCo2HaveBeenCalculated_WhenCalculatingSustainableEmissions_ResultShouldBeCorrect() {
        // Given - Saving 2 entities And calculating distance traveled
        footprintModelManager.saveFootprint(with: SampleFootprintDataObjects.footprint1) { success in
            XCTAssertTrue(footprintModelManager.all.count == 1)
        }
        footprintModelManager.saveFootprint(with: SampleFootprintDataObjects.footprint3) { success in
            XCTAssertTrue(footprintModelManager.all.count == 2)
        }
        footprintCountManager.calculateTotalDistanceTraveled(from: footprintModelManager.all)
        footprintCountManager.calculateFootprintsCo2Count(from: footprintModelManager.all)
        // When
        footprintCountManager.calculateSustainableEmissions(fromDistance: footprintCountManager.totalDistance, withCarEmissions: footprintCountManager.co2Count)
        // Then
        XCTAssertEqual(footprintCountManager.sustainableEmissions, 70.1)
        
        
    }
    
    func testGivenCOreDataCOntainsObjectsAndTotalDistanceAndTotalCo2HaveBeenCalculated_WhenCalculatingProgressValue_ResultShouldBeCorrect() {
        // Given - Saving 2 entities And calculating distance traveled
        footprintModelManager.saveFootprint(with: SampleFootprintDataObjects.footprint1) { success in
            XCTAssertTrue(footprintModelManager.all.count == 1)
        }
        footprintModelManager.saveFootprint(with: SampleFootprintDataObjects.footprint3) { success in
            XCTAssertTrue(footprintModelManager.all.count == 2)
        }
        footprintCountManager.calculateTotalDistanceTraveled(from: footprintModelManager.all)
        footprintCountManager.calculateFootprintsCo2Count(from: footprintModelManager.all)
        footprintCountManager.calculateSustainableEmissions(fromDistance: footprintCountManager.totalDistance, withCarEmissions: footprintCountManager.co2Count)
        // When
        footprintCountManager.getProgressViewPercentage(withCo2Value: footprintCountManager.co2Count)
        // Then
        XCTAssertEqual(footprintCountManager.progressViewPercentage, 0.1)
        
        
    }
}
