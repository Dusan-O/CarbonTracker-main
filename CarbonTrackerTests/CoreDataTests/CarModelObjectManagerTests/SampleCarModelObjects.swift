//
//  SampleCarModelObjects.swift
//  CarbonTrackerTests
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import Foundation
@testable import CarbonTracker

/// This class is used to staticly access
/// its constants for testing purposes.
final class SampleCarModelObjects {
    
    static let f50 = CarModelDatas(data: CarModels(id: "585fd31a-2b1d-4a04-964a-1e7480b8bb54", attributes: CarAttributes(name: "Ferrari F50", year: 1995, vehicle_make: "Ferrari")))
    
    static let maranello = CarModelDatas(data: CarModels(id: "600a5a35-960b-4e32-ac08-69e6a9b7f9ad", attributes: CarAttributes(name: "Ferrari 550 Maranello", year: 1998, vehicle_make: "Ferrari")))
    
    static let modena = CarModelDatas(data: CarModels(id: "258ff4c4-8b90-442f-9895-bb1314330f22", attributes: CarAttributes(name: "360 Modena/Spider", year: 2003, vehicle_make: "Ferrari")))
}
