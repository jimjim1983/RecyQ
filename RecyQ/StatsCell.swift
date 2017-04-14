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
    static let bacKGroundColors = [#colorLiteral(red: 1, green: 0.4083568454, blue: 0.251519829, alpha: 1), #colorLiteral(red: 0, green: 0.7605165839, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.8486332297, blue: 0.249439925, alpha: 1), #colorLiteral(red: 0, green: 0.8078528643, blue: 0.427520901, alpha: 1), #colorLiteral(red: 0.506552279, green: 0.5065647364, blue: 0.5065580606, alpha: 1)]
    static let wasteTypes = ["textiel", "Papier", "Pmd", "Bio", "E-Waste"]
    
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
