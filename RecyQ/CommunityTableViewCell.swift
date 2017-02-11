//
//  CommunityTableViewCell.swift
//  RecyQ
//
//  Created by Alyson Vivattanapa on 3/30/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit

class CommunityTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var co2SavedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
