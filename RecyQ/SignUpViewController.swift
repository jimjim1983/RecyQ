//
//  SignUpViewController.swift
//  RecyQ
//
//  Created by Supervisor on 01-04-17.
//  Copyright © 2017 Jimsalabim. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet var signUpButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Registreer"
        
        let cancelButton = UIBarButtonItem(title: "Annuleer", style: .plain, target: self, action: #selector(dismissVC))
        self.navigationItem.setLeftBarButton(cancelButton, animated: true)
        
        for textField in self.textFields {
            textField.addBorderWith(width: 1, color: .lightGray)
        }
        signUpButton.addBorderWith(width: 1, color: .darkGray)
    }
    
    func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
    }
}
