//
//  FootprintDetailViewController.swift
//  CarbonTracker
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import UIKit
import MapKit

// MARK: - Class declaration
class FootprintDetailViewController: UIViewController {
    
    // MARK: - @IBOutlets
    @IBOutlet weak var mapKitView: MKMapView!
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var actualFootprintLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var wastedLabel: UILabel!
    @IBOutlet weak var passengersLabel: UILabel!
    @IBOutlet weak var seatsLabel: UILabel!
    
    // MARK: - Properties
    var footprintReceivedFromSegue: FootprintCdObject!
    
    // MARK: - Function overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        mapKitView.delegate = self
        makeRoundCornersToViews()
        updateMap()
        updateLabels()
    }
    
}

// MARK: - Functions
extension FootprintDetailViewController {
    
    /// This function updates labels.
    private func updateLabels() {
        guard let footprint = footprintReceivedFromSegue else { return }
        actualFootprintLabel.text = "\(footprint.actualFootprint) kg"
        distanceLabel.text = "\(footprint.distance) km"
        wastedLabel.text = "\(footprint.wastedCo2) kg"
        passengersLabel.text = "\(footprint.numberOfPax)"
        seatsLabel.text = "\(footprint.numberOfSeats)"
    }
    
    /// This function updates map based on footprint'ts
    /// coordinates. It calls several sub-functions
    /// to calculated map points, map rectangle,
    /// and map size.
    private func updateMap() {
        guard let footprint = footprintReceivedFromSegue else { return }
        let annotations = createMapAnnotations(from: footprint)
        mapKitView.showAnnotations(annotations, animated: false)
        let mapPoints = createMapPoints(from: footprint)
        let mapSize = calculateMapSize(from: mapPoints)
        let mapRect = calculateMapRect(from: mapPoints, withMapSize: mapSize)
        
        let polyLine = MKPolyline(points: mapPoints, count: 2)
        mapKitView.addOverlay(polyLine, level: .aboveRoads)
        
        var region = MKCoordinateRegion(mapRect)
        region.span.latitudeDelta *= 2
        region.span.longitudeDelta *= 2
        mapKitView.setRegion(region, animated: true)
    }
    
    /// This function returns a MKMapRect,
    /// used to display the correct map rectangle,
    /// calculated from  map points.
    /// - Parameter mapPoints: an array of MKMapPoint
    /// used to perform distance calculation between points.
    /// - Parameter mapSize: the calculated MKMapSize.
    private func calculateMapRect(from mapPoints: [MKMapPoint], withMapSize mapSize: MKMapSize) -> MKMapRect {
        var mapRect = MKMapRect()
        if mapPoints[0].x < mapPoints[1].x {
            if mapPoints[0].y < mapPoints[1].y {
                mapRect = MKMapRect(origin: mapPoints[0], size: mapSize)
            } else {
                let verticalPointDistanceBtwnAnnos = mapPoints[0].y - mapPoints[1].y
                let newMapPoint = MKMapPoint(x: mapPoints[0].x, y: mapPoints[0].y - verticalPointDistanceBtwnAnnos)
                mapRect = MKMapRect(origin: newMapPoint, size: mapSize)
            }
        } else {
            if mapPoints[1].y < mapPoints[0].y {
                mapRect = MKMapRect(origin: mapPoints[1], size: mapSize)
            } else {
                let horizontalPointDistanceBtwnAnnos = mapPoints[0].x - mapPoints[1].x
                let newMapPoint = MKMapPoint(x: mapPoints[0].x - horizontalPointDistanceBtwnAnnos, y: mapPoints[0].y)
                mapRect = MKMapRect(origin: newMapPoint, size: mapSize)
            }
        }
        return mapRect
    }
    
    /// This function returns a MKMapSize,
    /// used to display the correct map size,
    /// calculated between 2 map points.
    /// - Parameter mapPoints: an array of MKMapPoint
    /// used to perform distance calculation between points.
    private func calculateMapSize(from mapPoints: [MKMapPoint]) -> MKMapSize {
        var mapSize = MKMapSize()
        if mapPoints[0].x < mapPoints[1].x {
            mapSize = MKMapSize(width: mapPoints[1].x - mapPoints[0].x, height: 0)
        } else {
            mapSize = MKMapSize(width: mapPoints[0].x - mapPoints[1].x, height: 0)
        }
        
        if mapPoints[0].y < mapPoints[1].y  {
            mapSize.height = mapPoints[1].y - mapPoints[0].y
        } else {
            mapSize.height = mapPoints[0].y - mapPoints[1].y
        }
        return mapSize
    }
    
    /// This function returns an array of map points
    /// calculated with footprint's latitude & longitude.
    /// - Parameter footprint: A FootprintCdObject.
    private func createMapPoints(from footprint: FootprintCdObject) -> [MKMapPoint] {
        let startCoor2d = CLLocationCoordinate2D(latitude: footprint.startingAdressLat, longitude: footprint.startingAdressLon)
        let startingMapPoint = MKMapPoint(startCoor2d)
        let destCoor2d = CLLocationCoordinate2D(latitude: footprint.destAdressLat, longitude: footprint.destAdressLon)
        let destMapPoint = MKMapPoint(destCoor2d)
        return [startingMapPoint, destMapPoint]
    }
    
    /// This function returns an array of CustomAnnotation, used to place annotations on map.
    private func createMapAnnotations(from footprint: FootprintCdObject) -> [CustomAnnotation] {
        let startingCoords = CLLocationCoordinate2D(latitude: footprint.startingAdressLat, longitude: footprint.startingAdressLon)
        guard let startAdress = footprint.startingAdress else { return [] }
        let startingAnnotation = CustomAnnotation(title: startAdress, coordinate: startingCoords, isDeparture: true)
        
        let destCoords = CLLocationCoordinate2D(latitude: footprint.destAdressLat, longitude: footprint.destAdressLon)
        guard let destAdress = footprint.destinationAdress else { return [] }
        let destinationAnnotation = CustomAnnotation(title: destAdress, coordinate: destCoords, isDeparture: false)
        
        return [startingAnnotation, destinationAnnotation]
    }
    
    /// This function makes round corners
    /// to cell
    private func makeRoundCornersToViews() {
        upperView.layer.cornerRadius = 10
    }
}

// MARK: - MKMapViewDelegate conformance

extension FootprintDetailViewController: MKMapViewDelegate {
    
    /// This function adds a custom renderer to map.
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let overlay = overlay as? MKPolyline {
            let curvedRenderer = CustomPathRenderer(polyline: overlay)
            curvedRenderer.lineWidth = 5
            curvedRenderer.strokeColor = .carbonBlue
            return curvedRenderer
        } else {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.lineWidth = 5
            renderer.strokeColor = .carbonBlue
            return renderer
        }
    }
    
    /// This function adds custom views to map.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let id = "ID"
        if let customAnnotation = annotation as? CustomAnnotation {
            var view: CustomAnnotationView
            
            if let dequeue = mapKitView.dequeueReusableAnnotationView(withIdentifier: id) as? CustomAnnotationView {
                dequeue.annotation = customAnnotation
                view = dequeue
            } else {
                if customAnnotation.isDeparture == true {
                    view = CustomAnnotationView(annotation: customAnnotation, reuseIdentifier: id, image: UIImage(named: "flag")!)
                } else {
                    view = CustomAnnotationView(annotation: customAnnotation, reuseIdentifier: id, image: UIImage(named: "flagRed")!)
                }
            }
            return view
        }
        return nil
    }
    
}
