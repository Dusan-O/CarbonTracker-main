//
//  LocationDatas.swift
//  CarbonTracker
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import Foundation

/// This class, conforming to singleton pattern,
/// is used to momentarily store user's adresses
/// while searching locations through CLLocation
/// framework.
class LocationDatas {
    
    static let sharedLocations = LocationDatas()
    
    private init() { }
    
    var startingPlacemark: Location?
    var destinationPlacemark: Location?
    
}
