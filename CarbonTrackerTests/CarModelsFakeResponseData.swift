//
//  CarModelsFakeResponseData.swift
//  CarbonTrackerTests
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import Foundation

// MARK: - CLASS

class CarModelsFakeResponseData {
    
    // MARK: - Corrupted Json Data
        static var carModelBadData: Data? {
            let bundle = Bundle(for: CarModelsFakeResponseData.self)
            let url = bundle.url(forResource: "CarModelsIncorrectData", withExtension: "json")!
            return try! Data(contentsOf: url)
        }
    
    // MARK: - Correct Json Data
        static var carModelCorrectData: Data? {
            let bundle = Bundle(for: CarModelsFakeResponseData.self)
            let url = bundle.url(forResource: "CarModelsCorrectData", withExtension: "json")!
            return try! Data(contentsOf: url)
        }
    
        static let carModelIncorrectData = "error".data(using: .utf8)!
    
    // MARK: - Response
        static let responseOK = HTTPURLResponse(
            url: URL(string: "https://blob.com")!,
            statusCode: 200, httpVersion: nil, headerFields: [:])!

        static let responseKO = HTTPURLResponse(
            url: URL(string: "https://blob.com")!,
            statusCode: 500, httpVersion: nil, headerFields: [:])!
}
