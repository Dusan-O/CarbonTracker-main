//
//  CarbonFootprintSession.swift
//  CarbonTracker
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import Foundation
import Alamofire

/// This class is used to perform network calls
/// through Alamofire. It implicitly conforms to
/// AlamofireSessionProtocol thanks inheriting
/// from CarbonSession class.
class CarbonFootprintAFSession: CarbonSession {
    
    /// This function performs requests through
    /// Alamofire.
    override func request(with url: String, data: EncodableDataRequest? = nil, completion: @escaping (AFDataResponse<Any>) -> Void) {
        let headers: HTTPHeaders = [
            .authorization(bearerToken: "\(ApiKeys.carbonInterfaceKey)"),
            .contentType("application/json")
        ]
        guard let encodedBody = data else {
            completion(AFDataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0.1, result: .failure(.explicitlyCancelled)))
            return
        }
        AF.request(url, method: .post, parameters: encodedBody, encoder: JSONParameterEncoder.default, headers: headers, interceptor: nil, requestModifier: nil).responseJSON { responseData in
            completion(responseData)
        }
    }
}
