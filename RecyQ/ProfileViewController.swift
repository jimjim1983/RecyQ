
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
    
    //var storeItem: StoreItem!
    var coupon: Coupon?
    var couponItems = [FIRDataSnapshot]()
    //var user: User!
    
    let couponsRef = FIRDatabase.database().reference(withPath: "coupons")
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var nameLabel: UILabel!

    
    var tapGestureRecogniser: UITapGestureRecognizer!
    var string: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Profiel"
        let logOutBarButtonItem = UIBarButtonItem(title: "Log uit", style: .plain, target: self, action: #selector(logOut))
        self.navigationItem.setRightBarButton(logOutBarButtonItem, animated: true)
        self.tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(showCameraAlert))
        self.profileImageView.addGestureRecognizer(tapGestureRecogniser)
        self.profileImageView.addBorderWith(width: 1, color: .white)
        self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.size.width / 2
        self.profileImageView.clipsToBounds = true
        tableView.dataSource = self
        tableView.delegate = self
        
        loadProfileImage(pathComponent: "ProfileImage")
        let location = CLLocationCoordinate2DMake(52.297375, 4.987511)
        
        let recyQAnnotation = RecyQAnnotation(title: "RecyQ Drop-Off HQ", subtitle: "Wisseloord 182, 1106 MC, Amsterdam", coordinate: location, imageName: "customPinImage.png")
        
        let span = MKCoordinateSpanMake(0.002, 0.002)
        
        let region = MKCoordinateRegionMake(location, span)
        
                
        let nib = UINib.init(nibName: "CouponsTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
            
        // Check if there's an internet connection
        ReachabilityHelper.checkReachability(viewController: self)
        
        if let lastname = currentUser?.lastName {
            self.nameLabel.text = (currentUser?.name.capitalized)! + " " + lastname.capitalized
        }
        else {
            self.nameLabel.text = currentUser?.name.capitalized
        }
        
        // go trough all coupons and find the one with the same user uid, then add them to the array for the tableview
        self.couponsRef.queryOrdered(byChild: "uid").queryEqual(toValue: currentUser?.uid).observe(.value, with: { snapshot in
            
            if let itemsFromSnapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                self.couponItems = itemsFromSnapshots
                self.tableView.reloadData()
            }
        })
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
        
        let loginVC = LoginViewController()
        Constants.appDelegate.window?.rootViewController = loginVC
    }
    
    @IBAction func openInMaps (_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Google Maps openen", message: "voor een routebeschrijving", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            if let url = URL(string: "https://www.google.nl/maps/place/Wisseloord+182,+1106+MC+Amsterdam-Zuidoost/@52.2973944,4.9853276,17z/data=!3m1!4b1!4m2!3m1!1s0x47c60c8ac7dd7be3:0x3eb79f318071fdae") {
                UIApplication.shared.openURL(url)
            }
        }
        let cancelAction = UIAlertAction(title: "Annuleer", style: .default) { (action) in
        }
        alertController.addAction(cancelAction)
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true) {
        }
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
            let item = couponItems[indexPath.row]
            cell.nameLabel.text = item.key
        }
        else {
            cell.nameLabel.text = "U heeft nog geen coupons verdiend."
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let titleHeader = "Uw verdiende coupons:"
        return titleHeader
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = couponItems[indexPath.row]
        let name = item.key
        
        if item.key .contains("Doneer") {
            let alertController = UIAlertController(title: "Bedankt voor je donatie", message: "Hou de Community pagina in de gaten om te zien wat er georganiseerd wordt", preferredStyle: .alert)
  
            let cancelAction = UIAlertAction(title: "Terug", style: .default) { (action) in
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true) {
            }
            
        } else {
            let alertController = UIAlertController(title: "Toon deze coupon bij het Recyq inzamelpunt om te verzilveren", message: name, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true) {
            }
        }
    }
}

// MARK: Tableview delegate methods.
extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Futura", size: 15)!
        header.textLabel?.textColor = UIColor.black
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
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
       
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let profileImage = image.fixOrientation()
            profileImageView.image = profileImage
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
            }
        }
    }
}

