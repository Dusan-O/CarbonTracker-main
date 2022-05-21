//
//  FootprintCalculationHelperTestCase.swift
//  CarbonTrackerTests
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import XCTest
@testable import CarbonTracker

// MARK: - Class
class FootprintCalculationHelperTestCase: XCTestCase {
    
    // MARK: - Property
    var footprintHelper: FootprintCalculationsHelper!
    
    // MARK: - Setup override
    override func setUp() {
        super.setUp()
        footprintHelper = FootprintCalculationsHelper()
    }
    
    // MARK: - Tests functions
    
    func testGivenThereAre2PassengersInA6SeatsCar_WhenCalculatingOccupancy_ScoreShouldBe33() {
        footprintHelper.calculateOccupancyScore(withPaxNumber: "2", withSeatsNumber: "6")
        
        XCTAssertEqual(33, footprintHelper.occupancyScore)
    }

    func testGivenThereAre2PassengersInA6SeatsCar_WhenCalculatingMissingPassengers_ResultShould4() {
        footprintHelper.calculateMissingPassengers(withPaxNumber: "2", withSeatsNumber: "6")
        
        XCTAssertEqual(4, footprintHelper.unoccupiedSeats)
    }
    
    func testGivenPreviouslyCalculatedOccupancyScoreIs100_WhenCalculatingMissingPassengers_FunctionShouldReturnAndUnOccupiedSeatsShouldEqual0() {
        footprintHelper.calculateOccupancyScore(withPaxNumber: "6", withSeatsNumber: "6")
        
        footprintHelper.calculateMissingPassengers(withPaxNumber: "A", withSeatsNumber: "B")
        
        XCTAssertEqual(0, footprintHelper.unoccupiedSeats)
    }
    
    func testGivenPreviouslyCalculatedOccupancyScoreIs100_WhenCalculatingWastedCo2_FunctionShouldReturnAndWastedCo2ShouldEqual0() {
        footprintHelper.calculateOccupancyScore(withPaxNumber: "6", withSeatsNumber: "6")
        
        footprintHelper.calculateWastedCO2(withCo2Value: 3.5, withSeatsNumber: "b")
        
        XCTAssertEqual(0, footprintHelper.wastedCo2)
    }
    
    func testGivenThereAre3PassengersInA6SeatsCar_WhenCalculatingWastedCo2With10kgFootprint_WastedCo2ShouldEqual5() {
        footprintHelper.calculateOccupancyScore(withPaxNumber: "3", withSeatsNumber: "6")
        footprintHelper.calculateMissingPassengers(withPaxNumber: "3", withSeatsNumber: "6")
        
        
        footprintHelper.calculateWastedCO2(withCo2Value: 10, withSeatsNumber: "6")
        
        XCTAssertEqual(footprintHelper.wastedCo2, 5)
    }
    
    func testGivenThereAre6PassengersInA5SeatsCar_WhenVerifyingIfSeatsAreHigherThanPassengersNumber_paxPropertyShouldReturnfalse() {
        footprintHelper.verifySeatsEqualOrHigherThanPaxNmbr(withPaxNmbr: "6", withSeatNmbr: "5")
        
        XCTAssertFalse(footprintHelper.paxNmbrLessOrEqualSeats)
    }
    
    func testGivenThereAre5PassengersInA6SeatsCar_WhenVerifyingIfSeatsAreHigherThanPassengersNumber_paxPropertyShouldReturnTrue() {
        footprintHelper.verifySeatsEqualOrHigherThanPaxNmbr(withPaxNmbr: "5", withSeatNmbr: "6")
        
        XCTAssertTrue(footprintHelper.paxNmbrLessOrEqualSeats)
    }
    
    
}
