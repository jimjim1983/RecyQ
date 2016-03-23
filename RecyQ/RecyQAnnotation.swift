//
//  RecyQAnnotation.swift
//  RecyQ
//
//  Created by Alyson Vivattanapa on 3/22/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit
import MapKit
import AddressBook

class RecyQAnnotation: NSObject, MKAnnotation {

    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        
        super.init()
    }
    
    func mapItem() -> MKMapItem {
        
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: subtitle as! AnyObject as? [String : AnyObject])
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
    
}
