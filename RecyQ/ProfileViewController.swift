//
//  ProfileViewController.swift
//  RecyQ
//
//  Created by Jim Petri on 21/03/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit
import MapKit
import Firebase



class ProfileViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {
    
    //var storeItem: StoreItem!
    var coupon: Coupon?
    var couponItems = [FDataSnapshot]()
    //var user: User!
    
    let ref = Firebase(url: "https://recyqdb.firebaseio.com/")
    let couponsRef = Firebase(url: "https://recyqdb.firebaseio.com/coupons")
    
    @IBOutlet weak var naamLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var naamInputLabel: UILabel!
    @IBOutlet var userInfoView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var emailLabel: UILabel!
    
    var string: String!
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet var buttonToMaps: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        mapView.delegate = self
        userInfoView.layer.cornerRadius = 10.0
        
        let location = CLLocationCoordinate2DMake(52.297375, 4.987511)
        
        let recyQAnnotation = RecyQAnnotation(title: "RecyQ Drop-Off HQ", subtitle: "Wisseloord 182, 1106 MC, Amsterdam", coordinate: location, imageName: "customPinImage.png")
        
        let span = MKCoordinateSpanMake(0.002, 0.002)
        
        let region = MKCoordinateRegionMake(location, span)
        
        mapView.setRegion(region, animated: true)
        
        mapView.addAnnotation(recyQAnnotation)
        
        let nib = UINib.init(nibName: "CouponsTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "cell")
        
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
            
        

        //couponItems.removeAll(keepCapacity: true)
        naamInputLabel.text = user?.name
        emailLabel.text = user?.addedByUser
        
        // go trough all coupons and find the one with the same user uid, then add them to the array for the tableview
        self.couponsRef?.queryOrdered(byChild: "uid").queryEqual(toValue: user?.uid).observe(.value, with: { snapshot in
            
            if let itemsFromSnapshots = snapshot?.children.allObjects as? [FDataSnapshot] {
                
                self.couponItems = itemsFromSnapshots
                self.tableView.reloadData()
            }
        })
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        ref?.unauth()
        let loginVC = LoginViewController()
        //        self.presentViewController(loginVC, animated: true, completion: nil)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = loginVC
        
        
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "MyPin"
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        // Reuse the annotation if possible
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil
        {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            annotationView!.canShowCallout = true
            annotationView!.image = UIImage(named: "RecyQ Green")
            annotationView!.frame = CGRect(x: 0, y: 0, width: 55, height: 55)
            let recyQCalloutButton = UIButton(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
            recyQCalloutButton.setImage(UIImage(named: "RecyQ Green"), for: UIControlState())
            annotationView!.rightCalloutAccessoryView = recyQCalloutButton
        }
        else
        {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! RecyQAnnotation
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        // can also set this to driving instructions mode, if preferred. i love walking with garbage though.
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return couponItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CouponsTableViewCell
        let item = couponItems[indexPath.row]
        cell.nameLabel.text = item.key
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Uw verdiende coupons:"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = couponItems[indexPath.row]
        let name = item.key
        
        if item.key .contains("Doneer") {
            let alertController = UIAlertController(title: "Bedankt voor je donatie", message: "Hou de Community pagina in de gaten om te zien wat er georganiseerd wordt", preferredStyle: .alert)
//            let OKAction = UIAlertAction(title: "Coupon verwijderen uit lijst?", style: .Default) { (action) in
//                
//                let redeemedCouponsRef = Firebase(url: "https://recyqdb.firebaseio.com/coupons/\(name)")
//                redeemedCouponsRef.removeValue()
//            }
            let cancelAction = UIAlertAction(title: "Terug", style: .default) { (action) in
            }
//            alertController.addAction(OKAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true) {
            }
            
        } else {
            let alertController = UIAlertController(title: "Toon deze coupon bij het Recyq inzamelpunt om te verzilveren", message: name, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true) {
            }
        }
    }
    
    @IBAction func openInMaps (_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Google Maps openen", message: "voor een routebeschrijving", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            if let url = URL(string: "https://www.google.nl/maps/place/Wisseloord+182,+1106+MC+Amsterdam-Zuidoost/@52.2973944,4.9853276,17z/data=!3m1!4b1!4m2!3m1!1s0x47c60c8ac7dd7be3:0x3eb79f318071fdae") {
                UIApplication.shared.openURL(url)
            }
        }
        let cancelAction = UIAlertAction(title: "Annuleer", style: .default) { (action) in
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true) {
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Futura", size: 15)!
        header.textLabel?.textColor = UIColor.black
    }
    
}



