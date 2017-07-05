//
//  LocationsViewController.swift
//  RecyQ
//
//  Created by Supervisor on 14-04-17.
//  Copyright © 2017 Jimsalabim. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import MessageUI

class LocationsViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    fileprivate let locationsCell = UINib.init(nibName: "LocationsCell", bundle: nil)
    fileprivate var recyqLocations = [RecyQLocation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        getLoacationsFromFirebase()
        //self.navigationController?.hidesBarsOnSwipe = true
    }
    
    fileprivate func setupViews() {
        self.navigationItem.title = "Locaties"
        
        self.tableView.register(self.locationsCell, forCellReuseIdentifier: LocationsCell.identifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.allowsSelection = false
    }
    
    fileprivate func getLoacationsFromFirebase() {
        FirebaseHelper.References.ref.child("RecyQ Locations").observe(.value, with: { (snapshot) in
            var recyqLocations: [RecyQLocation] = []
            for location in snapshot.children {
                let recyqLocation = RecyQLocation(snapshot: location as! FIRDataSnapshot)
                recyqLocations.append(recyqLocation)
            }
            self.recyqLocations = recyqLocations
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        })
    }
}

//MARK: - Tableview datasource methods.
extension LocationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recyqLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: LocationsCell.identifier, for: indexPath) as! LocationsCell
       
        let location = recyqLocations[indexPath.row]
        cell.delegate = self
        cell.model = LocationsCell.Model(location: location)
        cell.locationNameLabel.backgroundColor = LocationsCell.bacKGroundColors[indexPath.row]
        cell.addAnnotation()
        return cell
    }
}

//MARK: - Tableview delegate methods.
extension LocationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
}

//MARK: - LocationCellDelegate methods.
extension LocationsViewController: LocationCellDelegate, MFMailComposeViewControllerDelegate {
    // Cals the phonenumber in the label when tapped.
    func phoneLabelWasTapped(cell: LocationsCell) {
        if let phoneNumber = cell.model?.phoneNumber {
            let phoneNumberWithoutWhiteSpaces = phoneNumber.replacingOccurrences(of: " ", with: "")
            if let phoneURL = URL(string: "telprompt://\(phoneNumberWithoutWhiteSpaces)") {
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
    // Loads a new email message that the user can send to the address in the label.
    func emailLabelWasTapped(cell: LocationsCell) {
        if let emailAddress = cell.model?.email {
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setToRecipients([emailAddress])
            mailVC.setSubject("RecyQ App")
            mailVC.setMessageBody("", isHTML: false)
            
            if MFMailComposeViewController.canSendMail() {
                present(mailVC, animated: true, completion: nil)
            }
        }
    }
    // Loads the website in the label when tapped.
    func websiteLabelWasTapped(cell: LocationsCell) {
        if let websiteURLString = cell.model?.website {
            if let websiteURL = URL(string: "http://\(websiteURLString)") {
                if UIApplication.shared.canOpenURL(websiteURL) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(websiteURL)
                    } else {
                        // Fallback on earlier versions
                        UIApplication.shared.openURL(websiteURL)
                    }
                }
            }
            
        }
    }
    // Dismisses the mailVC if a yser presses the cancel or send button.
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}

