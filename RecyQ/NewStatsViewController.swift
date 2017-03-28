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
    @IBOutlet var tokenArrowsLabel: UILabel!
    @IBOutlet var statsCollectionView: UICollectionView!
    
    fileprivate let statsCell = UINib.init(nibName: "StatsCell", bundle: nil)
    fileprivate let statsCellWidth: CGFloat! = nil
    fileprivate let statsCellHeight: CGFloat! = nil
    fileprivate var tokenArrowsString = String()
    fileprivate var coloredString = NSMutableAttributedString()
    fileprivate var wasteAmounts = [Double]()
    fileprivate var co2Amounts = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.statsCollectionView.register(statsCell, forCellWithReuseIdentifier: StatsCell.identifier)
        self.statsCollectionView.dataSource = self
        self.statsCollectionView.delegate = self

        setupViews()
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
                    self.wasteAmounts.append(user.amountOfIron)

                    self.co2Amounts = self.wasteAmounts.map { round((round($0) / 35) * 50) }
                    self.statsCollectionView.reloadData()
                })
            }
        }
    }
    
    fileprivate func setupViews() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 30))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "recyq_logo_s_RGB")
        imageView.image = image
        self.navigationBar.topItem?.titleView = imageView
        
        self.kiloGramView.addBorderWith(width: 1, color: .darkGray)
        self.tokenView.addBorderWith(width: 1, color: .darkGray)
        
        // Colors the range of arrows in the label
        self.tokenArrowsString = self.tokenArrowsLabel.text!
        self.coloredString = NSMutableAttributedString(string: self.tokenArrowsString, attributes: [NSForegroundColorAttributeName: #colorLiteral(red: 0, green: 0.8078528643, blue: 0.427520901, alpha: 1)])
        self.coloredString.addAttribute(NSForegroundColorAttributeName, value: #colorLiteral(red: 0, green: 0.8078528643, blue: 0.427520901, alpha: 1), range: NSRange(location: 1, length: 5))
//        self.tokenArrowsLabel.text = ""
    }
}

extension NewStatsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
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
