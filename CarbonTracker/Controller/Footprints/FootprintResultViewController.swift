//
//  FootprintResultViewController.swift
//  CarbonTracker
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import UIKit

// MARK: - Class
class FootprintResultViewController: UIViewController {
    
    // MARK: - Properties
    var footprintHelper = FootprintCalculationsHelper()
    var car: CarModels!
    var footprint: CarbonFootprintObject!
    var coreDataManager = FootprintCdManager.sharedFootprintCdManager
    var passengersNumber: String!
    var seatsNumber: String!
    var occupancyScore: Int!
    var unoccupiedSeats: Int!
    var wastedCo2: Double!
    
    // MARK: - Outlets
    @IBOutlet weak var carMakeLabel: UILabel!
    @IBOutlet weak var carModelLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var occupancyScoreLabel: UILabel!
    @IBOutlet weak var saveableLabel: UILabel!
    @IBOutlet weak var passengersLabel: UILabel!
    @IBOutlet weak var footprintLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var carView: UIView!
    @IBOutlet weak var carbonWeightView: UIView!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var saveButton: UIButton!
    
}

// MARK: - Functions overrides
extension FootprintResultViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moveCloudView()
        makeRoundCornersToCarView()
        buttonsStackView.isHidden = true
        updateLabels()
        addObservers()
        performCalculations()
        buttonsStackView.isHidden = false
        activityIndicator.isHidden = true
        animateCloudView()
    }
}

// MARK: - @IBActions
extension FootprintResultViewController {
    
    /// This function is called after sender was tapped.
    @IBAction func saveButtonTapped(_ sender: Any) {
        saveFootprint()
    }
    
    /// This function is called after sender was tapped.
    @IBAction func exitButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToFootprintsVC", sender: nil)
    }
}

// MARK: - @objC Functions

extension FootprintResultViewController {
    
    /// This function updates occupancy score
    /// label whenever a notification is received.
    /// - Parameter notification: a notification received.
    @objc private func updateOccupancyScore(notification: Notification)  {
        guard let userInfo = notification.userInfo else { return }
        let scoreAsInt = userInfo["updateDisplay"] as? Int
        occupancyScore = scoreAsInt
        if let score = scoreAsInt {
            let scoreAsString = "\(score)%"
            occupancyScoreLabel.text = scoreAsString
        }
    }
    
    /// This function updates passengers label
    /// label whenever a notification is received.
    /// - Parameter notification: a notification received.
    @objc private func updateOccupiedSeats(notification: Notification)  {
        guard let userInfo = notification.userInfo else { return }
        let occupiedSeatsAsInt = userInfo["updateDisplay"] as? Int
        unoccupiedSeats = occupiedSeatsAsInt
        if let seats = occupiedSeatsAsInt {
            if seats > 0 {
                let seatsAsString = "not having \(seats) more passengers."
                passengersLabel.text = seatsAsString
            } else {
                passengersLabel.text = "having your car full."
            }
        }
    }
    
    /// This function updates saveable Label
    /// label whenever a notification is received.
    /// - Parameter notification: a notification received.
    @objc private func updateWastedCo2(notification: Notification)  {
        guard let userInfo = notification.userInfo else { return }
        let wastedCo2AsDouble = userInfo["updateDisplay"] as? Double
        wastedCo2 = wastedCo2AsDouble
        if let wastedCo2 = wastedCo2AsDouble {
            let wastedCo2AsString = "\(wastedCo2) kg"
            saveableLabel.text = wastedCo2AsString
        }
    }
}

// MARK: - Functions
extension FootprintResultViewController {
    
    /// This function saves currently displayed footprint,
    /// by calling model's specified function.
    private func saveFootprint() {
        toggleActivityIndicator(shown: true)
        guard let footprintToSave = getFootprintDatas() else {
            toggleActivityIndicator(shown: false)
            presentAlert(with: "Unable to save your footprint.")
            return
        }
        coreDataManager.saveFootprint(with: footprintToSave) { success in
            toggleActivityIndicator(shown: false)
            performSegue(withIdentifier: "unwindSegueToFootprintsVC", sender: nil)
        }
    }
    
    /// This function adds notif. observers
    /// to view controller.
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateOccupancyScore(notification:)),
                                               name: Notification.Name("updateOccupancyScore"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateOccupiedSeats(notification:)),
                                               name: Notification.Name("updateOccupiedSeats"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateWastedCo2(notification:)),
                                               name: Notification.Name("updateWastedCo2"), object: nil)
    }
    
    /// This function updates labels
    private func updateLabels() {
        guard let car = car, let footprint = footprint else {
            return
        }
        carMakeLabel.text = car.attributes.vehicle_make
        carModelLabel.text = "\(car.attributes.name) (\(car.attributes.year))"
//        distanceLabel.text = String(footprint.data.attributes.distance_value)
        distanceLabel.text = "\(footprint.data.attributes.distance_value) km"
        footprintLabel.text = "\(footprint.data.attributes.carbon_kg) kg"
    }
    
    /// This function performs calculations, calling
    /// model's appropriate functions.
    private func performCalculations() {
        footprintHelper.calculateOccupancyScore(withPaxNumber: passengersNumber, withSeatsNumber: seatsNumber)
        footprintHelper.calculateMissingPassengers(withPaxNumber: passengersNumber, withSeatsNumber: seatsNumber)
        footprintHelper.calculateWastedCO2(withCo2Value: footprint.data.attributes.carbon_kg, withSeatsNumber: seatsNumber)
    }
    
    /// This function makes rounds corners
    /// to bottom left and right.
    private func makeRoundCornersToCarView() {
        carView.layer.cornerRadius = 10
    }
    
    /// This function moves cloud view
    /// on view controller's display.
    private func moveCloudView() {
        let translation = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
        let scale = CGAffineTransform(scaleX: 0.1, y: 0.1)
        let transformAndScale = scale.concatenating(translation)
        carbonWeightView.transform = transformAndScale
    }
    
    /// This function animates cloud view with
    /// a returning boing effect.
    private func animateCloudView() {
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.1, options: [], animations: {
            self.carbonWeightView.transform = .identity
        }, completion: nil)
    }
    
    /// This function gathers all needed data in labels and other
    /// properties, and returns a FootprintDataObject.
    private func getFootprintDatas() -> FootprintDataObject? {
        var fooprintToSave: FootprintDataObject?
        let date = datePicker.date
        if let startingLocation = LocationDatas.sharedLocations.startingPlacemark,
           let destinationLocation = LocationDatas.sharedLocations.destinationPlacemark,
           let paxNumber = Int16(passengersNumber),
           let seatsNumber = Int16(seatsNumber) {
            fooprintToSave = FootprintDataObject(actualFootprint: footprint.data.attributes.carbon_kg,
                                                      carMake: car.attributes.vehicle_make,
                                                      carModel: "\(car.attributes.name) (\(car.attributes.year))",
                                                      date: date,
                                                      startingAdressLat: startingLocation.placemark.lat,
                                                      startingAdressLon: startingLocation.placemark.lon,
                                                      destAdressLat: destinationLocation.placemark.lat,
                                                      destAdressLon: destinationLocation.placemark.lon,
                                                 startingAdress: startingLocation.placemark.name,
                                                 destinationAdress: destinationLocation.placemark.name,
                                                      distance: footprint.data.attributes.distance_value,
                                                      numberOfPax: paxNumber,
                                                      numberOfSeats: seatsNumber,
                                                      occupancyScore: Int16(occupancyScore),
                                                      unoccupiedSeats: Int16(unoccupiedSeats),
                                                      wastedCo2: wastedCo2)
        }
        return fooprintToSave
    }
    
    /// This function displays an alert to user.
    /// - Parameter message : A string value, which
    /// is the message displayed in case of an Alert.
    private func presentAlert(with message: String) {
        let alertViewController = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertViewController, animated: true, completion: nil)
    }
    
    /// This function toggles specified elements in
    /// function's body.
    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
        saveButton.isHidden = shown
    }
   
}
