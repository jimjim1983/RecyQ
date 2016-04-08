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

    @IBOutlet var tokenAmountLabel: UILabel!

    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet weak var co2AmountLabel: UILabel!
    
    
    @IBOutlet weak var co2Button: UIButton!
    @IBOutlet weak var recyQTokenButton: UIButton!

    var co2Amount: Double!
    
    var afvalAmount: Double!
    
    var tokenAmount: Double!
    
    var blurEffectView = UIVisualEffectView()
    
    var testUser = User(username: "Jimsalabim", userID: "A0123131", password: "hallo", amountOfPlastic: 0.4, amountOfPaper: 0.9, amountOfTextile: 1.4, amountOfIron: 32.1, amountOfEWaste: 0.2, amountOfBioWaste: 120.3, amountOfTokens: 4)

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationBar.tintColor = UIColor.greenColor()
//        if let co2Saved = testUser.co2Saved {
//        navigationBarTitle.title = "\(co2Saved)"
//        }
        navigationBarTitle.title = "RecyQ"
        
// if you want to make the nav bar title green
//        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor(red: 33.0/255, green: 210.0/255, blue: 37.0/255, alpha: 1.0)]
        
        paperView.layer.cornerRadius = 10
        plasticView.layer.cornerRadius = 10
        textileView.layer.cornerRadius = 10
        ijzerView.layer.cornerRadius = 10
        ewasteView.layer.cornerRadius = 10
        biowasteView.layer.cornerRadius = 10
        
//        if let tokenAmount = testUser.amountOfTokens {
//        tokenAmountLabel.text = "\(tokenAmount)"
//        }
        
        afvalAmount = testUser.amountOfPlastic! + testUser.amountOfPaper! + testUser.amountOfTextile! + testUser.amountOfIron! + testUser.amountOfEWaste! + testUser.amountOfBioWaste!
        
        tokenAmount = round(afvalAmount/35)
        
        co2Amount = (round((afvalAmount/35) * 50))
        
        co2AmountLabel.text = "\(Int(co2Amount)) kg"
        
        tokenAmountLabel.text = "\(Int(tokenAmount))"
        
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
        
        blurEffectView.removeFromSuperview()
        
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
        activityIndicator.stopAnimating()
    }
    
    func slideBiowasteView() {
        addSlideAnimation(biowasteView)
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
    
    
    @IBAction func co2ButtonPressed(sender: UIButton) {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        self.blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        view.addSubview(blurEffectView)
        let co2ViewController = CO2ViewController()
        co2ViewController.view.backgroundColor = UIColor.clearColor()
        co2ViewController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        co2ViewController.co2AmountLabel.text = self.co2AmountLabel.text
        self.presentViewController(co2ViewController, animated: true, completion: nil)
    }
    
    @IBAction func recyQButtonPressed(sender: UIButton) {
        let recyQTokenViewController = RecyQTokenViewController()
        recyQTokenViewController .view.backgroundColor = UIColor.clearColor()
        recyQTokenViewController .modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        recyQTokenViewController.recyQTokenAmountLabel.text = self.tokenAmountLabel.text
        self.presentViewController(recyQTokenViewController , animated: true, completion: nil)
    }
    

}
