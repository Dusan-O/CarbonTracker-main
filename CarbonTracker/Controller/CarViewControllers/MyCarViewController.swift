//
//  MyCarViewController.swift
//  CarbonTracker
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import UIKit

// MARK: - CLASS
class MyCarViewController: UIViewController {
    
    // MARK: - PROPERTIES AND OUTLETS
    
    var mycar: CarAttributes!
    var coreDataManager = CarModelObjectManager.sharedCarModelObjectManager
    
    @IBOutlet weak var noCarLabel: UILabel!
    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var carMakeLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var circleView: CircleView!
    
    // MARK: - @IBActions
    
    @IBAction func unwindToMyCarVC(segue: UIStoryboardSegue) {}
    
}

// MARK: - FUNCTIONS OVERRIDES

extension MyCarViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        circleView.addShadow()
        makeRoundCornersToBlueView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavouriteCar()
    }
}

// MARK: - FUNCTIONS

extension MyCarViewController {
    
    /// This function makes round corners to blue view.
    private func makeRoundCornersToBlueView() {
        blueView.layer.cornerRadius = 10
        blueView.addShadow()
    }
    
    /// This function retrieves current used car
    /// if one exists.
    private func fetchFavouriteCar() {
        let favCar = coreDataManager.fetchFavouriteCar()
        if favCar != nil {
            updateLabels(from: favCar)
        } else {
            updateDisplay(shown: false)
        }
    }
    
    /// This function updates labels.
    private func updateLabels(from car: CarModels?) {
        guard let unwrappedCar = car else { return }
        carMakeLabel.text = unwrappedCar.attributes.vehicle_make
        modelLabel.text = unwrappedCar.attributes.name
        yearLabel.text = "(\(unwrappedCar.attributes.year))"
        updateDisplay(shown: true)
    }
    
    /// This function updates view appearance
    /// or disapperance..
    private func updateDisplay(shown: Bool) {
        blueView.isHidden = !shown
        circleView.isHidden = shown
        noCarLabel.isHidden = shown
    }
    
    
}

