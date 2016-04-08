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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        co2View.layer.cornerRadius = 33;
        co2View.layer.shadowRadius = 10;
        co2View.layer.shadowOpacity = 0.2;
        co2View.layer.shadowOffset = CGSizeMake(1, 1);
        co2View.layer.shadowPath = UIBezierPath(roundedRect: co2View.bounds, cornerRadius: 33.0).CGPath
        co2View.backgroundColor = UIColor.whiteColor()
        // Do any additional setup after loading the view.
    }

    @IBAction func xButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }


}
