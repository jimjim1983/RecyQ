//
//  StoreTableViewCell.swift
//  RecyQ
//
//  Created by Alyson Vivattanapa on 3/21/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit

class StoreTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var storeItemImageView: UIImageView!
    @IBOutlet weak var storeItemPrice: UILabel!
    @IBOutlet var tokenImageView: UIImageView!
    @IBOutlet var storeItemTitleView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        storeItemTitleView.layer.cornerRadius = 10
//        storeItemImageView.layer.cornerRadius = 20
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .None
    }
    
}
