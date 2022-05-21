//
//  SelectMakeViewController.swift
//  CarbonTracker
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import UIKit

// MARK: - Class Declaration

class SelectMakeViewController: UIViewController {
    
    // MARK: - OUTLETS AND PROPERTIES
    
    @IBOutlet weak var carMakesPickerView: UIPickerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var carMakes: [CarMakesData]!
    var carModelsToPrepareForSegue: [CarModelDatas]!
    
}

// MARK: - FUNCTIONS OVERRIDES

extension SelectMakeViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carMakesPickerView.delegate = self
        carMakesPickerView.dataSource = self
        toggleActivityIndicator(shown: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToSelectModelVC" {
            let destinationVC = segue.destination as! SelectModelViewController
            destinationVC.carModels = carModelsToPrepareForSegue
        }
    }
}

// MARK: - @IBACTIONS

extension SelectMakeViewController {
    
    /// This function is called after given button
    /// was tapped.
    @IBAction func searchModelButtonTapped(_ sender: Any) {
        searchModelBtnTapped()
    }
}

// MARK: - FUNCTIONS

extension SelectMakeViewController {
    
    /// This function calls specified model's function
    /// to fetch models of a car make.
    private func searchModelBtnTapped() {
        toggleActivityIndicator(shown: true)
        let selectedCarMakeId = carMakes[carMakesPickerView.selectedRow(inComponent: 0)].data.id
        CarModelServiceAF.shared.fetchCarModels(with: selectedCarMakeId) { result in
            self.toggleActivityIndicator(shown: false)
            guard case .success(let datas) = result else {
                self.presentAlert(with: "Unable to fetch car makes.")
                return
            }
            self.carModelsToPrepareForSegue = datas
            self.performSegue(withIdentifier: "segueToSelectModelVC", sender: nil)
            
        }
    }
    
    /// This function toggles activity indicator.
    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
    }
    
    /// This function displays an alert to user.
    /// - Parameter message : A string value, which
    /// is the message displayed in case of an Alert.
    private func presentAlert(with message: String) {
        let alertViewController = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertViewController, animated: true, completion: nil)
    }
}

// MARK: Picker view data source protocol conformance

extension SelectMakeViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return carMakes.count
    }
    
    
}

// MARK: Picker view delegate protocol conformance

extension SelectMakeViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(carMakes[row].data.attributes.name)" + " (\(carMakes[row].data.attributes.number_of_models))"
    }
}
