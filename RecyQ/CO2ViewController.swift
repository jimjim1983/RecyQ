//
//  CO2ViewController.swift
//  RecyQ
//
//  Created by Alyson Vivattanapa on 4/8/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit

class CO2ViewController: UIViewController {
    
    @IBOutlet weak var co2AmountLabel: UILabel!
    
    @IBOutlet weak var co2View: UIView!

    @IBOutlet weak var xButton: UIButton!
    
    @IBOutlet weak var borderView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        
        borderView.layer.cornerRadius = 33
        borderView.layer.cornerRadius = 33
        borderView.layer.shadowRadius = 10
        borderView.layer.shadowOpacity = 0.2
        borderView.layer.shadowOffset = CGSize(width: 1, height: 1);
        borderView.layer.shadowPath = UIBezierPath(roundedRect: borderView.bounds, cornerRadius: 33.0).cgPath
        co2View.layer.cornerRadius = 33
        co2View.layer.shadowRadius = 10
        co2View.layer.shadowOpacity = 0.2
        co2View.layer.shadowOffset = CGSize(width: 1, height: 1);
        co2View.layer.shadowPath = UIBezierPath(roundedRect: co2View.bounds, cornerRadius: 33.0).cgPath
        co2View.backgroundColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Check if there's an internet connection
        ReachabilityHelper.checkReachability(viewController: self)
    }


    @IBAction func xButtonPressed(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "removeBlurView"), object:  self))
    }
}
