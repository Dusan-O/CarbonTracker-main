//
//  SampleFootprintDataObjects.swift
//  CarbonTrackerTests
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import Foundation
@testable import CarbonTracker

/// This class is used to staticly access
/// its constants for testing purposes.
final class SampleFootprintDataObjects {
    
    static let footprint1 = FootprintDataObject(actualFootprint: 3.745, carMake: "Ford", carModel: "Kuga (2020)", date: Date(), startingAdressLat: 2.757484, startingAdressLon: 47.9384884, destAdressLat: 3.8478484, destAdressLon: 44.9387373, startingAdress: "7 rue des sources Lyon", destinationAdress: "8 rue des sources Lyon", distance: 1.1, numberOfPax: 3, numberOfSeats: 6, occupancyScore: 50, unoccupiedSeats: 3, wastedCo2: 2.1)
    
    static let footprint2 = FootprintDataObject(actualFootprint: 6.839, carMake: "Hyundai", carModel: "Kona (2020)", date: Date(), startingAdressLat: 3.738848, startingAdressLon: 2.8483938, destAdressLat: 2.89048848, destAdressLon: 46.948774848, startingAdress: "1 rue des angles Nice", destinationAdress: "10 boulevard du rhone Nice", distance: 5.8, numberOfPax: 6, numberOfSeats: 6, occupancyScore: 100, unoccupiedSeats: 0, wastedCo2: 0)
    
    static let footprint3 = FootprintDataObject(actualFootprint: 66.873, carMake: "Opel", carModel: "Corsa", date: Date(), startingAdressLat: 5.938489, startingAdressLon: 47.837848, destAdressLat: 3.84849, destAdressLon: 44.984949, startingAdress: "4 rue des ponts Strasbourg", destinationAdress: "9 rue des villages, Colmar", distance: 68.9, numberOfPax: 4, numberOfSeats: 5, occupancyScore: 87, unoccupiedSeats: 1, wastedCo2: 12.8)
}

