//
//  EncodableCarbonData.swift
//  CarbonTracker
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import Foundation

/// This struct is used to encode data.
struct EncodableDataRequest: Encodable {
    let type: String
    let distance_unit: String
    let distance_value: Double
    let vehicle_model_id: String
}
