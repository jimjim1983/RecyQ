//
//  NewStatsViewController.swift
//  RecyQ
//
//  Created by Supervisor on 03-03-17.
//  Copyright © 2017 Jimsalabim. All rights reserved.
//

import UIKit

class NewStatsViewController: UIViewController {
    
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var naviagtionItem: UINavigationItem!
    @IBOutlet var kiloGramView: UIView!
    @IBOutlet var tokenView: UIView!
    @IBOutlet var statsCollectionView: UICollectionView!
    
    let statsCellWidth: CGFloat! = nil
    let statsCellHeight: CGFloat! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statsCell = UINib.init(nibName: "StatsCell", bundle: nil)
        self.statsCollectionView.register(statsCell, forCellWithReuseIdentifier: StatsCell.identifier)
        self.statsCollectionView.dataSource = self
        self.statsCollectionView.delegate = self

        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 30))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "recyq_logo_s_RGB")
        imageView.image = image
        self.navigationBar.topItem?.titleView = imageView
        
        self.kiloGramView.addBorderwith(width: 1, color: .black)
        self.tokenView.addBorderwith(width: 1, color: .black)
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
        cell.wasteAmount = " 00000.0 KG"
        cell.co2Amount = " 12345.0 KG"
        return cell
    }
}

extension NewStatsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.statsCollectionView.bounds.width - 32, height: 100.0)
    }
}
