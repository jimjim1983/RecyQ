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

class ProfileViewController: UIViewController, MKMapViewDelegate {
    
     let ref = Firebase(url: "https://recyqdb.firebaseio.com/")
    
    @IBOutlet weak var naamLabel: UILabel!
    
    @IBOutlet weak var adresLabel: UILabel!
 
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    var string: String!
    

    @IBOutlet weak var logoutButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        mapView.delegate = self
        
        let location = CLLocationCoordinate2DMake(52.297375, 4.987511)
        
        let recyQAnnotation = RecyQAnnotation(title: "RecyQ Drop-Off HQ", subtitle: "Wisseloord 182, 1106 MC, Amsterdam", coordinate: location, imageName: "customPinImage.png")
        
        let span = MKCoordinateSpanMake(0.002, 0.002)

        let region = MKCoordinateRegionMake(location, span)
        
        mapView.setRegion(region, animated: true)
        
        mapView.addAnnotation(recyQAnnotation)
        
        emailLabel.text = user?.name

        
        // Do any additional setup after loading the view.
    }
    
//When you click on map, open in Maps.

    @IBAction func logoutButtonPressed(sender: UIButton) {
        
        ref.unauth()
        let loginVC = LoginViewController()
//        self.presentViewController(loginVC, animated: true, completion: nil)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = loginVC
        
        
    }

    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "MyPin"
        
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        // Reuse the annotation if possible
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        
        if annotationView == nil
        {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            annotationView!.canShowCallout = true
            annotationView!.image = UIImage(named: "RecyQ Green")
            annotationView!.frame = CGRectMake(0, 0, 55, 55)
            let recyQCalloutButton = UIButton(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
            recyQCalloutButton.setImage(UIImage(named: "RecyQ Green"), forState: UIControlState.Normal)
            annotationView!.rightCalloutAccessoryView = recyQCalloutButton
        }
        else
        {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! RecyQAnnotation
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        // can also set this to driving instructions mode, if preferred. i love walking with garbage though.
        location.mapItem().openInMapsWithLaunchOptions(launchOptions)
    }
    
}



