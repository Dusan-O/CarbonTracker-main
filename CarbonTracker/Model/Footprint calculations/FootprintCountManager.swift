//
//  FootprintCountManager.swift
//  CarbonTracker
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import Foundation

// MARK: - Class Declaration

/// This class is used to perform miscellaneous
/// calculations related to co2 count.
/// - Note that getters at top level
/// are used for testing purposes.
final class FootprintCountManager {
    
    // MARK: -  Getters
    
    var co2Count: Double { get { _co2Count } }
    var wastedCo2Count: Double { get { _wastedCo2Count } }
    var occupancyAverage: Int { get { _occupancyAverage } }
    var totalDistance: Double { get { _totalDistance } }
    var sustainableEmissions: Double { get { _sustainableEmissions } }
    var progressViewPercentage: Double { get { _progressViewPercentage } }
    
    // MARK: - Private properties
    
    private var _co2Count = 0.0 {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("updateCo2Count"),
                                            object: nil, userInfo: ["updateDisplay": _co2Count])
        }
    }
    
    private var _wastedCo2Count = 0.0 {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("updateWastedCo2Count"),
                                            object: nil, userInfo: ["updateDisplay": _wastedCo2Count])
        }
    }
    
    private var _occupancyAverage = 0 {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("updateOccupancyAverage"),
                                            object: nil, userInfo: ["updateDisplay": _occupancyAverage])
        }
    }
    
    private var _totalDistance = 0.0 {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("updateTotalDistance"),
                                            object: nil, userInfo: ["updateDisplay": _totalDistance])
        }
    }
    
    private var _sustainableEmissions = 0.0 {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("updateSustainableEmissions"),
                                            object: nil, userInfo: ["updateDisplay": _sustainableEmissions])
        }
    }
    
    private var _progressViewPercentage = 0.0 {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("updateProgressViewPercentage"),
                                            object: nil, userInfo: ["updateDisplay": _progressViewPercentage])
        }
    }

}

extension FootprintCountManager {
    
    // MARK: - Functions
    
    /// This function calculates total
    /// amount of emitted co2.
    /// - Parameter array: an array of
    /// FootprintCdObject whose actual footprint
    /// value is used to perform calculation.
    func calculateFootprintsCo2Count(from array: [FootprintCdObject]) {
        var count = 0.0
        for footprint in array {
            count += footprint.actualFootprint
        }
        let formatedCount = formatNumber(withNumber: count)
        _co2Count = formatedCount
    }
    
    /// This function calculates total
    /// amount of wasted co2.
    /// - Parameter array: an array of
    /// FootprintCdObject whose wasted co2
    /// value is used to perform calculation.
    func calculateFootprintsWastedCo2Count(from array: [FootprintCdObject]) {
        var count = 0.0
        for footprint in array {
            count += footprint.wastedCo2
        }
        let formatedCount = formatNumber(withNumber: count)
        _wastedCo2Count = formatedCount
    }
    
    /// This function calculates average car
    /// occupancy.
    /// - Parameter array: an array of
    /// FootprintCdObject whose occupancyScore
    /// value is used to perform calculation.
    func calculateAverageCarOccupancy(from array: [FootprintCdObject]) {
        var total = 0
        array.forEach { footprint in
            total += Int(footprint.occupancyScore)
        }
        let average = total / array.count
        _occupancyAverage = average
    }
    
    /// This function calculates all time traveled distance.
    /// - Parameter array: an array of
    /// FootprintCdObject whose distance
    /// value is used to perform calculation.
    func calculateTotalDistanceTraveled(from array: [FootprintCdObject]) {
        var total = 0.0
        array.forEach { footprint in
            total += footprint.distance
        }
        let formatedCount = formatNumber(withNumber: total)
        _totalDistance = formatedCount
    }
    
    /// This function calculates potential emissions by train
    /// based on datas provided by Ademe.
    /// - Parameter distance: a double value
    /// used to get train emissions when multiplied by 7.725,
    /// which is an average emission rate in grams / km.
    /// - Parameter emissions: an already calculated
    /// total emissions co2 weight for car travels.
    func calculateSustainableEmissions(fromDistance distance: Double, withCarEmissions emissions: Double) {
        let totalSustainableEmissions = distance * 7.725
        let sustainableEmissionsInKg = totalSustainableEmissions / 1000
        let potentialSavingsByTrain = emissions - sustainableEmissionsInKg
        let formatedNumber = formatNumber(withNumber: potentialSavingsByTrain)
        _sustainableEmissions = formatedNumber
    }
    
    /// This function converts potential sustainable emitted co2 into
    /// a new value understandable by progress view.
    /// The threshold for calculting this value is set to 1000kg
    /// emited = 100% progress.
    /// - Parameter value: a double value which is
    /// the co2 value potentiallly emited with train travels.
    func getProgressViewPercentage(withCo2Value value: Double) {
        let percentageValue = value * 100.0 / 1000.0
        let valueConvertedForProgressDisplay = percentageValue / 100.0
        let formatedNumber = formatNumber(withNumber: valueConvertedForProgressDisplay)
        _progressViewPercentage = formatedNumber
    }
    
    /// This function formats given number
    /// to a 1 fraction digits double.
    private func formatNumber(withNumber number: Double) -> Double {
        let formater = NumberFormatter()
        formater.numberStyle = .decimal
        formater.usesGroupingSeparator = false
        formater.maximumFractionDigits = 1
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
