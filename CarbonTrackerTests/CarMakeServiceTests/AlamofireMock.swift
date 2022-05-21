//
//  AlamofireMock.swift
//  CarbonTrackerTests
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import Foundation
import Alamofire
@testable import CarbonTracker


// - MARK: MOCK RESPONSE

/// This structures defines two properties
/// used in MockRecipeSession class below
/// to pass needed parameters as a response.
struct MockResponse {
    var response: HTTPURLResponse?
    var data: Data?
}

// - MARK: MOCK RECIPE SESSION

/// This class was created for testing purposes,
/// and conforms to AlamofireSession protocol,
/// allowing to fake a response when an instance
/// is initialized with given properties.
final class MockCarMakeSession: AlamofireSession {
    
    private let mockResponse: MockResponse
    init(mockResponse: MockResponse) {
        self.mockResponse = mockResponse
    }
    
    /// This function conforms class to AlamofireSession protocol.
    /// - Parameters:
    ///     - url: A string value.
    ///     - completion: a closure returning  an AFDataResponse type.
    func request(with url: String, data: EncodableDataRequest? = nil, completion: @escaping (AFDataResponse<Any>) -> Void) {
        let dataResponse = AFDataResponse<Any>(request: nil, response: mockResponse.response, data: mockResponse.data, metrics: nil, serializationDuration: 0, result: .success("OK"))
        completion(dataResponse)
    }

}
