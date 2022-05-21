//
//  GeoCoderHelper.swift
//  CarbonTracker
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import Foundation
import CoreLocation

/// This class, conforming to singleton
/// pattern, is used to retrieve geographic
/// coordinates using CLGeocoder.
final class GeoCoderService {
    
    static let sharedGeoCoderHelper = GeoCoderService()
    
    private init() {}
    
    /// This function get coordinates from a given
    /// string location entered by user in textfields.
    ///  - Parameter string: a string value, eg an adress.
    ///  - Parameter completion: a closure
    ///  returning a result type, including a placemark struct if success.
    func getCoordinatesFrom(_ string: String, completion: @escaping (Result<Placemark, NetworkErrors>) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(string) { placemarks, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    completion(.failure(.unableToFindLocation))
                    return
                }
                if let placemark = placemarks?.first {
                    let name = placemark.locality ?? "Unknown"
                    let lat = placemark.location?.coordinate.latitude ?? 0.0
                    let lon = placemark.location?.coordinate.longitude ?? 0.0
                    let city = Placemark(name: name, lat: lat, lon: lon)
                    completion(.success(city))
                } else {
                    completion(.failure(.unableToFindLocation))
                }
            }
        }
    }
}
