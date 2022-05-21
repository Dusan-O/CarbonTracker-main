//
//  FootprintCalculationsManager.swift
//  CarbonTracker
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import Foundation

/// This class is used to perform miscellaneous
/// calculations related to footprints.
/// - Note that getters at top level
/// are used for testing purposes.
final class FootprintCalculationsHelper {

    
    // MARK: - Properties' getters
    // Note that these properties are used for
    // testing purposes.
    
    var occupancyScore: Int { get {_occupancyScore} }
    var unoccupiedSeats: Int { get {_unoccupiedSeats} }
    var wastedCo2: Double { get {_wastedCo2} }
    var paxNmbrLessOrEqualSeats: Bool { get {_paxNmbrLessOrEqualSeats} }

    // MARK: - Properties
    
    private var _occupancyScore: Int = 0 {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("updateOccupancyScore"),
                                            object: nil, userInfo: ["updateDisplay": _occupancyScore])
        }
    }
    
    private var _unoccupiedSeats: Int = 0 {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("updateOccupiedSeats"),
                                            object: nil, userInfo: ["updateDisplay": _unoccupiedSeats])
        }
    }
    
    private var _wastedCo2: Double = 0 {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("updateWastedCo2"),
                                            object: nil, userInfo: ["updateDisplay": _wastedCo2])
        }
    }
    
    private var _paxNmbrLessOrEqualSeats: Bool = false
    
}

extension FootprintCalculationsHelper {
    
    // MARK: - Functions
    
    /// This function calculates occupancy score.
    /// - Parameter withPaxNumber : a string value
    /// coming from a label.text property.
    /// - Parameter withSeatsNumber : a string value
    /// coming from a label.text property.
    func calculateOccupancyScore(withPaxNumber passengers: String?, withSeatsNumber seats: String?) {
        guard let unwrappedPassengers = passengers, let convertedPaxNumber = Int(unwrappedPassengers) else { return }
        guard let unwrappedSeats = seats, let convertedSeatsNmbr = Int(unwrappedSeats) else { return }
        let calculationResult: Int = (convertedPaxNumber * 100) / convertedSeatsNmbr
        _occupancyScore = calculationResult
    }
    
    /// This function calculates unoccupied seats number.
    /// - Parameter withPaxNumber : a string value
    /// coming from a label.text property.
    /// - Parameter withSeatsNumber : a string value
    /// coming from a label.text property.
    func calculateMissingPassengers(withPaxNumber passengers: String?, withSeatsNumber seats: String?) {
        guard _occupancyScore != 100 else {
            _unoccupiedSeats = 0
            return
        }
        guard let unwrappedPassengers = passengers, let convertedPaxNumber = Int(unwrappedPassengers) else { return }
        guard let unwrappedSeats = seats, let convertedSeatsNmbr = Int(unwrappedSeats) else { return }
        let unoccupiedSeatNmbr = convertedSeatsNmbr - convertedPaxNumber
        _unoccupiedSeats = unoccupiedSeatNmbr
    }
    
    /// This function calculates wasted CO2.
    /// - Parameter withCo2Value : a double value
    /// coming from carbon_kg property in FootprintAttributes struct.
    /// - Parameter withSeatsNumber : a string value
    /// coming from a label.text property.
    func calculateWastedCO2(withCo2Value value: Double, withSeatsNumber seats: String?) {
        guard _occupancyScore != 100 else {
            _wastedCo2 = 0
            return
        }
        guard let unwrappedSeats = seats, let convertedSeatsNmbr = Int(unwrappedSeats) else { return }
        let co2FootprintPerSeat = value / Double(convertedSeatsNmbr)
        let fcntwastedCo2 = co2FootprintPerSeat * Double(_unoccupiedSeats)
        let formatedNumber = formatNumber(withNumber: fcntwastedCo2)
        self._wastedCo2 = formatedNumber
    }
    
    /// This function calculates if there are more passengers than available seats in car.
    /// - Parameter withPaxNumber : a string value
    /// coming from a label.text property.
    /// - Parameter withSeatsNumber : a string value
    /// coming from a label.text property.
    func verifySeatsEqualOrHigherThanPaxNmbr(withPaxNmbr passengers: String?, withSeatNmbr seats: String?) {
        guard let unwrappedPassengers = passengers, let convertedPaxNumber = Int(unwrappedPassengers) else { return }
        guard let unwrappedSeats = seats, let convertedSeatsNmbr = Int(unwrappedSeats) else { return }
        if convertedPaxNumber > convertedSeatsNmbr {
            _paxNmbrLessOrEqualSeats = false
        } else {
            _paxNmbrLessOrEqualSeats = true
        }
    }
    
    /// This function formats given number
    /// to a 2 fraction digits double.
    private func formatNumber(withNumber number: Double) -> Double {
        let formater = NumberFormatter()
        formater.numberStyle = .decimal
        formater.usesGroupingSeparator = false
        formater.maximumFractionDigits = 2
        formater.decimalSeparator = "."
        let doubleAsString =  formater.string(from: NSNumber(value: number))!
        let stringAsDouble = Double(doubleAsString)
        var double = 1.0
        if let unwrappedDouble = stringAsDouble {
            double = unwrappedDouble
        }
        return double
    }

}
