//
//  NewStatsViewController.swift
//  RecyQ
//
//  Created by Supervisor on 03-03-17.
//  Copyright © 2017 Jimsalabim. All rights reserved.
//

import UIKit
import FirebaseAuth

class NewStatsViewController: UIViewController {
    
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var naviagtionItem: UINavigationItem!
    @IBOutlet var kiloGramView: UIView!
    @IBOutlet var tokenView: UIView!
    @IBOutlet var kiloGramLabel: UILabel!
    @IBOutlet var tokensLabel: UILabel!
    @IBOutlet var tokenArrowsLabel: UILabel!
    @IBOutlet var statsCollectionView: UICollectionView!
    
    @IBOutlet var co2AmountLabel: UILabel!
    
    fileprivate let statsCell = UINib.init(nibName: "StatsCell", bundle: nil)
    fileprivate let statsCellWidth: CGFloat! = nil
    fileprivate let statsCellHeight: CGFloat! = nil
    fileprivate var tokenArrowsString = String()
    fileprivate var coloredString = NSMutableAttributedString()
    fileprivate var wasteAmounts = [Double]()
    fileprivate var co2Amounts = [Double]()
    fileprivate var totalWasteAmounts: Double!
    fileprivate var kiloGramsTurnedIn: Double!
    fileprivate var tokensEarned: Double!
    fileprivate var missingInformationAlert = UIAlertController()
    fileprivate var dataSource: PickerViewDataSource!
    fileprivate let locationsPickerView = UIPickerView()

    var recyQLocations = [NearestWasteLocation]()
    
    fileprivate let navBarLogoImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 30))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "recyq_logo_s_RGB")
        imageView.image = image
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.statsCollectionView.register(statsCell, forCellWithReuseIdentifier: StatsCell.identifier)
        self.statsCollectionView.dataSource = self
        self.statsCollectionView.delegate = self

        setupViews()
        scheduleLocalNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        FIRAuth.auth()!.addStateDidChangeListener { (auth, user) in
            if let user = user {
                FirebaseHelper.queryOrderedBy(child: "uid", value: user.uid, completionHandler: { (user) in
                    
                    self.wasteAmounts.removeAll()
                    
                    self.wasteAmounts.append(user.amountOfTextile)
                    self.wasteAmounts.append(user.amountOfPaper)
                    self.wasteAmounts.append(user.amountOfPlastic)
                    self.wasteAmounts.append(user.amountOfBioWaste)
                    self.wasteAmounts.append(user.amountOfEWaste)

                    self.co2Amounts = self.wasteAmounts.map { round((round($0) / 35) * 50) }
                    self.totalWasteAmounts = self.wasteAmounts.reduce(0.0, +)
                    self.tokensEarned = round(self.totalWasteAmounts / 35) - Double(user.spentCoins ?? 0)
                    if let totalWasteAmounts = self.totalWasteAmounts, let tokensEarned = self.tokensEarned {
                        self.kiloGramLabel.text = "\(totalWasteAmounts)"
                        self.tokensLabel.text = "\(Int(tokensEarned))"
                    }
                    self.statsCollectionView.reloadData()
                    if user.address == "" {
                        self.showMissingInformationAlert()
                    }
                })
            }
        }
    }
    
    fileprivate func setupViews() {
        self.navigationController?.navigationBar.topItem?.titleView = self.navBarLogoImageView
        
        let profileBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "profileGrey"), style: .plain, target: self, action: #selector(showProfile))
        profileBarButtonItem.tintColor = .lightGray
        self.navigationItem.setRightBarButton(profileBarButtonItem, animated: true)
        
        self.kiloGramView.addBorderWith(width: 1, color: .darkGray)
        self.tokenView.addBorderWith(width: 1, color: .darkGray)
        
        // Colors the range of arrows in the label
        self.tokenArrowsString = self.tokenArrowsLabel.text!
        self.coloredString = NSMutableAttributedString(string: self.tokenArrowsString, attributes: [NSForegroundColorAttributeName: #colorLiteral(red: 0, green: 0.8078528643, blue: 0.427520901, alpha: 1)])
        self.coloredString.addAttribute(NSForegroundColorAttributeName, value: #colorLiteral(red: 0, green: 0.8078528643, blue: 0.427520901, alpha: 1), range: NSRange(location: 1, length: 5))
//        self.tokenArrowsLabel.text = ""
        
        self.recyQLocations = [.amsterdamsePoort, .hBuurt, .holendrecht, .venserpolder]
        self.dataSource = PickerViewDataSource(wasteLocations: self.recyQLocations)
        self.locationsPickerView.dataSource = self.dataSource
        self.locationsPickerView.delegate = self
    }
    
    func showProfile() {
        let profileVC = ProfileViewController()
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    fileprivate func showMissingInformationAlert() {
        self.missingInformationAlert = UIAlertController(title: "Let op!", message: "We hebben nog wat aanvullende informatie van u nodig.", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Opslaan", style: .default) { (saveAction) in
            let addressField = self.missingInformationAlert.textFields![0]
            let zipCodeField = self.missingInformationAlert.textFields![1]
            let cityField = self.missingInformationAlert.textFields![2]
            let phoneNumberField = self.missingInformationAlert.textFields![3]
            let nearestWasteLocationField = self.missingInformationAlert.textFields![4]
            
            for textField in self.missingInformationAlert.textFields! {
                guard textField.text != "" else {
                    let alert = UIAlertController(title: " \(textField.placeholder!) is niet ingevuld", message: "Zorg ervoor dat alle velden ingevuld zijn.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (okAction) in
                        self.showMissingInformationAlert()
                    })
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
            currentUser?.address = addressField.text!
            currentUser?.zipCode = zipCodeField.text!
            currentUser?.city = cityField.text!
            currentUser?.phoneNumber = phoneNumberField.text!
            currentUser?.nearestWasteLocation = nearestWasteLocationField.text!
            
            let name = currentUser?.name
            let ref = FirebaseHelper.References.clientsRef.child(name!)
            ref.child("address").setValue(currentUser?.address)
            ref.child("zipCode").setValue(currentUser?.zipCode)
            ref.child("city").setValue(currentUser?.city)
            ref.child("phoneNumber").setValue(currentUser?.phoneNumber)
            ref.child("nearestWasteLocation").setValue(currentUser?.nearestWasteLocation)
            self.showAlertWith(title: "Bedankt.", message: "We zullen voorzichtig omgaan met uw gegevens.")
            self.checkIfFirstLaunch()
        }
        
        self.missingInformationAlert.addTextField { (addressField) in
            addressField.placeholder = "Adres en huisnummer"
            addressField.autocapitalizationType = .words
        }
        
        self.missingInformationAlert.addTextField { (zipCodeField) in
            zipCodeField.placeholder = "Postcode"
            zipCodeField.keyboardType = .numbersAndPunctuation
            zipCodeField.autocapitalizationType = .allCharacters
        }
        
        self.missingInformationAlert.addTextField { (cityField) in
            cityField.placeholder = "Woonplaats"
            cityField.autocapitalizationType = .words
        }
        
        self.missingInformationAlert.addTextField { (phoneNumberField) in
            phoneNumberField.placeholder = "Telefoonnummer"
            phoneNumberField.keyboardType = .phonePad
        }
        
        self.missingInformationAlert.addTextField { (nearestWasteLocationField) in
            nearestWasteLocationField.placeholder = "Selecteer een locatie"
            nearestWasteLocationField.inputView = self.locationsPickerView
        }
        
        self.missingInformationAlert.addAction(saveAction)
        
        present(self.missingInformationAlert, animated: true, completion: nil)
    }
    
    // Stil needs logic to set the date of the notification to 30 days after last waste deposit.
    private func scheduleLocalNotification() {
        let localNotification = UILocalNotification()
        localNotification.alertBody = "Je hebt al een maand niks gerecycled met RecyQ, ben je nog wel zero waste bezig? Breng binnen een week papier, textiel of plastic naar de dichts bijzijnde RecyQ locatie anders deactiveren we je account. No love lost!"
        localNotification.alertAction = "Open"
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.fireDate = Date(timeIntervalSinceNow: 60 * 60 * 24 * 30)
        localNotification.applicationIconBadgeNumber = 1
        
        UIApplication.shared.scheduleLocalNotification(localNotification)
    }
    
    @IBAction func kiloGramButtonTapped(_ sender: Any) {
        let co2ViewController = CO2ViewController()
        co2ViewController.co2Amount = self.kiloGramLabel.text
        co2ViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(co2ViewController, animated: true, completion: nil)
    }
    
    @IBAction func tokensButtonTapped(_ sender: Any) {
        let tokenVC = RecyQTokenViewController()
        tokenVC.tokenAmount = self.tokensLabel.text
        tokenVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(tokenVC, animated: true, completion: nil)
    }
}

extension NewStatsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatsCell.identifier, for: indexPath) as! StatsCell
        
        cell.backgroundColor = StatsCell.bacKGroundColors[indexPath.row]
        cell.wasteTypeLabel.text = StatsCell.wasteTypes[indexPath.row]
        if !self.wasteAmounts.isEmpty {
            cell.wasteAmount = "\(self.wasteAmounts[indexPath.row]) KG"
            cell.co2Amount = "\(self.co2Amounts[indexPath.row]) KG"
        }
        else {
            cell.wasteAmount = "00000.0 KG"
            cell.co2Amount = "00000.0 KG"
        }
        return cell
    }
}

extension NewStatsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.statsCollectionView.bounds.width - 32, height: 100.0)
    }
}

// MARK: - PickerView delegate methods
extension NewStatsViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return recyQLocations[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.missingInformationAlert.textFields?[4].text = recyQLocations[row].rawValue
    }
}
