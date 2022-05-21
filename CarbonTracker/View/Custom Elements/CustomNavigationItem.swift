//
//  CustomNavigationItem.swift
//  CarbonTracker
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import UIKit

/// This class defines a custom
/// navigation bar item.
class CustomNavigationItem: UINavigationItem {
    
    private let fixedImage : UIImage = UIImage(named: "headerLogo")!
    private let imageView : UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 37.5))
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        imageView.contentMode = .scaleAspectFit
        imageView.image = fixedImage
        self.titleView = imageView
    }
}
