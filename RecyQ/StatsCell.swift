//
//  StatsCell.swift
//  RecyQ
//
//  Created by Supervisor on 05-03-17.
//  Copyright © 2017 Jimsalabim. All rights reserved.
//

import UIKit

class StatsCell: UICollectionViewCell {
    
    @IBOutlet var wasteTypeLabel: UILabel!
    @IBOutlet var wasteAmountLabel: UILabel!
    @IBOutlet var co2AmountLabel: UILabel!
    
    static let identifier = "StatsCell"
    static let bacKGroundColors = [#colorLiteral(red: 1, green: 0.4083568454, blue: 0.251519829, alpha: 1), #colorLiteral(red: 0, green: 0.4392156863, blue: 0.8039215686, alpha: 1), #colorLiteral(red: 1, green: 0.4196078431, blue: 0.0431372549, alpha: 1), #colorLiteral(red: 1, green: 0.7764705882, blue: 0.1529411765, alpha: 1), #colorLiteral(red: 0.2549019608, green: 0.5294117647, blue: 0.2431372549, alpha: 1), #colorLiteral(red: 0.3921568627, green: 0.3921568627, blue: 0.4117647059, alpha: 1)]
    static let wasteTypes = ["textiel", "Papier", "Plastic", "Glas", "Bio", "E-Waste"]
    
    var wasteAmount: String? {
        didSet {
            guard let wasteAmount = wasteAmount else {
                return
            }
            self.wasteAmountLabel.text = wasteAmount
        }
    }
    
    var co2Amount: String? {
        didSet {
            guard let co2Amount = co2Amount else {
                return
            }
            self.co2AmountLabel.text = co2Amount
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

    }
}
