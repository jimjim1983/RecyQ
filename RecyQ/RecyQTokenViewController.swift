//
//  RecyQTokenViewController.swift
//  RecyQ
//
//  Created by Alyson Vivattanapa on 4/8/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit
import KDCircularProgress

class RecyQTokenViewController: UIViewController {

    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet weak var recyQTokenAmountLabel: UILabel!
    @IBOutlet var tokenProgressView: KDCircularProgress!
    
    var tokenAmount: String?
    var tokensEarned: Double?
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
        
        if let tokenAmount = self.tokenAmount {
            self.recyQTokenAmountLabel.text = tokenAmount + " VERDIEND"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Check if there's an internet connection
        ReachabilityHelper.checkReachability(viewController: self)
        if let tokensEarned = self.tokensEarned {
            // Here we use calculate remaining to get only the numbers after the decimal point.
            let remainingUntilNextTokenEarned = tokensEarned.calculateRemaining()
            animateProgressView(toAngle: remainingUntilNextTokenEarned)
        }
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Animations.
extension RecyQTokenViewController {
    func animateProgressView(toAngle: Double) {
        let angle = 360 / 1 * toAngle
        self.tokenProgressView.animate(fromAngle: 0, toAngle: angle, duration: 1) { (completed) in
        }
    }
}
