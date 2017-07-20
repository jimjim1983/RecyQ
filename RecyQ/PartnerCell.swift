//
//  PartnerCellTableViewCell.swift
//  RecyQ
//
//  Created by Supervisor on 06-07-17.
//  Copyright © 2017 Jimsalabim. All rights reserved.
//

import UIKit

class PartnerCell: UITableViewCell {
    @IBOutlet var partnerNameLabel: UILabel!
    @IBOutlet var partnerImageView: UIImageView!
    @IBOutlet var partnerDescription: UILabel!
    
    static let identifier = "PartnerCell"
    static let bacKGroundColors = [#colorLiteral(red: 1, green: 0.4083568454, blue: 0.251519829, alpha: 1), #colorLiteral(red: 0, green: 0.7605165839, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.8486332297, blue: 0.249439925, alpha: 1), #colorLiteral(red: 0, green: 0.8078528643, blue: 0.427520901, alpha: 1), #colorLiteral(red: 0.506552279, green: 0.5065647364, blue: 0.5065580606, alpha: 1)]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.partnerImageView.addBorderWith(width: 1, color: .lightGray)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
