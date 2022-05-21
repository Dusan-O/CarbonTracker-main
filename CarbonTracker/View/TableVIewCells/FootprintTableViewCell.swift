//
//  FootprintTableViewCell.swift
//  CarbonTracker
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import UIKit

// MARK: - Class
class FootprintTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var carView: UIView!
    @IBOutlet weak var cloudView: UIView!
    @IBOutlet weak var citiesView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var carMakeLabel: UILabel!
    @IBOutlet weak var carModelLabel: UILabel!
    @IBOutlet weak var startingLocationLabel: UILabel!
    @IBOutlet weak var destinationLocationLabel: UILabel!
    @IBOutlet weak var footprintLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - Properties
    var footprint: FootprintCdObject!
    
    // MARK: - Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
        makeRoundCornersToViews()
        mainView.addShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Functions
    
    /// This function makes round corners
    /// to cell
    private func makeRoundCornersToViews() {
        carView.layer.cornerRadius = 10
        cloudView.layer.cornerRadius = 10
        citiesView.layer.cornerRadius = 10
        mainView.layer.cornerRadius = 10
    }
    
    /// This function updates labels.
    func updateDisplay() {
        guard let footprint = footprint else { return }
        if let carMake = footprint.carMake, let carModel = footprint.carModel, let start = footprint.startingAdress, let dest = footprint.destinationAdress {
            carModelLabel.text = carModel
            carMakeLabel.text = carMake
            startingLocationLabel.text = start
            destinationLocationLabel.text = dest
            footprintLabel.text = "\(footprint.actualFootprint) kg"
            updateDate()
        }
    }
    
    /// This functions formats date
    /// and assign return string to label.
    private func updateDate() {
        guard let date = footprint.date else { return }
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        formatter1.dateFormat = "d/MM/y"
        let formatedDate = formatter1.string(from: date)
        dateLabel.text = formatedDate
    }

}
