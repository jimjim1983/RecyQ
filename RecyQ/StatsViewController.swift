//
//  StatsViewController.swift
//  RecyQ
//
//  Created by Jim Petri on 21/03/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit
import Firebase

class StatsViewController: UIViewController {
    
    let ref = Firebase(url: "https://recyqdb.firebaseio.com/")
    
    let usersRef = Firebase(url: "https://recyqdb.firebaseio.com/online")
    
//    var user: User!
    
    var username: String?
    
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
    
    var testUser = User(name: "Jimsalabim", addedByUser: "Recyq", completed: false, amountOfPlastic: 0, amountOfPaper: 0, amountOfTextile: 0, amountOfEWaste: 0, amountOfBioWaste: 0, amountOfIron: 0, uid: "0")

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        self.blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("removeBlurView:"), name: "removeBlurView", object: nil)
        
        UINavigationBar.appearance().backgroundColor = UIColor.whiteColor()
            
          
        

        
        
//        navigationBar.tintColor = UIColor.greenColor()
//        if let co2Saved = testUser.co2Saved {
//        navigationBarTitle.title = "\(co2Saved)"
//        }
//        navigationBarTitle.title = username
//        if let usernameVar = username {
//            navigationBarTitle.title = "\(usernameVar)"
//            print("\(usernameVar)")
//        }
        
        
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
//        if let plastic = user!.amountOfPlastic {
//            plasticLabel.text = "\(plastic)"
//        }
//        if let paper = user!.amountOfPaper {
//            paperLabel.text = "\(paper)"
//        }
//        if let textile = user!.amountOfTextile {
//            textileLabel.text = "\(textile)"
//        }
//        if let iron = user!.amountOfIron {
//            ironLabel.text = "\(iron)"
//        }
//        if let eWaste = user!.amountOfEWaste {
//            eWasteLabel.text = "\(eWaste)"
//        }
//        if let bioWaste = user!.amountOfBioWaste {
//            bioWasteLabel.text = "\(bioWaste)"
//        }

    }
    
    override func viewWillAppear(animated: Bool) {
        
        ref.observeAuthEventWithBlock { authData in
            if self.ref.authData != nil {
                
                self.ref.queryOrderedByChild("uid").queryEqualToValue(self.ref.authData.uid).observeEventType(.ChildAdded, withBlock: { snapshot in
                    
                    let snapshotName = snapshot.key
                    
                    let name = snapshot.value.objectForKey("name") as? String
                    let addedByUser = snapshot.value.objectForKey("addedByUser") as? String
                    var amountOfPlastic = snapshot.value.objectForKey("amountOfPlastic") as? Double
                    let amountOfBioWaste = snapshot.value.objectForKey("amountOfBioWaste") as? Double
                    let amountOfEWaste = snapshot.value.objectForKey("amountOfEWaste") as? Double
                    let amountOfIron = snapshot.value.objectForKey("amountOfIron") as? Double
                    let amountOfPaper = snapshot.value.objectForKey("amountOfPaper") as? Double
                    let amountOfTextile = snapshot.value.objectForKey("amountOfTextile") as? Double
                    let completed = snapshot.value.objectForKey("completed") as? Bool
                    let uid = snapshot.value.objectForKey("uid") as? String
                    
                    user = User(name: name!, addedByUser: addedByUser!, completed: completed!, amountOfPlastic: amountOfPlastic!, amountOfPaper: amountOfPaper!, amountOfTextile: amountOfTextile!, amountOfEWaste: amountOfEWaste!, amountOfBioWaste: amountOfBioWaste!, amountOfIron: amountOfIron!, uid: uid!)
                    
                    print(user)
                    
                    if let plastic = user!.amountOfPlastic {
                        self.plasticLabel.text = "\(plastic)"
                        print(plastic)
                    }
                    if let paper = user!.amountOfPaper {
                        self.paperLabel.text = "\(paper)"
                        print(paper)
                    }
                    if let textile = user!.amountOfTextile {
                        self.textileLabel.text = "\(textile)"
                        print(textile)
                    }
                    if let iron = user!.amountOfIron {
                        self.ironLabel.text = "\(iron)"
                        print(iron)
                    }
                    if let eWaste = user!.amountOfEWaste {
                        self.eWasteLabel.text = "\(eWaste)"
                        print(eWaste)
                    }
                    if let bioWaste = user!.amountOfBioWaste {
                        self.bioWasteLabel.text = "\(bioWaste)"
                        print(bioWaste)
                    }
                    
                })
            }
        }
        
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
    
    override func viewDidAppear(animated: Bool) {
        

//        ref.observeAuthEventWithBlock { authData in
//            if authData != nil {
//                self.user = User(authData: authData)
//                // 1
//                let currentUserRef = self.usersRef.childByAppendingPath(self.user.uid)
//                // 2
//                currentUserRef.setValue(self.user.email)
//                // 3
//                currentUserRef.onDisconnectRemoveValue()
//            }
//        }
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
        
        view.addSubview(blurEffectView)
        let co2ViewController = CO2ViewController()
        co2ViewController.view.backgroundColor = UIColor.clearColor()
        
        co2ViewController.co2AmountLabel.text = self.co2AmountLabel.text
        
        self.presentViewController(co2ViewController, animated: true, completion: nil)
      
    }
    
    @IBAction func recyQButtonPressed(sender: UIButton) {
         view.addSubview(blurEffectView)
        let recyQTokenViewController = RecyQTokenViewController()
        recyQTokenViewController.view.backgroundColor = UIColor.clearColor()
        recyQTokenViewController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        recyQTokenViewController.recyQTokenAmountLabel.text = self.tokenAmountLabel.text
        self.presentViewController(recyQTokenViewController, animated: true, completion: nil)
    }
    

    func removeBlurView(sender: NSNotification) {
        dispatch_async(dispatch_get_main_queue()) { [unowned self] in
            for subview in self.view.subviews as [UIView] {
                if let blurEffectView = subview as? UIVisualEffectView {
                    blurEffectView.removeFromSuperview()
                }
            }
        }
    }
}
