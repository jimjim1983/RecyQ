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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recyQTokenView.layer.cornerRadius = 33;
        recyQTokenView.layer.shadowRadius = 10;
        recyQTokenView.layer.shadowOpacity = 0.2;
        recyQTokenView.layer.shadowOffset = CGSizeMake(1, 1)
        recyQTokenView.layer.shadowPath = UIBezierPath(roundedRect: recyQTokenView.bounds, cornerRadius: 33.0).CGPath
        recyQTokenView.backgroundColor = UIColor.whiteColor()

//        shopButton.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
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
