
//
//  ProfileViewController.swift
//  RecyQ
//
//  Created by Jim Petri on 21/03/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit
import MapKit
import FBSDKLoginKit
import Firebase
import FirebaseAuth

class ProfileViewController: UIViewController, UITabBarDelegate {
    
    @IBOutlet var cameraIconImageView: UIImageView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var nameLabel: UILabel!
   
    var coupon: Coupon?
    var couponItems = [Coupon]()
    let couponsRef = FIRDatabase.database().reference(withPath: "coupons")
    var tapGestureRecogniser: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
            
        // Check if there's an internet connection
        ReachabilityHelper.checkReachability(viewController: self)
        
        // go trough all coupons and find the one with the same user uid, then add them to the array for the tableview
        self.couponsRef.queryOrdered(byChild: "ownerID").queryEqual(toValue: currentUser?.uid).observe(.value, with: { snapshot in
            var coupons = [Coupon]()
            if let couponsFromSnapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snapshot in couponsFromSnapshots {
                    let coupon = Coupon(snapshot: snapshot)
                    coupons.append(coupon)
                }
                self.couponItems = coupons.sorted{ $0.1.redemeed }
                self.tableView.reloadData()
            }
        })
    }
    
    fileprivate func setupViews() {
        self.navigationItem.title = "Profiel"
        
        let logOutBarButtonItem = UIBarButtonItem(title: "Log uit", style: .plain, target: self, action: #selector(logOut))
        self.navigationItem.setRightBarButton(logOutBarButtonItem, animated: true)
        
        self.tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(showCameraAlert))
        self.profileImageView.addGestureRecognizer(tapGestureRecogniser)
        
        self.profileImageView.addBorderWith(width: 1, color: .white)
        self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.size.width / 2
        self.profileImageView.clipsToBounds = true
        
        if let lastname = currentUser?.lastName {
            self.nameLabel.text = (currentUser?.name.capitalized)! + " " + lastname.capitalized
        }
        else {
            self.nameLabel.text = currentUser?.name.capitalized
        }
        let nib = UINib.init(nibName: "CouponsTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "cell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        loadProfileImage(pathComponent: "ProfileImage")
    }
    
    func logOut() {
        _ = self.navigationController?.popViewController(animated: true)
        // Check if the user is logged in via facebook
        if FBSDKAccessToken.current() != nil {
            
            // Log out from facebook
            FBSDKLoginManager().logOut()
            print("User has logged out from facebook")
        }
        
        // Log out from firebase
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            return
        }
        let loginVC = LoginViewController()
        Constants.appDelegate.window?.rootViewController = loginVC
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        
        // Check if the user is logged in via facebook
        if FBSDKAccessToken.current() != nil {
            
            // Log out from facebook
            FBSDKLoginManager().logOut()
            print("User has logged out from facebook")
        }
        
        // Log out from firebase
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            return
        }
        currentUser = nil
        
        let loginVC = LoginViewController()
        Constants.appDelegate.window?.rootViewController = loginVC
    }
}

// MARK: Tableview datasource methods
extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.couponItems.count > 0 {
            return couponItems.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CouponsTableViewCell
        
        if couponItems.count > 0 {
            let coupon = couponItems[indexPath.row]
            cell.shopItemName.text = coupon.couponName
            cell.shopName.text = coupon.shopName
            if coupon.redemeed {
                cell.shopItemName.alpha = 0.5
                cell.shopName.alpha = 0.5
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
            } else {
                cell.shopItemName.alpha = 1
                cell.shopName.alpha = 1
                cell.accessoryType = UITableViewCellAccessoryType.none
            }
        }
        else {
            cell.shopItemName.text = "U heeft nog geen coupons verdiend."
            cell.shopName.text = ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let titleHeader = "Uw verdiende coupons:"
        return titleHeader
    }
}

// MARK: Tableview delegate methods.
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Futura", size: 15)!
        header.textLabel?.textColor = UIColor.darkGray
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let coupon = couponItems[indexPath.row]
        if coupon.redemeed {
            return nil
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coupon = couponItems[indexPath.row]
        let name = coupon.couponName
        
        if name.contains("Donatie") {
            self.showAlertWith(title: "Bedankt voor uw donatie.", message: "Houd de Community pagina in de gaten om te zien wat er georganiseerd wordt.")
            self.couponsRef.child(coupon.uid).child("redeemed").setValue(true)
        } else {
            let alertController = UIAlertController(title: "Validatie vereist.", message: "Vraag de winkel eigenaar om zijn validatie code in te voeren.", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                let codeTextField = alertController.textFields![0]
                guard codeTextField.text != "" && codeTextField.text == String(coupon.validationCode) else {
                    self.showAlertWith(title: "Fout", message: "De ingevoerde code is niet correct.")
                    return
                }
                self.couponsRef.child(coupon.uid).child("redeemed").setValue(true)
                self.showAlertWith(title: "Bedankt!", message: "Het valideren van uw coupon is gelukt.")
            }
            alertController.addTextField{ (codeTextField) in
                codeTextField.delegate = self
                codeTextField.keyboardType = .numberPad
                codeTextField.isSecureTextEntry = true
                codeTextField.placeholder = "Voer hier de validatie code in."
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true) {
            }
        }
    }
}

// MARK: - UITetFieldDelegate functions.
extension ProfileViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField.allowsOnlyNumbers(text: string)
    }
}

// MARK: - Image picker functions.
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showCameraAlert() {
        let alert = UIAlertController(title: "Profiel foto", message: "", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (cameraAction) in
            print("Camera")
            self.showCameraOrMediaLibrary(sourceType: .camera)
      
        }
        
        let photoLibraryAction = UIAlertAction(title: "Foto bibliotheek", style: .default) { (photoLibraryAction) in
            print("Bibliotheek")
            self.showCameraOrMediaLibrary(sourceType: .photoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "Annuleer", style: .destructive) { (cancelAction) in
            print("annuleer")
        }
        
        alert.addAction(cameraAction)
        alert.addAction(photoLibraryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showCameraOrMediaLibrary(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        if sourceType == .camera {
            imagePicker.allowsEditing = false
        } else {
            imagePicker.allowsEditing = false
        }
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.profileImageView.image = image
        self.cameraIconImageView.isHidden = true
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
       
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let profileImage = image.fixOrientation()
            self.profileImageView.image = profileImage
            self.cameraIconImageView.isHidden = true
            saveImage(image: profileImage, pathComponent: "ProfileImage")
        }
    }

    func saveImage (image: UIImage, pathComponent: String) {
        let pngImageData = UIImagePNGRepresentation(image)
        let profileImageFileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(pathComponent)
        
        do {
            try pngImageData?.write(to: profileImageFileURL, options: .atomic)
            print("Succesvol")
        } catch {
            print(error)
        }
    }
    
    func loadProfileImage(pathComponent: String) {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(pathComponent)
            let image    = UIImage(contentsOfFile: imageURL.path)
            
            if image == nil {
                return
            }
            else {
                self.profileImageView.image = image
                self.cameraIconImageView.isHidden = true
            }
        }
    }
}

