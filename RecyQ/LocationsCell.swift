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
    @IBOutlet var locationPhoneNumberLabel: UILabel!
    
    static let identifier = "LocationsCell"
    static let bacKGroundColors = [#colorLiteral(red: 1, green: 0.4083568454, blue: 0.251519829, alpha: 1), #colorLiteral(red: 0, green: 0.7605165839, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.8486332297, blue: 0.249439925, alpha: 1), #colorLiteral(red: 0, green: 0.8078528643, blue: 0.427520901, alpha: 1), #colorLiteral(red: 0.506552279, green: 0.5065647364, blue: 0.5065580606, alpha: 1)]
    
    var model: Model? {
        didSet {
            guard let model = model else {
                return
            }
            self.locationNameLabel.text = " " + model.name
            self.locationAddressNameLabel.text = model.name
            self.locationAddressLabel.text = model.address
            self.locationZipCodePlaceLabel.text = model.zipCodePlace
            self.locationPhoneNumberLabel.text = model.phoneNumber
            self.locationMapView.region = model.region
        }
    }
    
    func callTheLocation(sender: UITapGestureRecognizer) {
        print("TAP DETECTED")
        if let phoneNumber = self.model?.phoneNumber {
            let phoneNumberWithoutWhiteSpaces = phoneNumber.replacingOccurrences(of: " ", with: "")
            if let phoneURL = URL(string: "telprompt://\(phoneNumberWithoutWhiteSpaces)") {
                print("\(phoneURL)")
                if UIApplication.shared.canOpenURL(phoneURL) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(phoneURL)
                    } else {
                        // Fallback on earlier versions
                        UIApplication.shared.openURL(phoneURL)
                    }
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(callTheLocation))
        self.locationPhoneNumberLabel.addGestureRecognizer(tapGestureRecogniser)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension LocationsCell {
    struct Model {
        let name: String
        let address: String
        let zipCodePlace: String
        let phoneNumber: String
        let region: MKCoordinateRegion
        
        init(location: RecyQLocation) {
            self.name = location.name
            self.address = location.address
            self.zipCodePlace = location.postalCodePlace
            self.phoneNumber = location.phoneNumber
            self.region = location.setUpMapRegionForRecyQLocation()
        }
    }
}
