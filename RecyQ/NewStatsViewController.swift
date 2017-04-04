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
    
    fileprivate let navBarLogoImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 30))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "recyq_logo_s_RGB")
        imageView.image = image
        return imageView
    }()
    
    fileprivate let profileBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "profileGrey"), style: .plain, target: self, action: #selector(showProfile))
        barButtonItem.tintColor = .lightGray
        return barButtonItem
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
                })
            }
        }
    }
    
    fileprivate func setupViews() {
        self.navigationController?.navigationBar.topItem?.titleView = self.navBarLogoImageView
        self.navigationItem.setRightBarButton(self.profileBarButton, animated: true)
        
        self.kiloGramView.addBorderWith(width: 1, color: .darkGray)
        self.tokenView.addBorderWith(width: 1, color: .darkGray)
        
        
        // Colors the range of arrows in the label
        self.tokenArrowsString = self.tokenArrowsLabel.text!
        self.coloredString = NSMutableAttributedString(string: self.tokenArrowsString, attributes: [NSForegroundColorAttributeName: #colorLiteral(red: 0, green: 0.8078528643, blue: 0.427520901, alpha: 1)])
        self.coloredString.addAttribute(NSForegroundColorAttributeName, value: #colorLiteral(red: 0, green: 0.8078528643, blue: 0.427520901, alpha: 1), range: NSRange(location: 1, length: 5))
//        self.tokenArrowsLabel.text = ""
    }
    
    func showProfile() {
        let profileVC = ProfileViewController()
        self.navigationController?.pushViewController(profileVC, animated: true)
        
    }
    
    private func scheduleLocalNotification() {
        let localNotification = UILocalNotification()
        localNotification.alertBody = "Time to recycle some waste"
        localNotification.alertAction = "Open"
        localNotification.fireDate = Date(timeIntervalSinceNow: 60)
        
        UIApplication.shared.scheduleLocalNotification(localNotification)
    }
    @IBAction func kiloGramButtonTapped(_ sender: Any) {
        print("KILO")
    }
    @IBAction func tokensButtonTapped(_ sender: Any) {
        print("TOKENS")
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
