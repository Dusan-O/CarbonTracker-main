//
//  LocationDatasTestCase.swift
//  CarbonTrackerTests
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import XCTest
@testable import CarbonTracker

class LocationDatasTestCase: XCTestCase {
    
    func testGivenAnInstanceOfMapDatasHasBeenCreated_WhenCheckingValues_ValuesShouldMatch() {
        let placemark = Location(streetNumber: "a", streetType: "b", streetName: "c", cityName: "d", postCode: "1", country: "fr", placemark: Placemark(name: "g", lat: 4.3, lon: 2.1))
        LocationDatas.sharedLocations.destinationPlacemark = placemark
        LocationDatas.sharedLocations.startingPlacemark = placemark
        
        XCTAssertEqual(LocationDatas.sharedLocations.startingPlacemark?.streetNumber, "a")
        XCTAssertEqual(LocationDatas.sharedLocations.destinationPlacemark?.streetNumber, "a")
        
    }

}
