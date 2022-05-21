//
//  FootprintFakeResponseData.swift
//  CarbonTrackerTests
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import Foundation

// MARK: - CLASS

class FootprintFakeResponseData {
    
    // MARK: - Corrupted Json Data
        static var footprintBadData: Data? {
            let bundle = Bundle(for: FootprintFakeResponseData.self)
            let url = bundle.url(forResource: "FootprintIncorrectData", withExtension: "json")!
            return try! Data(contentsOf: url)
        }
    
    // MARK: - Correct Json Data
        static var footprintCorrectData: Data? {
            let bundle = Bundle(for: FootprintFakeResponseData.self)
            let url = bundle.url(forResource: "FootprintCorrectData", withExtension: "json")!
            return try! Data(contentsOf: url)
        }
    
        static let footprintIncorrectData = "error".data(using: .utf8)!
    
    // MARK: - Response
        static let responseOK = HTTPURLResponse(
            url: URL(string: "https://blob.com")!,
            statusCode: 201, httpVersion: nil, headerFields: [:])!

        static let responseKO = HTTPURLResponse(
            url: URL(string: "https://blob.com")!,
            statusCode: 500, httpVersion: nil, headerFields: [:])!
}
