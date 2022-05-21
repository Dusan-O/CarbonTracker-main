//
//  DestinationAdressViewController.swift
//  CarbonTracker
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import UIKit
import CoreLocation

// MARK: - Class
class DestinationAdressViewController: UIViewController {
    
    // MARK: - @IBOutlets
    @IBOutlet var adressTextFields: [UITextField]!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var countryPickerView: UIPickerView!

    // MARK: - Properties

}

// MARK: - Functions overrides
extension DestinationAdressViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        countryPickerView.selectRow(62, inComponent: 0, animated: true)
        toggleActivityIndicator(shown: false)
    }
    
}

// MARK: - @IBActions
extension DestinationAdressViewController {
    
    @IBAction func unwindToDestinationAdressVC(segue: UIStoryboardSegue) {}
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        proceedToNextVC()
    }
    @IBAction func didTappedMainView(_ sender: Any) {
        for textField in adressTextFields {
            textField.resignFirstResponder()
        }
    }
}

// MARK: - Functions
extension DestinationAdressViewController {
    
    /// This function sets self as textfields delagate.
    private func setDelegates() {
        for textField in adressTextFields {
            if textField.tag == 1 {
                textField.becomeFirstResponder()
            }
            textField.delegate = self
        }
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
    }
    
    /// This function gathers all textfields information
    /// before performing segue to Destination Adress VC.
    private func proceedToNextVC() {
        guard noTextFieldIsEmpty() == true else {
            presentAlert(with: "An information is missing. \nCheck fields before proceeding.")
            return
        }
        guard let streetNbr = adressTextFields[0].text, let streetType = adressTextFields[1].text, let streetName = adressTextFields[2].text, let postCode = adressTextFields[3].text, let city = adressTextFields[4].text else {
            presentAlert(with: "Unable to decode this adress.")
        return
        }
        let country = countryList[countryPickerView.selectedRow(inComponent: 0)]
        toggleActivityIndicator(shown: true)
        var concatenatedAdress = String()
        concatenatedAdress = "\(streetNbr), \(streetType.capitalized) \(streetName.capitalized), \(postCode), \(city.capitalized)"
        GeoCoderService.sharedGeoCoderHelper.getCoordinatesFrom(concatenatedAdress) { placemark in
            self.toggleActivityIndicator(shown: false)
            guard case .success(let location) = placemark else {
                self.presentAlert(with: "Unable to find coordinates for this location.")
                return
            }
            let locationToSend = Location(streetNumber: streetNbr, streetType: streetType.capitalized, streetName: streetName.capitalized, cityName: city.capitalized, postCode: postCode, country: country.capitalized, placemark: location)
            LocationDatas.sharedLocations.destinationPlacemark = locationToSend
            self.performSegue(withIdentifier: "segueToConfirmVC", sender: nil)
        }
    }
    
    /// This function returns a boolean value.
    /// It checks if any of the textfields is empty.
    private func noTextFieldIsEmpty() -> Bool {
        for textField in adressTextFields {
            if textField.text == "" {
                return false
            }
        }
        return true
    }
    
    /// This function displays an alert to user.
    /// - Parameter message : A string value, which
    /// is the message displayed in case of an Alert.
    private func presentAlert(with message: String) {
        let alertViewController = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertViewController, animated: true, completion: nil)
    }
    
    /// This function toggles activity indicator and button
    /// - Parameter shown: a boolean used to
    /// apply to isHidden property.
    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
        nextButton.isHidden = shown
    }
    
}

// MARK: - TextField delegate conformance
extension DestinationAdressViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.tag != 5 {
            for loopedTextfield in adressTextFields where loopedTextfield.tag == textField.tag + 1 {
                loopedTextfield.becomeFirstResponder()
            }
        }
        return true
    }
}

// MARK: - PickerView delegate conformance
extension DestinationAdressViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return  countryList.count
    }
}

// MARK: - PickerView data source conformance
extension DestinationAdressViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countryList[row]
    }
}




