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
        self.storeItemImageView.addBorderWith(width: 1, color: .darkGray)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
}
