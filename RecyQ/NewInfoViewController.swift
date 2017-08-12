//
//  NewInfoViewController.swift
//  RecyQ
//
//  Created by Supervisor on 06-07-17.
//  Copyright © 2017 Jimsalabim. All rights reserved.
//

import UIKit

class NewInfoViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var zeroWasteLogoImageView: UIImageView!
    @IBOutlet var recyqLogoImageView: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var textView: UITextView!
    
    fileprivate let userDefaults = UserDefaults.standard
    fileprivate let infoCell = UINib.init(nibName: "InfoCell", bundle: nil)
    fileprivate var partners = [RecyQPartner]()
    
     let textToAnimate = "Afval scheiden loont. Niet alleen voor de wereld maar ook voor de portemonnee en je buurt. Afval is geen afval maar de basis voor wat nieuws. Door bewuster om te gaan met grondstoffen heb je veel voordelen. Afval verbranden kost geld en is slecht voor het milieu. Wees daarom bewust over wat je weggooit. RecyQ biedt via haar partners verschillende initiatieven waar aan je mee kan doen."

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        if !self.userDefaults.bool(forKey: "animateOrNot") {
            self.tableView.alpha = 0
            self.zeroWasteLogoImageView.alpha = 0
            self.recyqLogoImageView.alpha = 0
            animateTextView()
        } else {
            self.tableView.alpha = 1
            self.zeroWasteLogoImageView.alpha = 0
            self.recyqLogoImageView.alpha = 0
            self.textView.alpha = 0
        }
    }
    
    fileprivate func setupViews() {
        self.activityIndicator.stopAnimating()
        addInformtionBarButtonItem()
        setupTableView()
        addRecyQInitiatives()
    }
    
    fileprivate func setupTableView() {
        self.tableView.register(self.infoCell, forCellReuseIdentifier: InfoCell.identifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    fileprivate func addRecyQInitiatives() {
        let wormenHotel = RecyQPartner(name: "Wormen Hotel", image: #imageLiteral(resourceName: "Wormenhotel"), description: "Meld je aan voor een Wormenhotel-Buurtcompost in jouw buurt!", urlString: "")
        let recyQJeans = RecyQPartner(name: "RecyQ Denim Bags", image: #imageLiteral(resourceName: "Spijkerbroek"), description: "Laat je oude spijkerbroek upcyclen tot hippe en duurzame denim tas!", urlString: "")
        let weesFiets = RecyQPartner(name: "Go-Upcycle!", image: #imageLiteral(resourceName: "Weesfiets"), description: "Meld je aan voor een exclusieve Fietsdepot weesfiets. Volledig opgeknapt voor een scherpe prijs!", urlString: "")
        let plasticFantastic = RecyQPartner(name: "Plastic Fantastic Workshop", image: #imageLiteral(resourceName: "PlasticFantastic"), description: "Meld je aan voor de Plastic Fantastic  Workshop. Creatief met plastic!", urlString: "")
        self.partners.append(wormenHotel)
        self.partners.append(recyQJeans)
        self.partners.append(weesFiets)
        self.partners.append(plasticFantastic)
    }
    
    fileprivate func addInformtionBarButtonItem() {
        let informationBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "info-icon"), style: .plain, target: self, action: #selector(showText))
        informationBarButtonItem.tintColor = .lightGray
        informationBarButtonItem.setBackgroundImage(#imageLiteral(resourceName: "info-icon"), for: .selected, barMetrics: .default)
        self.navigationItem.setRightBarButton(informationBarButtonItem, animated: true)
    }
}

//MARK: - Tableview data source methods.
extension NewInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return partners.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InfoCell.identifier, for: indexPath) as! InfoCell
        let partner = self.partners[indexPath.row]
        cell.partnerNameLabel.text = " " + partner.name
        cell.partnerNameLabel.backgroundColor = InfoCell.bacKGroundColors[indexPath.row]
        cell.partnerImageView.image = partner.image
        cell.partnerDescription.text = partner.description
        return cell
    }
}

//MARK: - Tableview delegate methods.
extension NewInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 262
    }
}

//MARK: - Animations.
extension NewInfoViewController {
    fileprivate func animateTextView() {
        UIView.animate(withDuration: 2, animations: {
            self.zeroWasteLogoImageView.alpha = 1
        }) { (finished) in
            UIView.animate(withDuration: 1, animations: {
                self.textView.setTextWithTypeAnimation(typedText: self.textToAnimate, characterInterval: 0.075, completion: {
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
                                    self.saveViewHasAnimatedToUserdefaults()
                                })
                            })
                        })
                    }
                    
                    
                })
            })
        }
    }
    
    fileprivate func saveViewHasAnimatedToUserdefaults() {
        if !self.userDefaults.bool(forKey: "animateOrNot") {
            self.userDefaults.set(true, forKey: "animateOrNot")
        } else {
            self.userDefaults.set(false, forKey: "animateOrNot")
        }
    }
    
    func showText() {
        if self.textView.alpha == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.zeroWasteLogoImageView.alpha = 1
                self.textView.text = self.textToAnimate
                self.textView.alpha = 1
                self.recyqLogoImageView.alpha = 1
                self.tableView.alpha = 0
            })
        }
        else {
            UIView.animate(withDuration: 0.5, animations: {
                self.zeroWasteLogoImageView.alpha = 0
                self.textView.alpha = 0
                self.recyqLogoImageView.alpha = 0
                self.tableView.alpha = 1
            })
        }
    }
}
