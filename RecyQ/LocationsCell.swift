//
//  LocationsCell.swift
//  RecyQ
//
//  Created by Supervisor on 16-04-17.
//  Copyright © 2017 Jimsalabim. All rights reserved.
//

import UIKit
import MapKit

class LocationsCell: UITableViewCell {
    @IBOutlet var locationNameLabel: UILabel!
    @IBOutlet var locationMapView: MKMapView!
    @IBOutlet var locationAddressNameLabel: UILabel!
    @IBOutlet var locationAddressLabel: UILabel!
    @IBOutlet var locationZipCodePlaceLabel: UILabel!
    
    static let identifier = "LocationsCell"
    
    var model: Model? {
        didSet {
            guard let model = model else {
                return
            }
            self.locationNameLabel.text = " " + model.name
            self.locationNameLabel.backgroundColor = model.nameLabelBackgroundColor
            self.locationAddressNameLabel.text = model.name
            self.locationAddressLabel.text = model.address
            self.locationZipCodePlaceLabel.text = model.zipCodePlace
            self.locationMapView.region = model.region
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension LocationsCell {
    struct Model {
        let name: String
        let nameLabelBackgroundColor: UIColor
        let address: String
        let zipCodePlace: String
        let region: MKCoordinateRegion
        
        init(location: RecyQLocation) {
            self.name = location.name
            self.nameLabelBackgroundColor = location.nameLabelBackroundColor
            self.address = location.address
            self.zipCodePlace = location.postalCodePlace
            self.region = location.region
        }
    }
}
