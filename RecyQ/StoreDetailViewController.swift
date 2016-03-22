//
//  StoreDetailViewController.swift
//  RecyQ
//
//  Created by Jim Petri on 21/03/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit

class StoreDetailViewController: UIViewController {
    
    var storeItem: StoreItem!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var image: UIImageView!
    @IBOutlet var logo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        titleLabel.text = storeItem.storeItemName
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Terug", style: UIBarButtonItemStyle.Plain, target: self, action: "navigateBack")
    }
    
    func navigateBack() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
