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

class LoginViewController: UIViewController, UITextFieldDelegate {
    
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
    
    // MARK: - Keyboard methods
    private func addKeyboardNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func removeKeyboardNotificationObserver() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    
    // Keyboard will hide
    func keyboardWillHide(_ sender: Notification) {
        let userInfo: [AnyHashable: Any] = sender.userInfo!
        let keyboardSize: CGSize = (userInfo[UIKeyboardFrameBeginUserInfoKey]! as AnyObject).cgRectValue.size
        self.view.frame.origin.y += keyboardSize.height
    }
    
    // Keyboard will show
    func keyboardWillShow(_ sender: Notification) {
        let userInfo: [AnyHashable: Any] = sender.userInfo!
        
        let keyboardSize: CGSize = (userInfo[UIKeyboardFrameBeginUserInfoKey]! as AnyObject).cgRectValue.size
        let offset: CGSize = (userInfo[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size
        
        if keyboardSize.height == offset.height {
            if self.view.frame.origin.y == 0 {
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    self.view.frame.origin.y -= keyboardSize.height
                })
            }
        } else {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.view.frame.origin.y += keyboardSize.height - offset.height
            })
        }
        print(self.view.frame.origin.y)
    }
    
    // MARK: - TextField delegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
    
    //MARK: - Alerts
    private func showSignUpAlert() {
        
        let alert = UIAlertController(title: "Maak een nieuwe RecyQ account.", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textUsername) -> Void in
            textUsername.placeholder = "Gebruikersnaam"
        }
        alert.addTextField { (textEmail) -> Void in
            textEmail.placeholder = "E-mailadres"
            textEmail.keyboardType = .emailAddress
        }
        alert.addTextField { (textPassword) -> Void in
            textPassword.placeholder = "Wachtwoord"
            textPassword.isSecureTextEntry = true
        }
        let saveAction = UIAlertAction(title: "Opslaan", style: .default) { (action: UIAlertAction) -> Void in
            let usernameField = alert.textFields![0]
            let emailField = alert.textFields![1]
            let passwordField = alert.textFields![2]
            
            if let userName = usernameField.text, let email = emailField.text, let password = passwordField.text {
                FirebaseHelper.signUpUserWith(userName: userName, email: email, password: password, sender: self)
            }
        }
        let cancelAction = UIAlertAction(title: "Annuleer", style: .default) { (action: UIAlertAction) -> Void in
        }
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        present(alert, animated: true, completion: nil)
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
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
            print("Result is :\(result)")
            
        }
    
        print("Successfully logged in to facebook \(result)")
        FirebaseHelper.observeAuthentication()
        self.addFacebookUserToFireBase()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did logout from facebook")
    }
    
    func addFacebookUserToFireBase() {
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
                print("FB user logged in suceccfully: \(user)")
                
                if let fbCurrentUser = user {
                    currentUser = User(name: (fbCurrentUser.displayName?.lowercased())!, addedByUser: (fbCurrentUser.email)!, completed: false, amountOfPlastic: 0, amountOfPaper: 0, amountOfTextile: 0, amountOfEWaste: 0, amountOfBioWaste: 0, uid: (user?.uid)!, spentCoins: 0)
                    
                    let userRef = FirebaseHelper.References.clientsRef.child((currentUser?.name)!)
                    userRef.setValue(currentUser?.toAnyObject())
                    
//                    if let newUserName = currentUser?.name {
//                        self.username = newUserName
//                        print(self.username as Any)
//                    }
//                    self.userUID = currentUser?.uid
                }
            }
        })
    }
}

