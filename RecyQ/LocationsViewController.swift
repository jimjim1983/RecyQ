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

class LocationsViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    fileprivate let locationsCell = UINib.init(nibName: "LocationsCell", bundle: nil)
    var recyqLocations = [RecyQLocation]()
    let zeroWasteLocation = CLLocationCoordinate2DMake(52.297375, 4.987511)
    let deHandreikingLocation = CLLocationCoordinate2DMake(52.310962, 4.952540)
    let casaJepieMakandraLocation = CLLocationCoordinate2DMake(52.297741, 4.964569)
    let multiBronLocation = CLLocationCoordinate2DMake(52.322499, 4.942874)
    
    
    let span = MKCoordinateSpanMake(0.002, 0.002)
    
    var region: MKCoordinateRegion!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        //self.navigationController?.hidesBarsOnSwipe = true
        FirebaseHelper.References.ref.child("RecyQ Locations").observe(.value, with: { (snapshot) in
            var recyqLocations: [RecyQLocation] = []
            for location in snapshot.children {
                let recyqLocation = RecyQLocation(snapshot: location as! FIRDataSnapshot)
                recyqLocations.append(recyqLocation)
            }
            self.recyqLocations = recyqLocations
            self.tableView.reloadData()
//            let recyqLocationsDict = snapshot.value as? [String: AnyObject] ?? [:]
//            print(recyqLocationsDict)
//            for location in recyqLocationsDict {
//                guard let recyqLocation = RecyQLocation(snapshot: <#T##FIRDataSnapshot#>)
//            }
        })
    }
    
    func setupViews() {
        self.navigationItem.title = "Locaties"
        
        self.tableView.register(self.locationsCell, forCellReuseIdentifier: LocationsCell.identifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        //self.tableView.allowsSelection = false
        
        //self.region = MKCoordinateRegionMake(location, span)
        
        //self.recyqLocations = setupWasteLocations()
    }
    
//    func setupWasteLocations() -> [RecyQLocation] {
//        //let zeroWasteStore = RecyQLocation(district: NearestWasteLocation.amsterdamsePoort.rawValue, name: "Zero Waste Store", address: "Bijlmerplein 858", postalCodePlace: "1102 ME Amsterdam", latitude: 52.313833, longitude: 4.954351)
//        //let deHandreiking = RecyQLocation(district: NearestWasteLocation.hBuurt.rawValue, name: "De Handreiking", address: "Haardstee 15", postalCodePlace: "1102 NB Amsterdam", latitude: 52.310962, longitude: 4.952540)
//        //let casaJepieMakandra = RecyQLocation(district: NearestWasteLocation.holendrecht.rawValue, name: "Casa Jepie Makandra", address: "Opheusdenhof 112", postalCodePlace: "1106 TW Amsterdam", latitude: 52.297741, longitude: 4.964569)
//        //let multiBron = RecyQLocation(district: NearestWasteLocation.venserpolder.rawValue, name: "Multibron", address: "Alber Camuslaan 103A", postalCodePlace: "1102 WG Amsterdam", latitude: 52.322499, longitude: 4.942874)
//        
//        //RecyQLocation(district: NearestWasteLocation.amsterdamsePoort , name: "Zero Waste Store", /*nameLabelBackroundColor: #colorLiteral(red: 0, green: 0.8078528643, blue: 0.427520901, alpha: 1), */address: "Bijlmerplein 858", postalCodePlace: "1102 ME Amsterdam", region: MKCoordinateRegionMake(zeroWasteLocation, span))
//        //let handReiking = RecyQLocation(district: NearestWasteLocation(rawValue: NearestWasteLocation.hBuurt.rawValue)! , name: "De Handreiking", /*nameLabelBackroundColor: #colorLiteral(red: 1, green: 0.8486332297, blue: 0.249439925, alpha: 1),*/ address: "Haardstee 15", postalCodePlace: "1102 NB Amsterdam", region: MKCoordinateRegionMake(deHandreikingLocation, span))
//        //let casaJepieMakandra = RecyQLocation(district: NearestWasteLocation(rawValue: NearestWasteLocation.holendrecht.rawValue)! , name: "Casa Jepie Makandra",/* nameLabelBackroundColor: #colorLiteral(red: 0, green: 0.7605165839, blue: 1, alpha: 1),*/ address: "Opheusdenhof 112", postalCodePlace: "1106 TW Amsterdam", region: MKCoordinateRegionMake(casaJepieMakandraLocation, span))
//        //let multiBron = RecyQLocation(district: NearestWasteLocation(rawValue: NearestWasteLocation.venserpolder.rawValue)! , name: "Multibron", /*nameLabelBackroundColor: #colorLiteral(red: 1, green: 0.4083568454, blue: 0.251519829, alpha: 1),*/ address: "Alber Camuslaan 103A", postalCodePlace: "1102 WG Amsterdam", region: MKCoordinateRegionMake(multiBronLocation, span))
//        //let locations = [zeroWasteStore, deHandreiking, casaJepieMakandra, multiBron]
//        return locations
//    }
}

extension LocationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recyqLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: LocationsCell.identifier, for: indexPath) as! LocationsCell
       
        let location = recyqLocations[indexPath.row]
        cell.model = LocationsCell.Model(location: location)
        cell.locationNameLabel.backgroundColor = LocationsCell.bacKGroundColors[indexPath.row] // backGroundColors[indexPath.row]
        return cell
    }
}

extension LocationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
}

