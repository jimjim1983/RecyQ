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
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var zipCodeTextField: UITextField!
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var phoneNumberTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passWordTextField: UITextField!
    @IBOutlet var nearestLocationTextField: UITextField!
    @IBOutlet var signUpButton: UIButton!
    
    var wasteLocations = [NearestWasteLocation]()
    let locationsPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        self.addKeyboardNotificationObserver()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardNotificationObserver()
    }
    
    fileprivate func setupViews() {
        self.navigationItem.title = "Registreer"

        self.wasteLocations = [.amsterdamsePoort, .hBuurt, .holendrecht, .venserpolder]
        self.locationsPickerView.delegate = self
        self.nearestLocationTextField.inputView = self.locationsPickerView
        
        let cancelButton = UIBarButtonItem(title: "Annuleer", style: .plain, target: self, action: #selector(dismissVC))
        self.navigationItem.setLeftBarButton(cancelButton, animated: true)
        
        for textField in self.textFields {
            textField.delegate = self
            textField.addBorderWith(width: 1, color: .lightGray)
        }
        signUpButton.addBorderWith(width: 1, color: .darkGray)
    }
    
    func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func createNewUser() -> User {
        let newUser = User(name: nameTextField.text!, lastName: lastNameTextField.text!, address: addressTextField.text!, zipCode: zipCodeTextField.text!, city: cityTextField.text!, phoneNumber: phoneNumberTextField.text!, addedByUser: emailTextField.text!, nearestWasteLocation: NearestWasteLocation(rawValue: nearestLocationTextField.text!)!.rawValue, completed: false, amountOfPlastic: 0, amountOfPaper: 0, amountOfTextile: 0, amountOfEWaste: 0, amountOfBioWaste: 0, wasteDepositInfo: ["":""], uid: "", spentCoins: 0)
        return newUser
    }
    
    // MARK: - IBActions
    @IBAction func hideKeyBoardwhenViewIsTapped(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        for textField in textFields {
            guard textField.text != "" else {
                showAlertWith(title: " \(textField.placeholder!) is niet ingevuld", message: "Zorg ervoor dat alle velden ingevuld zijn.")
                return
            }
        }
        FirebaseHelper.signUp(newUser: createNewUser(), withPassword: passWordTextField.text!, sender: self)
    }
}

// MARK: - TextField delegate methods
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = textField.superview?.viewWithTag(textField.tag + 1) {
            nextTextField.becomeFirstResponder()
        } else {
        textField.resignFirstResponder()
        }
        return true
    }
}

// MARK: - PickerView datasource methods
extension SignUpViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return wasteLocations.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return wasteLocations[row].rawValue
    }
}

// MARK: - PickerView delegate methods
extension SignUpViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.nearestLocationTextField.text = wasteLocations[row].rawValue
    }
}
