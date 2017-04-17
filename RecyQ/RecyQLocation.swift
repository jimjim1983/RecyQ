//
//  RecyQLocation.swift
//  RecyQ
//
//  Created by Supervisor on 16-04-17.
//  Copyright © 2017 Jimsalabim. All rights reserved.
//

import Foundation
import MapKit

enum NearestWasteLocation: String {
    case amsterdamsePoort = "A'damse Poort"
    case hBuurt = "H-Buurt"
    case holendrecht = "Holendrecht"
    case venserpolder = "Venserpolder"
}

struct RecyQLocation {
    let district: NearestWasteLocation
    let name: String
    let nameLabelBackroundColor: UIColor
    let address: String
    let postalCodePlace: String
    let region: MKCoordinateRegion
}
