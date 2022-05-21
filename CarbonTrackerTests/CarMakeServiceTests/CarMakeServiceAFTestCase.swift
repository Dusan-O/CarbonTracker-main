//
//  CarMakeServiceAFTestCase.swift
//  CarbonTrackerTests
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import XCTest
import Alamofire
@testable import CarbonTracker

class CarMakeServiceAFTestCase: XCTestCase {

    func testGivenAttemptingToFetchCarMakes_WhenReceivingCorrectDataWithNoErrorAndCorrectResponse_CompletionShouldPostSuccess() {
        let mockSession = MockCarMakeSession(mockResponse: MockResponse(response: CarMakesFakeResponseData.responseOK, data: CarMakesFakeResponseData.carMakeCorrectData))
        let carMakeSession = CarMakeServiceAF(session: mockSession)
        let expectation = XCTestExpectation(description: "Wait for Queue Change")
        carMakeSession.fetchCarMakes { result in
            guard case .success(let data) = result else {
                XCTFail("Test with correct data failed")
                return
            }
            XCTAssertEqual(data[0].data.id, "0cbbbe22-f5b9-46af-8ea6-941e0be4cf82")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.9)
    }
    
    func testGivenAttemptingToFetchCarMakes_WhenReceivingNoData_CompletionShouldPostFailure() {
        let mockSession = MockCarMakeSession(mockResponse: MockResponse(response: CarMakesFakeResponseData.responseOK, data: nil))
        let carModelsSession = CarMakeServiceAF(session: mockSession)
        let expectation = XCTestExpectation(description: "Wait for Queue Change")
        carModelsSession.fetchCarMakes() { result in
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
        let mockSession = MockCarMakeSession(mockResponse: MockResponse(response: CarMakesFakeResponseData.responseOK, data: CarMakesFakeResponseData.carMakeIncorrectData))
        let carMakesSession = CarMakeServiceAF(session: mockSession)
        let expectation = XCTestExpectation(description: "Wait for Queue Change")
        carMakesSession.fetchCarMakes() { result in
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
        let mockSession = MockCarMakeSession(mockResponse: MockResponse(response: CarMakesFakeResponseData.responseKO, data: CarModelsFakeResponseData.carModelIncorrectData))
        let carMakesSession = CarMakeServiceAF(session: mockSession)
        let expectation = XCTestExpectation(description: "Wait for Queue Change")
        carMakesSession.fetchCarMakes() { result in
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
