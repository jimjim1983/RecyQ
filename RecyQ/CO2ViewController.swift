//
//  CO2ViewController.swift
//  RecyQ
//
//  Created by Alyson Vivattanapa on 4/8/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit
import KDCircularProgress

class CO2ViewController: UIViewController {
    
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var co2ProgressView: KDCircularProgress!
    @IBOutlet weak var co2AmountLabel: UILabel!
    @IBOutlet var treesAmountLabel: UILabel!
    
    var treesAmount: String?
    var totalCO2Amount: Double?
    var co2Amount: String?
    fileprivate let navBarLogoImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 30))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "recyq_logo_s_RGB")
        imageView.image = image
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.topItem?.titleView = self.navBarLogoImageView
        if let co2Amount = co2Amount {
            self.co2AmountLabel.text = co2Amount + " BESPAARD"
        }
        if let treesAmount = self.treesAmount {
            self.treesAmountLabel.text = treesAmount
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Check if there's an internet connection
        ReachabilityHelper.checkReachability(viewController: self)
        if let totalCO2Amount = self.totalCO2Amount {
            // Here we use calculate remaining to get only the numbers after the decimal point.
            let remainingUntilNextSavedTree = (totalCO2Amount / 16.6).calculateRemaining()
            animateProgressView(toAngle: remainingUntilNextSavedTree)
        }
    }

    @IBAction func dismissButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Animations.
extension CO2ViewController {
    func animateProgressView(toAngle: Double) {
        let angle = 360 / 1 * toAngle
        self.co2ProgressView.animate(fromAngle: 0, toAngle: angle, duration: 1) { (completed) in
        }
    }
}
