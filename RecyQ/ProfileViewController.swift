//
//  ProfileViewController.swift
//  RecyQ
//
//  Created by Jim Petri on 21/03/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit
import MapKit

class ProfileViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var naamLabel: UILabel!
    
    @IBOutlet weak var adresLabel: UILabel!
 
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
  
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let location = CLLocationCoordinate2DMake(52.297375, 4.987511)
        
        let span = MKCoordinateSpanMake(0.002, 0.002)

        let region = MKCoordinateRegionMake(location, span)
        
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
       
        annotation.coordinate = location
        annotation.title = "Kroy Social Enterprise Pop-Up Store"
        annotation.subtitle = "Wisseloord 182, 1106 MC, Amsterdam"
        
        mapView.addAnnotation(annotation)
        // Do any additional setup after loading the view.
    }

// Change pin colour.
//    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
//        var mapPin = MKPinAnnotationView(
//    }
}
