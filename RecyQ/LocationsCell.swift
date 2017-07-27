//
//  LocationsCell.swift
//  RecyQ
//
//  Created by Supervisor on 16-04-17.
//  Copyright © 2017 Jimsalabim. All rights reserved.
//

import UIKit
import MapKit

protocol LocationCellDelegate {
    func phoneLabelWasTapped(cell: LocationsCell)
    func emailLabelWasTapped(cell: LocationsCell)
    func websiteLabelWasTapped(cell: LocationsCell)
}

class LocationsCell: UITableViewCell {
    @IBOutlet var locationNameLabel: UILabel!
    @IBOutlet var locationMapView: MKMapView!
    @IBOutlet var locationAddressNameLabel: UILabel!
    @IBOutlet var locationAddressLabel: UILabel!
    @IBOutlet var locationZipCodePlaceLabel: UILabel!
    @IBOutlet var locationPhoneNumberLabel: UILabel!
    @IBOutlet var locationEmailLabel: UILabel!
    @IBOutlet var locationWebsiteLabel: UILabel!
    
    static let identifier = "LocationsCell"
    static let bacKGroundColors = [#colorLiteral(red: 1, green: 0.4083568454, blue: 0.251519829, alpha: 1), #colorLiteral(red: 0, green: 0.7605165839, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.8486332297, blue: 0.249439925, alpha: 1), #colorLiteral(red: 0, green: 0.8078528643, blue: 0.427520901, alpha: 1), #colorLiteral(red: 0.506552279, green: 0.5065647364, blue: 0.5065580606, alpha: 1)]
    
    var delegate: LocationCellDelegate?
    var tapAction: ((UITableViewCell) -> Void)?
    
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
            self.locationEmailLabel.text = model.email
            self.locationWebsiteLabel.text = model.website
            self.locationMapView.region = model.region
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.locationPhoneNumberLabel.addGestureRecognizer(createTapGestureRecognizer())
        self.locationEmailLabel.addGestureRecognizer(createTapGestureRecognizer())
        self.locationWebsiteLabel.addGestureRecognizer(createTapGestureRecognizer())
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    fileprivate func createTapGestureRecognizer() -> UITapGestureRecognizer {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapWasDetected))
        return tapGestureRecognizer
    }
    
    func tapWasDetected(sender: UITapGestureRecognizer) {
        if let delegate = delegate {
            if sender.view == self.locationPhoneNumberLabel {
                delegate.phoneLabelWasTapped(cell: self)
            }
            else if sender.view == self.locationEmailLabel {
                delegate.emailLabelWasTapped(cell: self)
            }
            else {
                delegate.websiteLabelWasTapped(cell: self)
            }
        }
    }
    
    func addAnnotation() {
        if let model = model {
            let location = model.region.center
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            self.locationMapView.addAnnotation(annotation)
        }
    }
    @IBAction func pickUpServiceButtonTapped(_ sender: Any) {
        if let tapAction = self.tapAction {
            tapAction(self)
        }
    }
}

extension LocationsCell {
    struct Model {
        let name: String
        let address: String
        let zipCodePlace: String
        let phoneNumber: String
        let email: String?
        let website: String?
        let region: MKCoordinateRegion
        
        init(location: RecyQLocation) {
            self.name = location.name
            self.address = location.address
            self.zipCodePlace = location.postalCodePlace
            self.phoneNumber = location.phoneNumber
            self.email = location.email
            self.website = location.websiteURL
            self.region = location.setUpMapRegionForRecyQLocation()
        }
    }
}
