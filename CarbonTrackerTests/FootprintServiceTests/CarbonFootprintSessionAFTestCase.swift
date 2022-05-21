//
//  CarbonFootprintSessionAFTestCase.swift
//  CarbonTrackerTests
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import XCTest
@testable import CarbonTracker

class CarbonFootprintSessionAFTestCase: XCTestCase {

    func testGivenAttemptingToFetchAFootprint_WhenReceivingCorrectDataWithNoErrorAndCorrectResponse_CompletionShouldPostSuccess() {
        let mockSession = MockCarMakeSession(mockResponse: MockResponse(response: FootprintFakeResponseData.responseOK, data: FootprintFakeResponseData.footprintCorrectData))
        let footprintSession = CarbonFootprintSessionAF(session: mockSession)
        let expectation = XCTestExpectation(description: "Wait for Queue Change")
        let encodedData = EncodableDataRequest(type: "a", distance_unit: "b", distance_value: 1.2, vehicle_model_id: "c")
        footprintSession.fetchCarbonFootprint(withData: encodedData) { result in
            guard case .success(let data) = result else {
                XCTFail("Test with correct data failed")
                return
            }
            XCTAssertEqual(data.data.attributes.carbon_kg, 531.4)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.9)
    }
    
    func testGivenAttemptingToFetchAFootprint_WhenReceivingNoData_CompletionShouldPostFailure() {
        let mockSession = MockCarMakeSession(mockResponse: MockResponse(response: FootprintFakeResponseData.responseOK, data: nil))
        let footprintSession = CarbonFootprintSessionAF(session: mockSession)
        let expectation = XCTestExpectation(description: "Wait for Queue Change")
        let encodedData = EncodableDataRequest(type: "a", distance_unit: "b", distance_value: 1.2, vehicle_model_id: "c")
        footprintSession.fetchCarbonFootprint(withData: encodedData) { result in
            guard case .failure(let error) = result else {
                XCTFail("Nothing failed in No Data test.")
                return
            }
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.9)
    }
    
    func testGivenAttemptingToFetchAFootprint_WhenReceivingIncorectData_CompletionShouldPostFailure() {
        let mockSession = MockCarMakeSession(mockResponse: MockResponse(response: FootprintFakeResponseData.responseOK, data: FootprintFakeResponseData.footprintIncorrectData))
        let footprintSession = CarbonFootprintSessionAF(session: mockSession)
        let expectation = XCTestExpectation(description: "Wait for Queue Change")
        let encodedData = EncodableDataRequest(type: "a", distance_unit: "b", distance_value: 1.2, vehicle_model_id: "c")
        footprintSession.fetchCarbonFootprint(withData: encodedData) { result in
            guard case .failure(let error) = result else {
                XCTFail("Nothing failed in No Data test.")
                return
            }
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.9)
    }
    
    func testGivenAttemptingToFetchAFootprint_WhenReceivingBadResponse_CompletionShouldPostFailure() {
        let mockSession = MockCarMakeSession(mockResponse: MockResponse(response: FootprintFakeResponseData.responseKO, data: FootprintFakeResponseData.footprintIncorrectData))
        let footprintSession = CarbonFootprintSessionAF(session: mockSession)
        let expectation = XCTestExpectation(description: "Wait for Queue Change")
        let encodedData = EncodableDataRequest(type: "a", distance_unit: "b", distance_value: 1.2, vehicle_model_id: "c")
        footprintSession.fetchCarbonFootprint(withData: encodedData) { result in
            guard case .failure(let error) = result else {
                XCTFail("Nothing failed in No Data test.")
                return
            }
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.9)
    }
    
}
