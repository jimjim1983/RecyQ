//
//  CommunityTableViewCell.swift
//  RecyQ
//
//  Created by Alyson Vivattanapa on 3/30/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit

class CommunityTableViewCell: UITableViewCell {

    @IBOutlet var positionLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var co2SavedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.positionLabel.layer.cornerRadius = self.positionLabel.bounds.height / 2
        self.positionLabel.layer.masksToBounds = true
        self.positionLabel.addBorderWith(width: 1, color: .white)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
