//
//  RecyQTokenViewController.swift
//  RecyQ
//
//  Created by Alyson Vivattanapa on 4/8/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit

class RecyQTokenViewController: UIViewController {

    @IBOutlet weak var recyQTokenAmountLabel: UILabel!
    @IBOutlet weak var xButton: UIButton!
    @IBOutlet weak var recyQTokenView: UIView!
    @IBOutlet weak var shopButton: UIButton!
    
    var tokenAmount: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tokenAmount = self.tokenAmount {
            self.recyQTokenAmountLabel.text = tokenAmount
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Check if there's an internet connection
        ReachabilityHelper.checkReachability(viewController: self)
    }
    
    @IBAction func xButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
         //NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "removeBlurView"), object:  self))
    }
    
    @IBAction func shopButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
        Constants.appDelegate.window?.rootViewController = Constants.appDelegate.tabbarController
        Constants.appDelegate.tabbarController?.selectedIndex = 2
    }
}
