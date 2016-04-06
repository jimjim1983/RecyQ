//
//  StatsViewController.swift
//  RecyQ
//
//  Created by Jim Petri on 21/03/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var paperView: UIView!
    @IBOutlet weak var plasticView: UIView!
    @IBOutlet weak var textileView: UIView!
    @IBOutlet weak var ijzerView: UIView!
    @IBOutlet weak var ewasteView: UIView!
    @IBOutlet weak var biowasteView: UIView!
    @IBOutlet var usernameLabel: UILabel!
//    @IBOutlet var userIDLabel: UILabel!
    @IBOutlet var plasticLabel: UILabel!
    @IBOutlet var paperLabel: UILabel!
    @IBOutlet var textileLabel: UILabel!
    @IBOutlet var ironLabel: UILabel!
    @IBOutlet var eWasteLabel: UILabel!
    @IBOutlet var bioWasteLabel: UILabel!
    @IBOutlet var navigationBar: UINavigationBar!

    //Navbar
    @IBOutlet var navigationBarTitle: UINavigationItem!
    @IBOutlet var navigationBarImage: UIImageView!
    @IBOutlet var tokenAmountLabel: UILabel!

    @IBOutlet var scrollView: UIScrollView!
    

    
    var testUser = User(username: "Jimsalabim", userID: "A0123131", password: "hallo", amountOfPlastic: 0.4, amountOfPaper: 0.9, amountOfTextile: 1.4, amountOfIron: 32.1, amountOfEWaste: 0.2, amountOfBioWaste: 120.3, amountOfTokens: 4)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.tintColor = UIColor.greenColor()
        navigationBarTitle.title = testUser.username
        navigationBarImage.image = UIImage(named: "recyqToken")
        
        paperView.layer.cornerRadius = 10
        plasticView.layer.cornerRadius = 10
        textileView.layer.cornerRadius = 10
        ijzerView.layer.cornerRadius = 10
        ewasteView.layer.cornerRadius = 10
        biowasteView.layer.cornerRadius = 10
        
        if let tokenAmount = testUser.amountOfTokens {
        tokenAmountLabel.text = "\(tokenAmount)"
        }
        
//        userIDLabel.text = testUser.userID
        if let plastic = testUser.amountOfPlastic {
            plasticLabel.text = "\(plastic)"
        }
        if let paper = testUser.amountOfPaper {
            paperLabel.text = "\(paper)"
        }
        if let textile = testUser.amountOfTextile {
            textileLabel.text = "\(textile)"
        }
        if let iron = testUser.amountOfIron {
            ironLabel.text = "\(iron)"
        }
        if let eWaste = testUser.amountOfEWaste {
            eWasteLabel.text = "\(eWaste)"
        }
        if let bioWaste = testUser.amountOfBioWaste {
            bioWasteLabel.text = "\(bioWaste)"
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        scrollView.setContentOffset(CGPointMake(0,0), animated: true)
        
        activityIndicator.startAnimating()
        
        paperView.alpha = 0
        plasticView.alpha = 0
        textileView.alpha = 0
        ijzerView.alpha = 0
        ewasteView.alpha = 0
        biowasteView.alpha = 0
        
        slidePaperView()
        
        NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: "slidePlasticView", userInfo: nil, repeats: false)
        
         NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "slideTextileView", userInfo: nil, repeats: false)
        
         NSTimer.scheduledTimerWithTimeInterval(0.75, target: self, selector: "slideIjzerView", userInfo: nil, repeats: false)
        
         NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "slideEwasteView", userInfo: nil, repeats: false)
        
         NSTimer.scheduledTimerWithTimeInterval(1.25, target: self, selector: "slideBiowasteView", userInfo: nil, repeats: false)
        
    }
    
    
    func slidePaperView() {
         addSlideAnimation(paperView)
    }
    
    func slidePlasticView() {
        addSlideAnimation(plasticView)
    }
    
    func slideTextileView() {
        addSlideAnimation(textileView)
    }
    
    func slideIjzerView() {
        addSlideAnimation(ijzerView)
    }
    
    func slideEwasteView() {
        addSlideAnimation(ewasteView)
    }
    
    func slideBiowasteView() {
        addSlideAnimation(biowasteView)
        activityIndicator.stopAnimating()
    }
    
    func addSlideAnimation(viewName: UIView) {
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue = -500
        animation.toValue = 0
        animation.duration = 1
        animation.autoreverses = false
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        viewName.layer.addAnimation(animation, forKey: nil)
        viewName.alpha = 1
    }

}
