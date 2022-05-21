//
//  SelectModelViewController.swift
//  CarbonTracker
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import UIKit

// MARK: - CLASS
class SelectModelViewController: UIViewController {
    
    // MARK: - PROPERTIES AND OUTLETS
    
    var carModels: [CarModelDatas]!
    var coreDataManager = CarModelObjectManager.sharedCarModelObjectManager
    
    @IBOutlet weak var carModelsPickerView: UIPickerView!

    // MARK: - @IBActions
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        saveCar()
    }
}

// MARK: - FUNCTIONS OVERRIDES

extension SelectModelViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carModelsPickerView.delegate = self
        carModelsPickerView.dataSource = self
    }
    
}

// MARK: - FUNCTIONS

extension SelectModelViewController {
    
    /// This function saves car to core data
    /// by calling specified model's function.
    private func saveCar() {
        let carToSave = carModels[carModelsPickerView.selectedRow(inComponent: 0)]
        coreDataManager.saveCarModel(with: carToSave) { success in
            self.coreDataManager.updateFavouriteCar(with: carToSave) { success in
                performSegue(withIdentifier: "unwindSegueToMyCarVC", sender: nil)
            }
        }
    }
}

// MARK: Picker view data source protocol conformance
extension SelectModelViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return carModels.count
    }

}

// MARK: Picker view delegate protocol conformance

extension SelectModelViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let name = carModels[row].data.attributes.name
        let year = String(carModels[row].data.attributes.year)
        return name + " (\(year))"
    }
}
