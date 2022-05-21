//
//  FootprintsViewController.swift
//  CarbonTracker
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import UIKit

// MARK: - Class
class FootprintsViewController: UIViewController {

    // MARK: - Properties
    var carCoreDataManager = CarModelObjectManager.sharedCarModelObjectManager
    var footprintCoreDataManager = FootprintCdManager.sharedFootprintCdManager
    var footprintToPrepareForSegue: FootprintCdObject!
    
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var circleView: CircleView!
    
}

// MARK: - Functions overrides
extension FootprintsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        circleView.addShadow()
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "segueToFPDetailVC" {
            let destinationVC = segue.destination as! FootprintDetailViewController
            destinationVC.footprintReceivedFromSegue = footprintToPrepareForSegue
        }
    }
    
}

// MARK: - @IBActions
extension FootprintsViewController {
    
    /// This function is called after sender was tapped.
    @IBAction func didTappedPlusButton(_ sender: Any) {
        proceedToStartingAdressVC()
    }
    
    @IBAction func unwindToFootprintsVC(segue: UIStoryboardSegue) {}
    
}

// MARK: - @IBActions
extension FootprintsViewController {
    
    /// This function checks if user has a favourite car,
    /// otherwise he won't be able to perform
    /// calculations.
    private func proceedToStartingAdressVC() {
        guard carCoreDataManager.fetchFavouriteCar() != nil else {
            presentAlert(with: "You don't have any favourite car allowing to perform footprint calculations. Go to 'My car' to add one.")
            return
        }
        performSegue(withIdentifier: "segueToStartingAdressVC", sender: nil)
    }
    
    /// This function displays an alert to user.
    /// - Parameter message : A string value, which
    /// is the message displayed in case of an Alert.
    private func presentAlert(with message: String) {
        let alertViewController = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertViewController, animated: true, completion: nil)
    }
    
    /// This function checks if CoreData contains entities,
    /// and hides or reveals table view/message.
    private func updateView() {
        tableView.reloadData()
        let hasFootprints = footprintCoreDataManager.all.count > 0
        tableView.isHidden = !hasFootprints
        messageLabel.isHidden = hasFootprints
        circleView.isHidden = hasFootprints
    }
}

// MARK: - TableViewDataSource protocol conformance

extension FootprintsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return footprintCoreDataManager.all.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "footprintTableViewCell") as? FootprintTableViewCell else {
            return UITableViewCell()
        }
        let footprint = footprintCoreDataManager.all[indexPath.row]
        cell.footprint = footprint
        cell.updateDisplay()
        return cell
    }
    
}

// MARK: - TableViewDelegate protocol conformance

extension FootprintsViewController: UITableViewDelegate {
    
    /// This function conforms view controller to
    /// UITableViewDelegate, allowing deleting
    /// cells from core data and table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let footprint = footprintCoreDataManager.all[indexPath.row]
            footprintCoreDataManager.deleteFootprint(with: footprint) { success in
                tableView.deleteRows(at: [indexPath], with: .fade)
                self.updateView()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let footprint = footprintCoreDataManager.all[indexPath.row]
        footprintToPrepareForSegue = footprint
        performSegue(withIdentifier: "segueToFPDetailVC", sender: nil)
    }
    
}
