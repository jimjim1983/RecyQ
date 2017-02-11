//
//  StatsViewController.swift
//  RecyQ
//
//  Created by Jim Petri on 21/03/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit
import Firebase

    var numberOfTokens: Int!

class StatsViewController: UIViewController {
    
    let ref = Firebase(url: "https://recyqdb.firebaseio.com/clients")
    
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
    @IBOutlet var paperco2Label: UILabel!
    @IBOutlet var plasticco2Label: UILabel!
    @IBOutlet var textileco2Label: UILabel!
    @IBOutlet var ironco2Label: UILabel!
    @IBOutlet var ewasteco2Label: UILabel!
    @IBOutlet var biowasteco2Label: UILabel!

    
    
    
    
    
    
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var paperImageView: UIImageView!
    @IBOutlet var plasticImageView: UIImageView!
    @IBOutlet var textileImageView: UIImageView!
    @IBOutlet var ironImageView: UIImageView!
    @IBOutlet var eWasteImageView: UIImageView!
    @IBOutlet var bioWasteImageView: UIImageView!

    //Navbar
    @IBOutlet var navigationBarTitle: UINavigationItem!
    
    
    @IBOutlet weak var tokenAmountLabel: UILabel!

    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet weak var co2AmountLabel: UILabel!
    
    @IBOutlet weak var co2Button: UIButton!
    @IBOutlet weak var recyQTokenButton: UIButton!

    var co2Amount: Double!
    
    var totalWasteAmount: Double!
    
    var tokenAmount: Double!
    
    var blurEffectView = UIVisualEffectView()
    
//    var testUser = User(name: "Jimsalabim", addedByUser: "Recyq", completed: false, amountOfPlastic: 0, amountOfPaper: 0, amountOfTextile: 0, amountOfEWaste: 0, amountOfBioWaste: 0, amountOfIron: 0, uid: "0", spentCoins: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        numberOfTokens = 0
//        tokenAmount = 0
        
        paperImageView.image = UIImage(named: "Cell_Papier")
        plasticImageView.image = UIImage(named: "Cell Plastic")
        textileImageView.image = UIImage(named: "Cell Textiel")
        ironImageView.image = UIImage(named: "Cell Metaal")
        eWasteImageView.image = UIImage(named: "Cell_ewaste")
        bioWasteImageView.image = UIImage(named: "Cell_GFT")
        
        
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        self.blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        NotificationCenter.default.addObserver(self, selector: #selector(StatsViewController.removeBlurView(_:)), name: NSNotification.Name(rawValue: "removeBlurView"), object: nil)
        
        UINavigationBar.appearance().backgroundColor = UIColor.white
            
          
        

        
        
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
            
        
        
        ref?.observeAuthEvent { authData in
            if self.ref?.authData != nil {
                
                self.ref?.queryOrdered(byChild: "uid").queryEqual(toValue: self.ref?.authData.uid).observe(.childAdded, with: { snapshot in
                    
                    //let snapshotName = snapshot.key
                    
                    let name = (snapshot?.value as AnyObject).object(forKey: "name") as? String
                    let addedByUser = (snapshot?.value as AnyObject).object(forKey: "addedByUser") as? String
                    let amountOfPlastic = (snapshot?.value as AnyObject).object(forKey: "amountOfPlastic") as? Double
                    let amountOfBioWaste = (snapshot?.value as AnyObject).object(forKey: "amountOfBioWaste") as? Double
                    let amountOfEWaste = (snapshot?.value as AnyObject).object(forKey: "amountOfEWaste") as? Double
                    let amountOfIron = (snapshot?.value as AnyObject).object(forKey: "amountOfIron") as? Double
                    let amountOfPaper = (snapshot?.value as AnyObject).object(forKey: "amountOfPaper") as? Double
                    let amountOfTextile = (snapshot?.value as AnyObject).object(forKey: "amountOfTextile") as? Double
                    let completed = (snapshot?.value as AnyObject).object(forKey: "completed") as? Bool
                    let uid = (snapshot?.value as AnyObject).object(forKey: "uid") as? String
                    let spentCoins = (snapshot?.value as AnyObject).object(forKey: "spentCoins") as? Int
                    
                    user = User(name: name!, addedByUser: addedByUser!, completed: completed!, amountOfPlastic: amountOfPlastic!, amountOfPaper: amountOfPaper!, amountOfTextile: amountOfTextile!, amountOfEWaste: amountOfEWaste!, amountOfBioWaste: amountOfBioWaste!, amountOfIron: amountOfIron!, uid: uid!, spentCoins:  spentCoins!)
                    
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
                    //co2 labels
                    let paperCarbonSaved = (round((user!.amountOfPaper/35) * 50))
                    self.paperco2Label.text = "\(paperCarbonSaved)"
                    let plasticCarbonSaved = (round((user!.amountOfPlastic/35) * 50))
                    self.plasticco2Label.text = "\(plasticCarbonSaved)"
                    let textileCarbonSaved = (round((user!.amountOfTextile/35) * 50))
                    self.textileco2Label.text = "\(textileCarbonSaved)"
                    let ironCarbonSaved = (round((user!.amountOfIron/35) * 50))
                    self.ironco2Label.text = "\(ironCarbonSaved)"
                    let eWasteCarbonSaved = (round((user!.amountOfEWaste/35) * 50))
                    self.ewasteco2Label.text = "\(eWasteCarbonSaved)"
                    let biowasteCarbonSaved = (round((user!.amountOfBioWaste/35) * 50))
                    self.biowasteco2Label.text = "\(biowasteCarbonSaved)"

                    
                    self.totalWasteAmount =  user!.amountOfPlastic! + user!.amountOfPaper! + user!.amountOfTextile! + user!.amountOfIron! + user!.amountOfEWaste! + user!.amountOfBioWaste!
                    
                    self.tokenAmount = round(self.totalWasteAmount/35)
                    
                    self.co2Amount = (round((self.totalWasteAmount/35) * 50))
                    
                    numberOfTokens = (Int(self.tokenAmount))  - (user?.spentCoins)!
                    
                    self.co2AmountLabel.text = "\(Int(self.co2Amount)) kg"
                    
                    
                    // this weird piece of code is here as a failsafe because sometimes I think the numberOfTokens amount isn't updated in time enough from data on the backend to prevent a negative token balance. TODO: Find another fix for this.
                    
                    if numberOfTokens <= 0 {
                        self.tokenAmountLabel.text = "0"
                    } else {
                    self.tokenAmountLabel.text = "\(numberOfTokens)"
                    }
                    
                })
            }
        }
        
        
        blurEffectView.removeFromSuperview()
        
        scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
        
        activityIndicator.startAnimating()
        
        paperView.alpha = 0
        plasticView.alpha = 0
        textileView.alpha = 0
        ijzerView.alpha = 0
        ewasteView.alpha = 0
        biowasteView.alpha = 0
        
        slidePaperView()
        
        Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(StatsViewController.slidePlasticView), userInfo: nil, repeats: false)
        
         Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(StatsViewController.slideTextileView), userInfo: nil, repeats: false)
        
         Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(StatsViewController.slideIjzerView), userInfo: nil, repeats: false)
        
         Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(StatsViewController.slideEwasteView), userInfo: nil, repeats: false)
        
         Timer.scheduledTimer(timeInterval: 1.25, target: self, selector: #selector(StatsViewController.slideBiowasteView), userInfo: nil, repeats: false)
        

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        


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
    
    func addSlideAnimation(_ viewName: UIView) {
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue = -500
        animation.toValue = 0
        animation.duration = 1
        animation.autoreverses = false
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        viewName.layer.add(animation, forKey: nil)
        viewName.alpha = 1
    }
    
    
    @IBAction func co2ButtonPressed(_ sender: UIButton) {
        
        view.addSubview(blurEffectView)
        let co2ViewController = CO2ViewController()
        co2ViewController.view.backgroundColor = UIColor.clear
        
        co2ViewController.co2AmountLabel.text = self.co2AmountLabel.text
        
        self.present(co2ViewController, animated: true, completion: nil)
      
    }
    
    @IBAction func recyQButtonPressed(_ sender: UIButton) {
         view.addSubview(blurEffectView)
        let recyQTokenViewController = RecyQTokenViewController()
        recyQTokenViewController.view.backgroundColor = UIColor.clear
        recyQTokenViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        recyQTokenViewController.recyQTokenAmountLabel.text = self.tokenAmountLabel.text
        self.present(recyQTokenViewController, animated: true, completion: nil)
    }
    

    func removeBlurView(_ sender: Notification) {
        DispatchQueue.main.async { [unowned self] in
            for subview in self.view.subviews as [UIView] {
                if let blurEffectView = subview as? UIVisualEffectView {
                    blurEffectView.removeFromSuperview()
                }
            }
        }
    }
}
