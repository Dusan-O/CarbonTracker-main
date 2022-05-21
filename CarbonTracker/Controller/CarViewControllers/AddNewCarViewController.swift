//
//  AddNewCarViewController.swift
//  CarbonTracker
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import UIKit

// MARK: - CLASS
class AddNewCarViewController: UIViewController {

    // MARK: OUTLETS AND PROPERTIES
    var carMakesToPrepareForSegway: [CarMakesData]!
    var coreDataManager = CarModelObjectManager.sharedCarModelObjectManager
    var carsToDisplay: [CarModels] = []
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var carTableView: UITableView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var circleView: CircleView!
    
}

// MARK: - FUNCTIONS OVERRIDES

extension AddNewCarViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        circleView.addShadow()
        carTableView.delegate = self
        carTableView.dataSource = self
        toggleActivityIndicator(shown: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrieveSavedCars()
        updateView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToVehicleMake" {
            let destinationVC = segue.destination as! SelectMakeViewController
            destinationVC.carMakes = carMakesToPrepareForSegway
        }
    }
}

// MARK: - @IBACTIONS

extension AddNewCarViewController {
    
    /// This function is called after button is taped.
    @IBAction func addNewCarButtonTapped(_ sender: Any) {
        fetchCarMakes()
    }
    
    /// This function is called after button is taped.
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        useOrDeleteCar(sender: sender)
    }
    
    /// This function is called after button is taped.
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        useOrDeleteCar(sender: sender)
    }
    
    
}

// MARK: - FUNCTIONS

extension AddNewCarViewController {
    
    /// This function fetches car makes
    /// calling fetch function from CarMakeServiceAF class.
    private func fetchCarMakes() {
        toggleActivityIndicator(shown: true)
        CarMakeServiceAF.shared.fetchCarMakes { result in
            self.toggleActivityIndicator(shown: false)
            guard case .success(let datas) = result else {
                self.presentAlert(with: "Unable to fetch car makes.")
                return
            }
            self.carMakesToPrepareForSegway = datas
            self.performSegue(withIdentifier: "segueToVehicleMake", sender: nil)
        }
    }
    
    /// This function displays an alert to user.
    /// - Parameter message : A string value, which
    /// is the message displayed in case of an Alert.
    private func presentAlert(with message: String) {
        let alertViewController = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertViewController, animated: true, completion: nil)
    }
    
    /// This function toggles activity indicator.
    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
    }
    
    /// This function retrieves saved cars from CoreData.
    private func retrieveSavedCars() {
        carsToDisplay.removeAll()
        for car in coreDataManager.all {
            if let make = car.vehicle_make, let model = car.name, let id = car.id {
                let carToAppend = CarModels(id: id, attributes: CarAttributes(name: model, year: Int(car.year), vehicle_make: make))
                carsToDisplay.append(carToAppend)
            }
        }
    }
    
    /// This function checks if CoreData contains entities,
    /// and hides or reveals table view/message.
    private func updateView() {
        carTableView.reloadData()
        let hasCars = carsToDisplay.count > 0
        carTableView.isHidden = !hasCars
        messageLabel.isHidden = hasCars
        circleView.isHidden = hasCars
    }
    
    /// This function switches on sender's tag
    /// and then calls another function depending
    /// on given tag.
    private func useOrDeleteCar(sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: carTableView)
        guard let indexPath = carTableView.indexPathForRow(at: point) else { return }
        let carToUpdate = carsToDisplay[indexPath.row]
        let carToUse = CarModelDatas(data: CarModels(id: carToUpdate.id, attributes: carToUpdate.attributes))
        switch sender.tag {
        case 1 :
            useSelectedCar(sender: sender, with: carToUse, with: indexPath)
        case 2 :
            deleteCar(sender: sender, with: carToUse, with: indexPath)
        default :
            break
        }
    }
    
    /// This function switch selected car to favorite,
    /// using core data specified function.
    private func useSelectedCar(sender: UIButton, with carToUse: CarModelDatas, with indexPath: IndexPath) {
        let formerFavouriteCar = coreDataManager.fetchFavouriteCar()
        var formerFavCarArrayIndex: Int?
        if formerFavouriteCar != nil {
            formerFavCarArrayIndex = carsToDisplay.firstIndex { $0.id == formerFavouriteCar?.id
            }
        }
        carTableView.beginUpdates()
        coreDataManager.updateFavouriteCar(with: carToUse) { success in
            print("done")
        }
        updateRows(with: indexPath, previousFavCarIP: formerFavCarArrayIndex)
        carTableView.endUpdates()
    }
    
    /// This function updates table view rows.
    private func updateRows(with newlySavedCarIP: IndexPath, previousFavCarIP: Int? ) {
        carTableView.reloadRows(at: [newlySavedCarIP], with: .middle)
        guard let row = previousFavCarIP else { return }
        let formerIndexPath = IndexPath(row: row, section: newlySavedCarIP.section)
        carTableView.reloadRows(at: [formerIndexPath], with: .none)
    }
    
    /// This function deletes specified car from
    /// core data, by calling specific model's
    /// function.
    private func deleteCar(sender: UIButton, with carToDelete: CarModelDatas, with indexPath: IndexPath) {
        coreDataManager.deleteCarModel(with: carToDelete) { success in
            self.carsToDisplay.remove(at: indexPath.row)
            self.carTableView.beginUpdates()
            self.carTableView.deleteRows(at: [IndexPath(row: indexPath.row, section: indexPath.section)], with: .left)
            self.carTableView.endUpdates()
        }
    }
}

// MARK: - Table view data source protocol conformance

extension AddNewCarViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carsToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "carCell") as? CarTableViewCell else {
            return UITableViewCell()
        }
        let car = carsToDisplay[indexPath.row]
        cell.carModel = car
        cell.updateDisplay(with: car)
        return cell
    }
    
}

// MARK: - Table view delegate protocol conformance

extension AddNewCarViewController: UITableViewDelegate {
}
