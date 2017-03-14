//
//  NavBarLogoImageView.swift
//  RecyQ
//
//  Created by Supervisor on 11-03-17.
//  Copyright © 2017 Jimsalabim. All rights reserved.
//

import UIKit

class NavBarLogoImageView: UIView {
    
    var imageView:UIImageView? {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        let image = UIImage(named: "recyq_logo_s_RGB")
        imageView.image = image
        
        return imageView
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 38, height: 30))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
