//
//  LocationsViewController.swift
//  RecyQ
//
//  Created by Supervisor on 14-04-17.
//  Copyright © 2017 Jimsalabim. All rights reserved.
//

import UIKit
import MapKit

class LocationsViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    fileprivate let locationsCell = UINib.init(nibName: "LocationsCell", bundle: nil)
    var recyqLocations: [RecyQLocation]!
    let zeroWasteLocation = CLLocationCoordinate2DMake(52.297375, 4.987511)
    let deHandreikingLocation = CLLocationCoordinate2DMake(52.310962, 4.952540)
    let casaJepieMakandraLocation = CLLocationCoordinate2DMake(52.297741, 4.964569)
    let multiBronLocation = CLLocationCoordinate2DMake(52.322499, 4.942874)
    
    
    let span = MKCoordinateSpanMake(0.002, 0.002)
    
    var region: MKCoordinateRegion!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        self.navigationItem.title = "Locaties"
        
        self.tableView.register(self.locationsCell, forCellReuseIdentifier: LocationsCell.identifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.allowsSelection = false
        
        //self.region = MKCoordinateRegionMake(location, span)
        
        self.recyqLocations = setupWasteLocations()
    }
    
    func setupWasteLocations() -> [RecyQLocation] {
        let zeroWasteStore = RecyQLocation(district: NearestWasteLocation(rawValue: NearestWasteLocation.amsterdamsePoort.rawValue)! , name: "Zero Waste Store", nameLabelBackroundColor: #colorLiteral(red: 0, green: 0.8078528643, blue: 0.427520901, alpha: 1), address: "Bijlmerplein 858", postalCodePlace: "1102 ME Amsterdam", region: MKCoordinateRegionMake(zeroWasteLocation, span))
        let handReiking = RecyQLocation(district: NearestWasteLocation(rawValue: NearestWasteLocation.hBuurt.rawValue)! , name: "De Handreiking", nameLabelBackroundColor: #colorLiteral(red: 1, green: 0.8486332297, blue: 0.249439925, alpha: 1), address: "Haardstee 15", postalCodePlace: "1102 NB Amsterdam", region: MKCoordinateRegionMake(deHandreikingLocation, span))
        let casaJepieMakandra = RecyQLocation(district: NearestWasteLocation(rawValue: NearestWasteLocation.holendrecht.rawValue)! , name: "Casa Jepie Makandra", nameLabelBackroundColor: #colorLiteral(red: 0, green: 0.7605165839, blue: 1, alpha: 1), address: "Opheusdenhof 112", postalCodePlace: "1106 TW Amsterdam", region: MKCoordinateRegionMake(casaJepieMakandraLocation, span))
        let multiBron = RecyQLocation(district: NearestWasteLocation(rawValue: NearestWasteLocation.venserpolder.rawValue)! , name: "Multibron", nameLabelBackroundColor: #colorLiteral(red: 1, green: 0.4083568454, blue: 0.251519829, alpha: 1), address: "Alber Camuslaan 103A", postalCodePlace: "1102 WG Amsterdam", region: MKCoordinateRegionMake(multiBronLocation, span))
        let locations = [zeroWasteStore, handReiking, casaJepieMakandra, multiBron]
        return locations
    }
}

extension LocationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recyqLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: LocationsCell.identifier, for: indexPath) as! LocationsCell
       
        let location = recyqLocations[indexPath.row]
        cell.model = LocationsCell.Model(location: location)
        //cell.region = location.region
        return cell
    }
}

extension LocationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
}

