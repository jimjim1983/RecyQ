//
//  PartnerCellTableViewCell.swift
//  RecyQ
//
//  Created by Supervisor on 06-07-17.
//  Copyright © 2017 Jimsalabim. All rights reserved.
//

import UIKit

class InfoCell: UITableViewCell {
    @IBOutlet var partnerNameLabel: UILabel!
    @IBOutlet var partnerImageView: UIImageView!
    @IBOutlet var partnerDescription: UILabel!
    
    static let identifier = "InfoCell"
    static let bacKGroundColors = [#colorLiteral(red: 0.2549019608, green: 0.5294117647, blue: 0.2431372549, alpha: 1), #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), #colorLiteral(red: 0, green: 0.4392156863, blue: 0.8039215686, alpha: 1), #colorLiteral(red: 1, green: 0.4196078431, blue: 0.0431372549, alpha: 1), #colorLiteral(red: 1, green: 0.7764705882, blue: 0.1529411765, alpha: 1)]
    
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
