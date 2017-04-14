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
    //@IBOutlet weak var co2View: UIView!
    @IBOutlet weak var xButton: UIButton!
    //@IBOutlet weak var borderView: UIView!
    var co2Amount: String?
    @IBOutlet weak var descriptionText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        //descriptionText.font = UIFont(name: "VolvoBroad", size: 18)!
        if let co2Amount = co2Amount {
            self.co2AmountLabel.text = co2Amount
        }
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
