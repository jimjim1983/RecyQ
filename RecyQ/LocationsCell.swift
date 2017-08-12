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
    static let bacKGroundColors = [#colorLiteral(red: 0.2549019608, green: 0.5294117647, blue: 0.2431372549, alpha: 1), #colorLiteral(red: 1, green: 0.7764705882, blue: 0.1529411765, alpha: 1), #colorLiteral(red: 0, green: 0.4392156863, blue: 0.8039215686, alpha: 1), #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), #colorLiteral(red: 1, green: 0.4196078431, blue: 0.0431372549, alpha: 1)] 
    
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
