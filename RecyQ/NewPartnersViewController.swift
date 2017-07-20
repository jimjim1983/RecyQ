//
//  NewPartnersViewController.swift
//  RecyQ
//
//  Created by Supervisor on 06-07-17.
//  Copyright © 2017 Jimsalabim. All rights reserved.
//

import UIKit

class NewPartnersViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var zeroWasteLogoImageView: UIImageView!
    @IBOutlet var recyqLogoImageView: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var textView: UITextView!
    
    fileprivate let partnerCell = UINib.init(nibName: "PartnerCell", bundle: nil)
    fileprivate var partners = [RecyQPartner]()
    
     let textToAnimate = "Afval scheiden loont. Niet alleen voor de wereld maar ook voor de portemonnee en je buurt. Afval is geen afval maar de basis voor wat nieuws. Door bewuster om te gaan met grondstoffen heb je veel voordelen. Afval verbranden kost geld en is slecht voor het milieu. Wees daarom bewust over wat je weggooit. RecyQ biedt via haar partners verschillende initiatieven waar aan je mee kan doen."


    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Partners"
        self.activityIndicator.stopAnimating()
        self.tableView.alpha = 0
        self.zeroWasteLogoImageView.alpha = 0
        self.recyqLogoImageView.alpha = 0
        
        let informationBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "profileGrey"), style: .plain, target: self, action: #selector(showText))
        informationBarButtonItem.tintColor = .lightGray
        self.navigationItem.setRightBarButton(informationBarButtonItem, animated: true)

        UIView.animate(withDuration: 2, animations: {
            self.zeroWasteLogoImageView.alpha = 1
        }) { (finished) in
            UIView.animate(withDuration: 1, animations: {
                self.textView.setTextWithTypeAnimation(typedText: self.textToAnimate, characterInterval: 0.075, completion: {
//print(123) 
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 1, animations: {
                            self.recyqLogoImageView.alpha = 1
                        }, completion: { (finished) in
                            UIView.animate(withDuration: 1, animations: {
                                self.zeroWasteLogoImageView.alpha = 0
                                self.textView.alpha = 0
                                self.recyqLogoImageView.alpha = 0
                            }, completion: { (finished) in
                                UIView.animate(withDuration: 1, animations: {
                                    self.tableView.alpha = 1
                                })
                            })
                        })
                    }
                
                    
                })
            })
        }
        let wormenHotel = RecyQPartner(name: "Wormen Hotel", image: #imageLiteral(resourceName: "Wormenhotel"), description: "Meld je aan voor een Wormenhotel-Buurtcompost in jouw buurt!")
        let recyQJeans = RecyQPartner(name: "RecyQ Denim Bags", image: #imageLiteral(resourceName: "Spijkerbroek"), description: "Laat je oude spijkerbroek upcyclen tot hippe en duurzame denim tas!")//"RecyQ Jeans"
        let weesFiets = RecyQPartner(name: "Go-Upcycle!", image: #imageLiteral(resourceName: "Weesfiets"), description: "Meld je aan voor een exclusieve Fietsdepot weesfiets. Volledig opgeknapt voor een scherpe prijs!")//"Wees Fiets"
        let plasticFantastic = RecyQPartner(name: "Plastic Fantastic Workshop", image: #imageLiteral(resourceName: "PlasticFantastic"), description: "Meld je aan voor de Plastic Fantastic  Workshop. Creatief met plastic!")//"Plastic Fantastic"
        self.partners.append(wormenHotel)
        self.partners.append(recyQJeans)
        self.partners.append(weesFiets)
        self.partners.append(plasticFantastic)

        self.tableView.register(self.partnerCell, forCellReuseIdentifier: PartnerCell.identifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self

    }
    
    func showText() {
        self.textView.alpha = 1
        self.textView.isHidden = !self.textView.isHidden
    }

}

extension NewPartnersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return partners.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PartnerCell.identifier, for: indexPath) as! PartnerCell
        let partner = self.partners[indexPath.row]
        cell.partnerNameLabel.text = " " + partner.name
        cell.partnerNameLabel.backgroundColor = PartnerCell.bacKGroundColors[indexPath.row]
        cell.partnerImageView.image = partner.image
        cell.partnerDescription.text = partner.description
        return cell
    }
}

//MARK: - Tableview delegate methods.
extension NewPartnersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 262
    }
}
