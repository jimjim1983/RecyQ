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
        borderView.layer.shadowOffset = CGSizeMake(1, 1)
        borderView.layer.shadowPath = UIBezierPath(roundedRect: borderView.bounds, cornerRadius: 33.0).CGPath
        
        recyQTokenView.layer.cornerRadius = 33;
        recyQTokenView.layer.shadowRadius = 10;
        recyQTokenView.layer.shadowOpacity = 0.2;
        recyQTokenView.layer.shadowOffset = CGSizeMake(1, 1)
        recyQTokenView.layer.shadowPath = UIBezierPath(roundedRect: recyQTokenView.bounds, cornerRadius: 33.0).CGPath
        recyQTokenView.backgroundColor = UIColor.whiteColor()

        shopButton.layer.cornerRadius = 10
        shopButton.layer.shadowRadius = 10;
        shopButton.layer.shadowOpacity = 0.1;

       
    }
    
    @IBAction func xButtonPressed(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
         NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "removeBlurView", object:  self))
    }
    
    
    @IBAction func shopButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = appDelegate.tabbarController
        appDelegate.tabbarController?.selectedIndex = 2
        
    }


 

}