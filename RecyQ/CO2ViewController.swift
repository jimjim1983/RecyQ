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
        
     reachability = Reachability.init()
        
        reachability!.whenReachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async {
                if reachability.isReachableViaWiFi {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
            }
        }
        
        reachability!.whenUnreachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async {
                print("Not reachable")
                
                let alert = UIAlertController(title: "Oeps!", message: "Please connect to the internet to use the RecyQ app.", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "Ok", style: .default) { (action: UIAlertAction) -> Void in
                }
                alert.addAction(okayAction)
                self.present(alert, animated: true, completion: nil)
                
            }
        }
        
        do {
            try reachability!.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
    }


    @IBAction func xButtonPressed(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "removeBlurView"), object:  self))
        

    }


}
