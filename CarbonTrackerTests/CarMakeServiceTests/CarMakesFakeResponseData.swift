//
//  FakeResponseData.swift
//  CarbonTrackerTests
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import Foundation

// MARK: - CLASS

class CarMakesFakeResponseData {
    
    // MARK: - Corrupted Json Data
        static var carMakeBadData: Data? {
            let bundle = Bundle(for: CarMakesFakeResponseData.self)
            let url = bundle.url(forResource: "CarMakeServiceBadJsonData", withExtension: "json")!
            return try! Data(contentsOf: url)
        }
    
    // MARK: - Correct Json Data
        static var carMakeCorrectData: Data? {
            let bundle = Bundle(for: CarMakesFakeResponseData.self)
            let url = bundle.url(forResource: "CarMakeServiceCorrectJsonData", withExtension: "json")!
            return try! Data(contentsOf: url)
        }
    
        static let carMakeIncorrectData = "error".data(using: .utf8)!
    
    // MARK: - Response
        static let responseOK = HTTPURLResponse(
            url: URL(string: "https://blob.com")!,
            statusCode: 200, httpVersion: nil, headerFields: [:])!

        static let responseKO = HTTPURLResponse(
            url: URL(string: "https://blob.com")!,
            statusCode: 500, httpVersion: nil, headerFields: [:])!
    
    // MARK: - Error
        class CarbonError: Error {}
        static let carbonError = CarbonError()
}
