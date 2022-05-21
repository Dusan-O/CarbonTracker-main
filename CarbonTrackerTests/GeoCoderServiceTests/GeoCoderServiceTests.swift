//
//  GeoCoderServiceTests.swift
//  CarbonTrackerTests
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import XCTest
@testable import CarbonTracker

class GeoCoderServiceTests: XCTestCase {

    let geoService = CarbonTracker.GeoCoderService.sharedGeoCoderHelper
    let adress1 = "6 rue de rivoli, 75001, Paris, France"
    
    
    func testGivenAnAdressIsProvided_WhenGettingCoordinates_CoordinatesShouldMatch() {
        let expectation = XCTestExpectation(description: "Wait for Queue Change and GeoCoding")
        geoService.getCoordinatesFrom(adress1) { placemark in
            guard case .success(let data) = placemark else {
                XCTFail("Test with correct data failed")
                return
            }
            XCTAssertEqual(data.lat, 48.85555124687402, accuracy: 0.010, "Latitude doesn't match")
            XCTAssertEqual(data.lon, 2.3612722982465946, accuracy: 0.010, "Longitude doesn't match")
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 4.0)
    }
    
    func testGivenAnInvalidAdressIsProvided_WhenGettingCoordinates_CompletionShouldRetornError() {
        let expectation = XCTestExpectation(description: "Wait for Queue Change and GeoCoding")
        geoService.getCoordinatesFrom("$&'',.,,") { placemark in
            guard case .failure(let error) = placemark else {
                XCTFail("Nothing failed in No Data test.")
                return
            }
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 4.0)
    }
    
}
