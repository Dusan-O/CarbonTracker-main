//
//  OnboardingViewController.swift
//  CarbonTracker
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import UIKit

// MARK: - Class declaration
class OnboardingViewController: UIViewController {
    
    // MARK: - Properties
    let scrollView = UIScrollView()
    
    // MARK: - Outlets
    @IBOutlet weak var holderView: UIView!
    
    // MARK: - Functions overrides
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configure()
    }
    
    // MARK: - Functions
    
    /// This function configures scroll view
    /// and adds views in the for in loop.
    private func configure() {
        scrollView.frame =  holderView.bounds
        scrollView.backgroundColor = .clear
        holderView.addSubview(scrollView)
        
        let labelTitles: [String] = ["Welcome! \nThis app lets you track your carbon emissions made during car travels.",
        "After this tutorial, start with going to 'My car' tab and add your car. You can even add several cars if your own more than one.",
        "Then, go to 'List tab' to add your footprints each time you travel by car.",
        "In the 'Count' tab, you will see ring charts updated each time you add a footprint.\nTap anywhere to comparare with "]
        
        let imageTitles: [String] = ["headerLogo", "CarScreenShot", "ListScreenShot", "countScreenShot"]

        for x in 0..<4 {
            let pageView = UIView(frame: CGRect(x: CGFloat(x) * holderView.frame.size.width, y: 0, width: holderView.frame.size.width, height: holderView.frame.size.height))
            scrollView.addSubview(pageView)
            let label = UILabel(frame: CGRect(x: 10, y: 10, width: pageView.frame.size.width - 20, height: 120))
            let imageView = UIImageView(frame: CGRect(x: 10, y: 10 + 120 + 10, width: pageView.frame.size.width - 20, height: pageView.frame.size.height - 60 - 130 - 15))
            let button = UIButton(frame: CGRect(x: 10, y: pageView.frame.size.height - 60, width: pageView.frame.size.width - 20, height: 50))
            
            label.textAlignment = .center
            label.font = UIFont(name: "Helvetica Neue", size: 22)
            label.textColor = .white
            label.numberOfLines = 0
            pageView.addSubview(label)
            label.text = labelTitles[x]
            
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: imageTitles[x])
            pageView.addSubview(imageView)
            
            button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
            button.backgroundColor = UIColor(red: 0.58, green: 0.40, blue: 0.57, alpha: 1.00)
            button.layer.cornerRadius = 10
            button.tag = x + 1
            button.setTitle("Continue", for: .normal)
            if x == 3 {
                button.setTitle("Get started!", for: .normal)
            }
            button.setTitleColor(.white, for: .normal)
            pageView.addSubview(button)
        }
        scrollView.contentSize = CGSize(width: holderView.frame.size.width * 4, height: 0)
        scrollView.isPagingEnabled = true
        
    }
    
    // MARK: - @objc Functions
    
    /// This function is called after a tap on scroll view
    /// page button. If page is the last one,
    /// user will not be considered as a new user
    /// if he taps the button displayed.
    @objc func didTapButton(_ button: UIButton) {
        guard button.tag < 4 else {
            CoreUserDefaults.shared.isNotNewUser()
            dismiss(animated: true, completion: nil)
            return
        }
        scrollView.setContentOffset(CGPoint(x: holderView.frame.size.width * CGFloat((button.tag)), y: 0), animated: true)
    }
    
}
