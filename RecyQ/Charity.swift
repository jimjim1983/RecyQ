//
//  Charity.swift
//  RecyQ
//
//  Created by Jim Petri on 22/03/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit

var charityArray = [Charity]()

class Charity {
    
    var charityName : String?
    var charityDescription : String?
    var charityLogo : UIImage?
    var charityImage : UIImage?
    
    init(charityName: String, charityDescription: String, charityLogo: String, charityImage: String){
        self.charityName = charityName
        self.charityDescription = charityDescription
        self.charityLogo = UIImage(named: charityLogo)
        self.charityImage = UIImage(named: charityImage)
    }
}


