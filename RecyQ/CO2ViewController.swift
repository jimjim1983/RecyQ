//
//  CO2ViewController.swift
//  RecyQ
//
//  Created by Alyson Vivattanapa on 4/8/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit
import KDCircularProgress

class CO2ViewController: UIViewController {
    
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var co2ProgressView: KDCircularProgress!
    @IBOutlet weak var co2AmountLabel: UILabel!
   
    var co2Amount: String?
    fileprivate var angle: Double!
    fileprivate let navBarLogoImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 30))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "recyq_logo_s_RGB")
        imageView.image = image
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.topItem?.titleView = self.navBarLogoImageView
        if let co2Amount = co2Amount {
            self.co2AmountLabel.text = co2Amount
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Check if there's an internet connection
        ReachabilityHelper.checkReachability(viewController: self)
        animateProgressView()
    }

    @IBAction func dismissButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CO2ViewController {
    func animateProgressView() {
        let startAngle = 0
        self.angle = 300
        self.co2ProgressView.animate(fromAngle: Double(startAngle), toAngle: angle, duration: 1) { (completed) in
        }
    }
}
