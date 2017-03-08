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
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var recyQTokenView: UIView!
    @IBOutlet weak var shopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        borderView.layer.cornerRadius = 33;
        borderView.layer.shadowRadius = 10;
        borderView.layer.shadowOpacity = 0.2;
        borderView.layer.shadowOffset = CGSize(width: 1, height: 1)
        borderView.layer.shadowPath = UIBezierPath(roundedRect: borderView.bounds, cornerRadius: 33.0).cgPath
        
        recyQTokenView.layer.cornerRadius = 33;
        recyQTokenView.layer.shadowRadius = 10;
        recyQTokenView.layer.shadowOpacity = 0.2;
        recyQTokenView.layer.shadowOffset = CGSize(width: 1, height: 1)
        recyQTokenView.layer.shadowPath = UIBezierPath(roundedRect: recyQTokenView.bounds, cornerRadius: 33.0).cgPath
        recyQTokenView.backgroundColor = UIColor.white

        shopButton.layer.cornerRadius = 10
        shopButton.layer.shadowRadius = 10;
        shopButton.layer.shadowOpacity = 0.1;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Check if there's an internet connection
        ReachabilityHelper.checkReachability(viewController: self)
    }
    
    @IBAction func xButtonPressed(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
         NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "removeBlurView"), object:  self))
    }
    
    @IBAction func shopButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
        Constants.appDelegate.window?.rootViewController = Constants.appDelegate.tabbarController
        Constants.appDelegate.tabbarController?.selectedIndex = 2
    }
}
