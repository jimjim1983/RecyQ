//
//  Charity.swift
//  RecyQ
//
//  Created by Jim Petri on 22/03/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit


class StoreItem {
    
    var storeItemName : String?
    var storeItemDescription : String?
    var storeItemImage : UIImage?
    var storeItemPrice : Int?
    
    init(storeItemName: String, storeItemDescription: String, storeItemImage: String, storeItemPrice: Int){
        self.storeItemName = storeItemName
        self.storeItemDescription = storeItemDescription
        self.storeItemImage = UIImage(named: storeItemImage)
        self.storeItemPrice = storeItemPrice
    }
}


