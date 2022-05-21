//
//  CountViewController.swift
//  CarbonTracker
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import UIKit
import CPRingChart
import MKRingProgressView

// MARK: - Class declaration
class CountViewController: UIViewController {
    
    // MARK: - Properties
    
    var footprintCdManager = FootprintCdManager.sharedFootprintCdManager
    var footprintCountManager = FootprintCountManager()
    var co2RingChartsDatas = [Double]()
    var Co2CountToPrepareForSegue: Double!
    var ttlKmToPrepareForSegue: Double!
    
    // MARK: - @IBOutlets
    
    @IBOutlet weak var co2ringChart: CPRingChart!
    @IBOutlet weak var occupancyRingChart: RingProgressView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var co2DatasView: UIView!
    @IBOutlet weak var occupancyView: UIView!
    @IBOutlet weak var totalCo2Label: UILabel!
    @IBOutlet weak var wastedCo2Label: UILabel!
    @IBOutlet weak var occupancyRateLabel: UILabel!
    @IBOutlet weak var circleView: CircleView!
    @IBOutlet weak var backgroundView: UIView!
    
    // MARK: - Functions overrides
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if CoreUserDefaults.shared.isNewUser() {
            let vc = storyboard?.instantiateViewController(withIdentifier: "onboardingVC") as! OnboardingViewController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        circleView.addShadow()
        addObservers()
        setupCo2RingChart()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateView()
        performCalculations()
        updateCo2RingChart()
        animateOccupancyAlpha()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "segueToModalVC" {
            let destinationVC = segue.destination as! CountModalViewController
            destinationVC.ttlKmReceivedFromSegue = ttlKmToPrepareForSegue
            destinationVC.Co2CountReceivedFromSegue = Co2CountToPrepareForSegue
        }
    }
    
}

// MARK: - @ObjC Functions

extension CountViewController {
    
    /// This function updates appends ring chart
    /// data array.
    /// - Parameter notification: a notification received.
    @objc private func updateCo2Count(notification: Notification)  {
        guard let userInfo = notification.userInfo else { return }
        var co2 = 0.0
        if let co2AsDouble = userInfo["updateDisplay"] as? Double {
            co2 = co2AsDouble
        }
        co2RingChartsDatas.append(co2)
        Co2CountToPrepareForSegue = co2
        updateCo2Labels(for: totalCo2Label, with: co2)
    }
    
    /// This function updates saveable Label
    /// label whenever a notification is received.
    /// - Parameter notification: a notification received.
    @objc private func updateWastedCo2(notification: Notification)  {
        guard let userInfo = notification.userInfo else { return }
        var wastedCo2 = 0.0
        if let wastedCo2AsDouble = userInfo["updateDisplay"] as? Double {
            wastedCo2 = wastedCo2AsDouble
        }
        co2RingChartsDatas.append(wastedCo2)
        updateCo2Labels(for: wastedCo2Label, with: wastedCo2)
        animateCo2DatasView()
        
    }
    
    /// This function updates saveable Label
    /// label whenever a notification is received.
    /// - Parameter notification: a notification received.
    @objc private func updateAverageOccupancy(notification: Notification)  {
        guard let userInfo = notification.userInfo else { return }
        if let averageOccupancyAsInt = userInfo["updateDisplay"] as? Int {
            let averageOccupacyAsDbl = Double(averageOccupancyAsInt)
            UIView.animate(withDuration: 0.5) {
                self.occupancyRingChart.progress = averageOccupacyAsDbl / 100.0
            }
            occupancyRateLabel.text = "\(averageOccupancyAsInt)"
        }
    }
    
    /// This function updates kms property
    /// lwhenever a notification is received.
    /// - Parameter notification: a notification received.
    @objc private func updateTotalDistance(notification: Notification)  {
        guard let userInfo = notification.userInfo else { return }
        if let totalDistanceAsDbl = userInfo["updateDisplay"] as? Double {
            ttlKmToPrepareForSegue = totalDistanceAsDbl
        }
    }
    
    /// This function performs segue when a tap is detected.
    @objc private func handleTap(_: UITapGestureRecognizer) {
        performSegue(withIdentifier: "segueToModalVC", sender: nil)
    }
}

// MARK: - Functions

extension CountViewController {
    
    /// This function updates label's text property.
    /// - Parameter label: a UILabel where text should be changed.
    /// - Parameter co2: a double value used to insert in label's text property.
    private func updateCo2Labels(for label: UILabel!, with co2: Double) {
        if co2 < 10000.0 {
            label.text = "\(co2) kg"
        } else {
            let co2inTons = co2 / 1000.0
            label.text = "\(co2inTons) t."
        }
    }
    
    /// This function animates occupancy view's alpha.
    private func animateOccupancyAlpha() {
        occupancyView.alpha = 0
        UIView.animate(withDuration: 0.65) {
            self.occupancyView.alpha = 1
        }
    }
    
    /// This function animates co2DatasView,
    /// scaling it to minimum and then returning
    /// it to identity.
    private func animateCo2DatasView() {
        let scale = CGAffineTransform(scaleX: 0.1, y: 0.1)
        co2DatasView.transform = scale
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.1, options: [], animations: {
            self.co2DatasView.transform = .identity
        }, completion: nil)
    }
    
    /// This function calls model's functions
    /// to perform calculations, whose results
    /// are received through notifcations.
    private func performCalculations() {
        guard footprintCdManager.all.count > 0 else { return }
        co2RingChartsDatas.removeAll()
        footprintCountManager.calculateFootprintsCo2Count(from: footprintCdManager.all)
        footprintCountManager.calculateFootprintsWastedCo2Count(from: footprintCdManager.all)
        footprintCountManager.calculateAverageCarOccupancy(from: footprintCdManager.all)
        footprintCountManager.calculateTotalDistanceTraveled(from: footprintCdManager.all)
    }
    
    /// This function updates co2RingChart values
    /// at each viewWillAppear() calling.
    private func updateCo2RingChart() {
        if footprintCdManager.all.count > 0 {
            let scale = CGAffineTransform(scaleX: 0.1, y: 0.1)
            co2ringChart.transform = scale
            co2DatasView.alpha = 0
            self.co2ringChart.rotate()
            co2ringChart.values = co2RingChartsDatas
            co2ringChart.reloadChart()
            UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.1, options: [], animations: {
                self.co2ringChart.transform = .identity
            }, completion: nil)
            UIView.animate(withDuration: 0.65, delay: 0.6) {
                self.co2DatasView.alpha = 1.0
            }
        }
    }
    
    /// This function updates view
    /// based on footprints count.
    private func updateView() {
        let hasFootprints = footprintCdManager.all.count > 0
        messageLabel.isHidden = hasFootprints
        circleView.isHidden = hasFootprints
        co2ringChart.isHidden = !hasFootprints
        co2DatasView.isHidden = !hasFootprints
        occupancyView.isHidden = !hasFootprints
        occupancyRingChart.isHidden = !hasFootprints
        if hasFootprints {
            let backgroundTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            let co2TapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            let occupcyTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            co2ringChart.addGestureRecognizer(co2TapGestureRecognizer)
            occupancyRingChart.addGestureRecognizer(occupcyTapGestureRecognizer)
            backgroundView.addGestureRecognizer(backgroundTapGestureRecognizer)
        }
    }
    
    /// This function sets co2RingChart parameters
    /// only on viewDidLoad(), allowing setting
    /// basic display parameters.
    private func setupCo2RingChart() {
        co2ringChart.sections = 2
        co2ringChart.values = [5, 5]
        co2ringChart.fillColors = [.carbonBlue, .carbonPurple]
        co2ringChart.ringWidth = 30
        co2ringChart.reloadChart()
    }
    
    /// This function adds notif. observers
    /// to view controller.
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateCo2Count(notification:)),
                                               name: Notification.Name("updateCo2Count"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateWastedCo2(notification:)),
                                               name: Notification.Name("updateWastedCo2Count"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateAverageOccupancy(notification:)),
                                               name: Notification.Name("updateOccupancyAverage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTotalDistance(notification:)),
                                               name: Notification.Name("updateTotalDistance"), object: nil)
    }
    
}
