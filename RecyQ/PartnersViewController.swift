//
//  PartnersViewController.swift
//  RecyQ
//
//  Created by Alyson Vivattanapa on 4/29/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit

class PartnersViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func terugButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
   
    
    @IBAction func startupInResidenceButtonPressed(sender: UIButton) {
        
        if let url = NSURL(string: "http://www.startupinresidence.com/") {
            UIApplication.sharedApplication().openURL(url)
        }
    }

}
