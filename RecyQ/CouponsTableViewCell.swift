//
//  CouponsTableViewCell.swift
//  RecyQ
//
//  Created by Jim Petri on 03/05/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit

class CouponsTableViewCell: UITableViewCell {

    @IBOutlet var shopItemName: UILabel!
    @IBOutlet var shopName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
