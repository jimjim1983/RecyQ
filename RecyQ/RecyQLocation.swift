//
//  RecyQLocation.swift
//  RecyQ
//
//  Created by Supervisor on 16-04-17.
//  Copyright © 2017 Jimsalabim. All rights reserved.
//

import Foundation
import Firebase
import MapKit

enum NearestWasteLocation: String {
    case amsterdamsePoort = "A'damse Poort"
    case hBuurt = "H-Buurt"
    case holendrecht = "Holendrecht"
    case venserpolder = "Venserpolder"
}

struct RecyQLocation {
    let district: String //NearestWasteLocation.RawValue
    let name: String
    //let nameLabelBackroundColor: UIColor
    let address: String
    let postalCodePlace: String
    let phoneNumber: String
    let email: String?
    let websiteURL: String?
    let latitude: Double
    let longitude: Double
    
    func toAnyObject() -> [String: AnyObject] {
        return [
            "district": district as AnyObject,
            "name": name as AnyObject,
            "address": address as AnyObject,
            "postalCodePlace": postalCodePlace as AnyObject,
            "phoneNumber": phoneNumber as AnyObject,
            "email": email as AnyObject,
            "websiteURL": websiteURL as AnyObject,
            "latitude": latitude as AnyObject,
            "longitude": longitude as AnyObject
        ]
    }
    
    func setUpMapRegionForRecyQLocation() -> MKCoordinateRegion {
        let centerCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpanMake(0.002, 0.002)
        let region = MKCoordinateRegionMake(centerCoordinate, span)
        return region
    }
}

extension RecyQLocation {
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as? NSDictionary
        district = snapshotValue?["district"] as! String
        name = snapshotValue?["name"] as! String
        address = snapshotValue?["address"] as! String
        postalCodePlace = snapshotValue?["postalCodePlace"] as! String
        phoneNumber = snapshotValue?["phoneNumber"] as! String
        email = snapshotValue?["email"] as? String
        websiteURL = snapshotValue?["websiteURL"] as? String
        latitude = snapshotValue?["latitude"] as! Double
        longitude = snapshotValue?["longitude"] as! Double
    }
}
