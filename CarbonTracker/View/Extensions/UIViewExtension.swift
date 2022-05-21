//
//  UIViewExtension.swift
//  CarbonTracker
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import UIKit

extension UIView {
    
    /// This function creates a rotation animation.
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 0.35
        rotation.isCumulative = true
        rotation.repeatCount = 0.5
        layer.add(rotation, forKey: "rotationAnimation")
    }
    
    /// This function adds shadow to a view.
    func addShadow() {
        if #available(iOS 13.0, *) {
            self.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        } else {
            // Fallback on earlier versions
        }
        self.layer.shadowRadius = 2.0
        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.layer.shadowOpacity = 2.0
        self.layer.cornerRadius = 10
    }
}
