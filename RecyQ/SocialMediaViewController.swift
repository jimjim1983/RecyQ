//
//  SocialMediaViewController.swift
//  RecyQ
//
//  Created by Jim Petri on 14/03/2017.
//  Copyright © 2017 Jimsalabim. All rights reserved.
//

import UIKit

class SocialMediaViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var webViewInstagram: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        webViewInstagram.loadRequest(URLRequest(url: URL(string: "https://www.nu.nl")!))
        // Do any additional setup after loading the view.
    }

    @IBAction func indexChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0: textLabel.text = "Instagram"
            webViewInstagram.loadRequest(URLRequest(url: URL(string: "http://www.nu.nl")!));
        case 1: textLabel.text = "Youtube"
            webViewInstagram.loadRequest(URLRequest(url: URL(string: "https://www.apple.com")!));
        case 2: textLabel.text = "Facebook"
            webViewInstagram.loadRequest(URLRequest(url: URL(string: "http://www.facebook.com")!));
        default: break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
