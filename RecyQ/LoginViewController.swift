//
//  LoginViewController.swift
//  RecyQ
//
//  Created by Jim Petri on 21/03/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit

var currentUser: User?

// We need to remove this global variable after the coupons code is updated.
var reachability: Reachability?

class LoginViewController: UIViewController {
    
    // MARK: - OUtlets
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    
    // MARK: - View life cycles.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
        self.addKeyboardNotificationObserver()
        
        self.textFieldLoginEmail.delegate = self
        self.textFieldLoginPassword.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Check if there's an internet connection
        ReachabilityHelper.checkReachability(viewController: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardNotificationObserver()
    }
    
    private func setupViews() {
        self.textFieldLoginEmail.addBorderWith(width: 1, color: .lightGray)
        self.textFieldLoginPassword.addBorderWith(width: 1, color: .lightGray)
        self.loginButton.addBorderWith(width: 1, color: .darkGray)
        
        // Facebook log in button.
        let faceBookLogInButton = FBSDKLoginButton()
        faceBookLogInButton.delegate = self
        faceBookLogInButton.readPermissions = ["email", "public_profile"]
        faceBookLogInButton.frame = CGRect(x: 16, y: 30, width: (UIScreen.main.bounds.width - 32), height: 30)
        self.view.addSubview(faceBookLogInButton)
        
    }
    
    // MARK: - IBActions
    @IBAction func hideKeyBoardwhenViewIsTapped(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func loginButtonPressed(_ sender: AnyObject) {
        
        if self.textFieldLoginEmail.text == "" || self.textFieldLoginPassword.text == "" {
            self.showAlertWith(title: "Oeps", message: "Vul je e-mailadres en wachtwoord in.")
            
        } else {
            FirebaseHelper.logUserInWith(email: self.textFieldLoginEmail.text!, password: self.textFieldLoginPassword.text!, sender: self)
            self.textFieldLoginEmail.text = ""
            self.textFieldLoginPassword.text = ""
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: AnyObject) {
      //self.showSignUpAlert()
        let signUpVC = SignUpViewController(nibName: "SignUpViewController", bundle: nil)
        let navigationController = UINavigationController(rootViewController: signUpVC)
        present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func wachtwoordVergetenButtonPressed(_ sender: Any) {
        self.showWachtwoordVergetenAlert()
    }
    
    private func showWachtwoordVergetenAlert() {
        let alert = UIAlertController(title: "Wachtwoord vergeten?", message: "Voer uw e-mailadres in. U ontvangt hierop een nieuw wachtwoord", preferredStyle: .alert)
        
        alert.addTextField { (textEmail) -> Void in
            textEmail.placeholder = "Voer uw e-mailadres in"
            textEmail.keyboardType = .emailAddress
        }
        let resetPasswordAction = UIAlertAction(title: "Reset wachtwoord", style: .default) { (action: UIAlertAction) -> Void in
            let userEmailField = alert.textFields![0]
            FirebaseHelper.sendRequestForPasswordResetWith(email: userEmailField.text!, sender: self)
        }
        let cancelAction = UIAlertAction(title: "Annuleer", style: .default) { (action: UIAlertAction) -> Void in
        }
        alert.addAction(resetPasswordAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

// MARK: Facebook login delegate methods
extension LoginViewController: FBSDKLoginButtonDelegate {
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print("Error loggin in to facebook \(error)")
            return
        }
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, first_name, last_name, email, picture.type(large)"]).start { (connection, result, err) in
            print("Result is :\(result)")
            self.addFacebookUserToFireBase(result: result)

        }
        print("Successfully logged in to facebook \(result)")
        //FirebaseHelper.observeAuthentication()

    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did logout from facebook")
    }
    
    func addFacebookUserToFireBase(result: Any?) {
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else {
            return
        }
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                print("Something went wrong with FB user login: \(error)")
            }
            else {
                
                if let result = result as? NSDictionary, let firstName = result["first_name"] as? String, let lastName = result["last_name"] as? String {
                    
                    FirebaseHelper.References.clientsRef.queryOrdered(byChild: "uid").queryEqual(toValue: user?.uid).observe(.value, with: { (snapShot) in
                        
                        if snapShot.value is NSNull {
                            currentUser = User(name: (firstName.lowercased()), lastName: lastName, address: "", zipCode: "", city: "", phoneNumber: "", addedByUser: (user?.email)!, nearestWasteLocation: "", completed: false, amountOfPlastic: 0, amountOfPaper: 0, amountOfTextile: 0, amountOfEWaste: 0, amountOfBioWaste: 0, amountOfGlass: 0, wasteDepositInfo: nil, uid: (user?.uid)!, spentCoins: 0)
                            
                            let userRef = FirebaseHelper.References.clientsRef.child((currentUser?.name)!)
                            userRef.setValue(currentUser?.toAnyObject())
                        }
                    })
                }
                print("FB user logged in suceccfully: \(user)")
                
                if let fbCurrentUser = user {
                    FirebaseHelper.queryOrderedBy(child: "uid", value: fbCurrentUser.uid, completionHandler: { (fbUser) in
                        
                    })
                }
            }
        })
    }
}

extension LoginViewController: UITextFieldDelegate {
    // MARK: - TextField delegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

