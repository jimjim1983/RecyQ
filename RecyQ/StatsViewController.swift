//
//  StatsViewController.swift
//  RecyQ
//
//  Created by Jim Petri on 21/03/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

var numberOfTokens: Int!

class StatsViewController: UIViewController {
    
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

    @IBOutlet var navigationBarTitle: UINavigationItem!
    
    
    @IBOutlet weak var tokenAmountLabel: UILabel!

    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet weak var co2AmountLabel: UILabel!
    
    @IBOutlet weak var co2Button: UIButton!
    @IBOutlet weak var recyQTokenButton: UIButton!

    var co2Amount: Double!
    
    var totalWasteAmount: Double! = 0
    
    var tokenAmount: Double!
    
    var blurEffectView = UIVisualEffectView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

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
        
        paperView.layer.cornerRadius = 10
        plasticView.layer.cornerRadius = 10
        textileView.layer.cornerRadius = 10
        ijzerView.layer.cornerRadius = 10
        ewasteView.layer.cornerRadius = 10
        biowasteView.layer.cornerRadius = 10

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Check if there's an internet connection
        ReachabilityHelper.checkReachability(viewController: self)
        
        // New code with new Firebase
        FIRAuth.auth()!.addStateDidChangeListener { (auth, user) in
            if let user = user {
                FirebaseHelper.References.clientsRef.queryOrdered(byChild: "uid").queryEqual(toValue: user.uid).observe(.childAdded, with: { (snapShot) in
                    let name = (snapShot.value as AnyObject).object(forKey: "name") as? String
                    let lastName = (snapShot.value as AnyObject).object(forKey: "lastName") as? String
                    let address = (snapShot.value as AnyObject).object(forKey: "address") as? String
                    let zipCode = (snapShot.value as AnyObject).object(forKey: "zipCode") as? String
                    let city = (snapShot.value as AnyObject).object(forKey: "city") as? String
                    let phoneNumber = (snapShot.value as AnyObject).object(forKey: "phoneNumber") as? String
                    let email = (snapShot.value as AnyObject).object(forKey: "email") as? String
                    let nearestWasteLocation = (snapShot.value as AnyObject).object(forKey: "nearestWasteLocation") as? NearestWasteLocation
                    let amountOfPlastic = (snapShot.value as AnyObject).object(forKey: "amountOfPlastic") as? Double
                    let amountOfBioWaste = (snapShot.value as AnyObject).object(forKey: "amountOfBioWaste") as? Double
                    let amountOfEWaste = (snapShot.value as AnyObject).object(forKey: "amountOfEWaste") as? Double
                    let amountOfPaper = (snapShot.value as AnyObject).object(forKey: "amountOfPaper") as? Double
                    let amountOfTextile = (snapShot.value as AnyObject).object(forKey: "amountOfTextile") as? Double
                    let completed = (snapShot.value as AnyObject).object(forKey: "completed") as? Bool
                    let uid = (snapShot.value as AnyObject).object(forKey: "uid") as? String
                    let spentCoins = (snapShot.value as AnyObject).object(forKey: "spentCoins") as? Int
                    
                    currentUser = User(name: name!, lastName: lastName!, address: address!, zipCode: zipCode!, city: city!, phoneNumber: phoneNumber!, addedByUser: email!, nearestWasteLocation: nearestWasteLocation!, completed: completed!, amountOfPlastic: amountOfPlastic!, amountOfPaper: amountOfPaper!, amountOfTextile: amountOfTextile!, amountOfEWaste: amountOfEWaste!, amountOfBioWaste: amountOfBioWaste!, uid: uid!, spentCoins:  spentCoins!)
                    
                    print(currentUser)
                    
                    if let plastic = currentUser?.amountOfPlastic {
                        self.plasticLabel.text = "\(plastic)"
                        print(plastic)
                    }
                    if let paper = currentUser?.amountOfPaper {
                        self.paperLabel.text = "\(paper)"
                        print(paper)
                    }
                    if let textile = currentUser?.amountOfTextile {
                        self.textileLabel.text = "\(textile)"
                        print(textile)
                    }
           
                    if let eWaste = currentUser?.amountOfEWaste {
                        self.eWasteLabel.text = "\(eWaste)"
                        print(eWaste)
                    }
                    if let bioWaste = currentUser?.amountOfBioWaste {
                        self.bioWasteLabel.text = "\(bioWaste)"
                        print(bioWaste)
                    }
                    //co2 labels
                    let paperCarbonSaved = round(((currentUser?.amountOfPaper)!/35) * 50)
                    self.paperco2Label.text = "\(paperCarbonSaved)"
                    let plasticCarbonSaved = round(((currentUser?.amountOfPlastic)!/35) * 50)
                    self.plasticco2Label.text = "\(plasticCarbonSaved)"
                    let textileCarbonSaved = round(((currentUser?.amountOfTextile)!/35) * 50)
                    self.textileco2Label.text = "\(textileCarbonSaved)"
                    let eWasteCarbonSaved = round(((currentUser?.amountOfEWaste)!/35) * 50)
                    self.ewasteco2Label.text = "\(eWasteCarbonSaved)"
                    let biowasteCarbonSaved = round(((currentUser?.amountOfBioWaste)!/35) * 50) 
                    self.biowasteco2Label.text = "\(biowasteCarbonSaved)"
                    
                    
//                    self.totalWasteAmount = Double(currentUser?.amountOfPlastic!) + Double(currentUser?.amountOfPaper!) + Double(currentUser?.amountOfTextile!) + Double(currentUser?.amountOfIron!) + Double(currentUser?.amountOfEWaste!) + Double(currentUser?.amountOfBioWaste!)
                    
                    
                    self.totalWasteAmount.add((currentUser?.amountOfPlastic)!)
                    self.totalWasteAmount.add((currentUser?.amountOfPaper)!)
                    self.totalWasteAmount.add((currentUser?.amountOfTextile)!)
                    self.totalWasteAmount.add((currentUser?.amountOfEWaste)!)
                    self.totalWasteAmount.add((currentUser?.amountOfBioWaste)!)

                    
                    self.tokenAmount = round(self.totalWasteAmount/35)
                    
                    self.co2Amount = (round((self.totalWasteAmount/35) * 50))
                    
                    numberOfTokens = (Int(self.tokenAmount))  - (currentUser?.spentCoins)!
                    
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
        checkIfFirstLaunch()
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
        
        //view.addSubview(blurEffectView)
//        let co2ViewController = CO2ViewController()
//        co2ViewController.view.backgroundColor = UIColor.clear
//        
//        co2ViewController.co2AmountLabel.text = self.co2AmountLabel.text
//        
//        self.present(co2ViewController, animated: true, completion: nil)
       
        let tutorialViewController = TutorialViewController()
        tutorialViewController.view.backgroundColor = UIColor.clear
        self.present(tutorialViewController, animated: true, completion: nil)
      
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
    
    func checkIfFirstLaunch() {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore {
            print("NOT the first launch")
        } else {
            print("This is the first launch")
            view.addSubview(blurEffectView)
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            UserDefaults.standard.synchronize()
            let tutorialVC = TutorialViewController(nibName: "TutorialViewController", bundle: nil)
            tutorialVC.view.backgroundColor = UIColor.clear
            tutorialVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.present(tutorialVC, animated: true, completion: nil)
        }
    }
}
