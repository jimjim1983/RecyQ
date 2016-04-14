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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func xButtonPressed(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func shopButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
//        let storeVC = StoreViewController()
//        self.navigationController?.presentViewController(storeVC, animated: true, completion: nil)
        print(self.tabBarController?.viewControllers)
        
//       let storeVC = self.tabBarController!.viewControllers![2]
//        
//        navigationController?.pushViewController(storeVC, animated: true)
        
        
//        self.presentViewController(self.tabBarController!, animated: true, completion: nil)
//
//        self.parentViewController?.navigationController?.presentViewController(tabBarController!, animated: true, completion: nil)
//        self.presentViewController(storeVC, animated: true, completion: nil)
//        self.tabBarController?.selectedIndex = 2;
//        self.presentViewController(tabBarController?.viewControllers![2] as! UIViewController!, animated: true, completion: nil)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
