//
//  CustomAnnotation.swift
//  CarbonTracker
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import Foundation
import MapKit

/// This class defines a custom
/// annotation, which conforms
/// to MKAnnotation protocol.
class CustomAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var isDeparture: Bool
    
    init(title: String, coordinate: CLLocationCoordinate2D, isDeparture: Bool) {
        self.title = title
        self .subtitle = nil
        self.coordinate = coordinate
        self.isDeparture = isDeparture
    }
    
    
}
