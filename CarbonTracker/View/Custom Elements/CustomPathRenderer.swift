//
//  CustomPathRenderer.swift
//  CarbonTracker
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import UIKit
import MapKit

/// This class defines a path renderer.
/// It inherits from MKOverlayPathRenderer.
class CustomPathRenderer: MKOverlayPathRenderer {

    /// The polyline to render
    var polyline: MKPolyline
    
    //MARK: Initializers
    /// Initializes a new Renderer from a given polyline
    /// - Parameters:
    /// - polyline: The polyline to render
    init(polyline: MKPolyline) {
        self.polyline = polyline
        super.init(overlay: polyline)
    }

    /// This function creates a curved path
    /// based on given points.
    override func createPath() {
     let points = polyline.points()
     let centerMapPoint = MKMapPoint(polyline.coordinate)
     let startPoint = point(for: points[0])
     let endPoint = point(for: points[1])
     let centerPoint = point(for: centerMapPoint)
     let controlPoint = CGPoint(x: centerPoint.x + (startPoint.y - endPoint.y) / 3,
                                y: centerPoint.y + (endPoint.x - startPoint.x) / 3)

     let myPath = UIBezierPath()
     myPath.move(to: startPoint)
     myPath.addQuadCurve(to: endPoint,
                         controlPoint: controlPoint)
     path = myPath.cgPath
        
    }

}
