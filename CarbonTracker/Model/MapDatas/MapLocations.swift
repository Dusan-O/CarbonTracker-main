//
//  MapLocations.swift
//  CarbonTracker
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import Foundation

/// This struct is used to create
/// placemarks used in location related
/// functions.
struct Placemark {
    var name: String
    var lat: Double
    var lon: Double
}

/// This struct is used to create
/// placemarks used in location related
/// functions.
struct Location {
    let streetNumber: String
    let streetType: String
    let streetName: String
    let cityName: String
    let postCode: String
    let country: String
    let placemark: Placemark
    
}
