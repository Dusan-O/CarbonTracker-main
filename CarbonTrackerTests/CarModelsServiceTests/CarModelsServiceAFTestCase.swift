//
//  CarModelsServiceAFTestCase.swift
//  CarbonTrackerTests
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import XCTest
@testable import CarbonTracker

class CarModelsServiceAFTestCase: XCTestCase {

    func testGivenAttemptingToFetchCarModels_WhenReceivingCorrectDataWithNoErrorAndCorrectResponse_CompletionShouldPostSuccess() {
        let mockSession = MockCarMakeSession(mockResponse: MockResponse(response: CarModelsFakeResponseData.responseOK, data: CarModelsFakeResponseData.carModelCorrectData))
        let carModelsSession = CarModelServiceAF(session: mockSession)
        let expectation = XCTestExpectation(description: "Wait for Queue Change")
        carModelsSession.fetchCarModels(with: "doesntMatter") { result in
            guard case .success(let data) = result else {
                XCTFail("Test with correct data failed")
                return
            }
            XCTAssertEqual(data[0].data.attributes.name, "3.2 Mondial/Cabriolet")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.9)
    }
    
    func testGivenAttemptingToFetchCarModels_WhenReceivingNoData_CompletionShouldPostFailure() {
        let mockSession = MockCarMakeSession(mockResponse: MockResponse(response: CarModelsFakeResponseData.responseOK, data: nil))
        let carModelsSession = CarModelServiceAF(session: mockSession)
        let expectation = XCTestExpectation(description: "Wait for Queue Change")
        carModelsSession.fetchCarModels(with: "doesntmatter") { result in
            guard case .failure(let error) = result else {
                XCTFail("Nothing failed in No Data test.")
                return
            }
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.9)
    }
    
    
    func testGivenAttemptingToFetchCarModels_WhenReceivingIncorectData_CompletionShouldPostFailure() {
        let mockSession = MockCarMakeSession(mockResponse: MockResponse(response: CarModelsFakeResponseData.responseOK, data: CarModelsFakeResponseData.carModelIncorrectData))
        let carModelsSession = CarModelServiceAF(session: mockSession)
        let expectation = XCTestExpectation(description: "Wait for Queue Change")
        carModelsSession.fetchCarModels(with: "doesntmatter") { result in
            guard case .failure(let error) = result else {
                XCTFail("Nothing failed in No Data test.")
                return
            }
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.9)
    }
    
    func testGivenAttemptingToFetchCarModels_WhenReceivingBadResponse_CompletionShouldPostFailure() {
        let mockSession = MockCarMakeSession(mockResponse: MockResponse(response: CarModelsFakeResponseData.responseKO, data: CarModelsFakeResponseData.carModelIncorrectData))
        let carModelsSession = CarModelServiceAF(session: mockSession)
        let expectation = XCTestExpectation(description: "Wait for Queue Change")
        carModelsSession.fetchCarModels(with: "doesntmatter") { result in
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
