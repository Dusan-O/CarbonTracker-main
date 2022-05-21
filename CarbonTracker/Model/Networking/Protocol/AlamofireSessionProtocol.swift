//
//  AlamofireSessionProtocol.swift
//  CarbonTracker
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import Foundation
import Alamofire

/// This protocol defines a single
/// method to call real Alamofire when
/// used in production, and a fake AF response when
/// used for testing purpose.
protocol AlamofireSession {
    func request(with url: String, data: EncodableDataRequest?, completion: @escaping (AFDataResponse<Any>) -> Void)
}
