//
//  CustomAnnotationView.swift
//  CarbonTracker
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import UIKit
import MapKit

/// This class defines a custom annotation view.
class CustomAnnotationView: MKAnnotationView {
    
    init(annotation: MKAnnotation?, reuseIdentifier: String?, image: UIImage) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.image = image
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    /// This function setups
    /// basic view parameters.
    func setup() {
        frame.size = CGSize(width: 40, height: 40)
        canShowCallout = true
        tintColor = UIColor.carbonBlue
        
    }

}
