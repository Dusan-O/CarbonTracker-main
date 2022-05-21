//
//  DecodedCarbonFootprint.swift
//  CarbonTracker
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import Foundation

/// This struct is used to decode receive data.
struct CarbonFootprintObject: Decodable {
    let data: CarbonFootprintData
}

/// This struct is used to decode receive data.
struct CarbonFootprintData: Decodable {
    let id: String
    let type: String
    let attributes: FootprintAttributes
}

/// This struct is used to decode receive data.
struct FootprintAttributes: Decodable {
    let distance_value: Double
    let vehicle_make: String
    let vehicle_model: String
    let vehicle_year: Int
    let vehicle_model_id: String
    let distance_unit: String
    let estimated_at: String
    let carbon_g: Int
    let carbon_lb: Double
    let carbon_kg: Double
    let carbon_mt: Double
}
