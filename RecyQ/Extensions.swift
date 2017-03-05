//
//  Extensions.swift
//  RecyQ
//
//  Created by Supervisor on 26-02-17.
//  Copyright © 2017 Jimsalabim. All rights reserved.
//

import UIKit

// Shows an alert with title, message and an ok action.
extension UIViewController {
    func showAlertWith(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

// Ads aborder to a view.
extension UIView {
    func addBorderwith(width: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
}
