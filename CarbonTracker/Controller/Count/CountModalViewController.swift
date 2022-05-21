//
//  CountModalViewController.swift
//  CarbonTracker
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import UIKit
import MKRingProgressView

// MARK: - Class declaration
class CountModalViewController: UIViewController {
    
    // MARK: - Properties
    
    var Co2CountReceivedFromSegue: Double!
    var ttlKmReceivedFromSegue: Double!
    var footprintCountManager = FootprintCountManager()
    var progressValue: Double!
    var co2Value: Double!
    
    // MARK: - @IBOutlets
    
    @IBOutlet weak var progressView: RingProgressView!
    @IBOutlet weak var carbonWeightLabel: UILabel!
    @IBOutlet weak var carbonUnitLabel: UILabel!
    
    // MARK: - Functions overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
        calculate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let progress = self.progressValue {
            UIView.animate(withDuration: 2.9) {
                self.progressView.progress = progress
            }
        }
    }
}

// MARK: - @ObjC Functions

extension CountModalViewController {
    
    /// This function updates  co2 value.
    /// - Parameter notification: a notification received.
    @objc private func updateCo2Count(notification: Notification)  {
        guard let userInfo = notification.userInfo else { return }
        var co2 = 0.0
        if let co2AsDouble = userInfo["updateDisplay"] as? Double {
            co2 = co2AsDouble
        }
        carbonWeightLabel.text = "\(co2)"
        co2Value = co2
    }
    
    /// This function updates appends ring chart
    /// data array.
    /// - Parameter notification: a notification received.
    @objc private func updateProgressValue(notification: Notification)  {
        guard let userInfo = notification.userInfo else { return }
        var progressValue = 0.0
        if let progressAsDouble = userInfo["updateDisplay"] as? Double {
            progressValue = progressAsDouble
        }
        self.progressValue = progressValue
    }
    
}

// MARK: - Functions

extension CountModalViewController {
    
    /// This function calls a model function
    /// to perform emissions calculations with
    /// sustanaible transportation.
    private func calculate() {
        guard let distance = ttlKmReceivedFromSegue, let co2 = Co2CountReceivedFromSegue else { return }
        footprintCountManager.calculateSustainableEmissions(fromDistance: distance, withCarEmissions: co2)
        guard let trainCo2 = co2Value else { return }
        footprintCountManager.getProgressViewPercentage(withCo2Value: trainCo2)
    }

    /// This function adds observers to view controller.
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateCo2Count(notification:)),
                                               name: Notification.Name("updateSustainableEmissions"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateProgressValue(notification:)),
                                               name: Notification.Name("updateProgressViewPercentage"), object: nil)
    }
}

