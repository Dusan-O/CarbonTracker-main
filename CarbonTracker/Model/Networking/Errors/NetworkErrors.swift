//
//  NetworkErrors.swift
//  CarbonTracker
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import Foundation
import Alamofire

/// This enumeration defines cases
/// used in network related functions.
enum NetworkErrors: Error {
    case noData
    case unableToSetUrl
    case badResponse
    case unableToDecodeResponse
    case alamofireError(AFError)
    case unableToFindLocation
}
