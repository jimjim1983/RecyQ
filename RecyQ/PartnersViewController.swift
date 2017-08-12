//
//  PartnersViewController.swift
//  RecyQ
//
//  Created by Alyson Vivattanapa on 4/29/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit

class PartnersViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    fileprivate let partnerCell = UINib.init(nibName: "PartnerCell", bundle: nil)
    fileprivate var partners = [RecyQPartner]()
    
    override func viewWillAppear(_ animated: Bool) {
        title = "Partners"
        
        // Check if there's an internet connection
        ReachabilityHelper.checkReachability(viewController: self)
        setupTableView()
        self.partners = [
            RecyQPartner(name: "RecyQ", image: #imageLiteral(resourceName: "recyq_logo_s_RGB"), description: "", urlString: "http://zerowasteamsterdam.nl"),
            RecyQPartner(name: "Startup in residence", image: #imageLiteral(resourceName: "startupInResidence"), description: "", urlString: "http://www.startupinresidence.com/"),
            RecyQPartner(name: "Creative Associates", image: #imageLiteral(resourceName: "Creative Associates"), description: "", urlString: "http://creativeassociates.nl"),
            RecyQPartner(name: "Go-Upcycle!", image: #imageLiteral(resourceName: "Go-Upcycle!"), description: "", urlString: ""),
            RecyQPartner(name: "VSB fonds", image: #imageLiteral(resourceName: "VSBfonds"), description: "", urlString: "https://www.vsbfonds.nl"),
            RecyQPartner(name: "Buurtwerkkamers", image: #imageLiteral(resourceName: "Buurtwerkkamercooperatie"), description: "", urlString: "https://buurtwerkkamer.nl"),
            RecyQPartner(name: "Zuidoost TV", image: #imageLiteral(resourceName: "Zuidoost TV"), description: "", urlString: "https://www.zuidoost.tv"),
            RecyQPartner(name: "Fawaka Nederland", image: #imageLiteral(resourceName: "Fawaka Nederland Logo"), description: "", urlString: "http://www.fawakanederland.nl"),
            RecyQPartner(name: "Amsterdam loves bikes", image: #imageLiteral(resourceName: "Amsterdam Loves Bikes"), description: "", urlString: "https://www.amsterdam.nl/parkeren-verkeer/fiets/fietsdepot/")
        ]
    }
    
    fileprivate func setupTableView() {
        self.tableView.register(self.partnerCell, forCellReuseIdentifier: PartnerCell.identifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
}

extension PartnersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.partners.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PartnerCell.identifier, for: indexPath) as! PartnerCell
        
        let partner = self.partners[indexPath.row]
        cell.partnerNameLabel.text = " " + partner.name
        cell.partnerImageView.image = partner.image
        return cell
    }
}

//MARK: - Tableview delegate methods.
extension PartnersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let partner = partners[indexPath.row]
        if let url = URL(string: partner.urlString) {
            UIApplication.shared.openURL(url)
        }
    }
}
