//
//  PartnersViewController.swift
//  RecyQ
//
//  Created by Alyson Vivattanapa on 4/29/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit

class PartnersViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        title = "Partners"
        
        // Check if there's an internet connection
        ReachabilityHelper.checkReachability(viewController: self)
    }
       
    @IBAction func startupInResidenceButtonPressed(_ sender: UIButton) {
        
        if let url = URL(string: "http://www.startupinresidence.com/") {
            UIApplication.shared.openURL(url)
        }
    }

    @IBAction func amsterdamLovesBikesButtonPressed(_ sender: UIButton) {
        
        if let url = URL(string: "https://www.amsterdam.nl/parkeren-verkeer/fiets/fietsdepot/") {
            UIApplication.shared.openURL(url)
        }
    }
}
