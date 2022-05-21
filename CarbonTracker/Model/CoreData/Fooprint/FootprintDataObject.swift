//
//  FootprintDataObject.swift
//  CarbonTracker
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import Foundation

/// This struct, quite similar to core data's
/// footprint object, is used to gather
/// all required data from labels and pass
/// it as an argument to the save function
/// of FootprintCdManager.
struct FootprintDataObject {
    let actualFootprint: Double
    let carMake: String
    let carModel: String
    let date: Date
    let startingAdressLat: Double
    let startingAdressLon: Double
    let destAdressLat: Double
    let destAdressLon: Double
    let startingAdress: String
    let destinationAdress: String
    let distance: Double
    let numberOfPax: Int16
    let numberOfSeats: Int16
    let occupancyScore: Int16
    let unoccupiedSeats: Int16
    let wastedCo2: Double
}
