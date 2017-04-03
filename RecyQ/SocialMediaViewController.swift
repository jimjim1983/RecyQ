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
    //@IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        segmentedControl.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: UIControlState.selected)
        webView.loadRequest(URLRequest(url: URL(string: "http://www.instagram.com")!))
        // Do any additional setup after loading the view.
    }

    @IBAction func indexChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0: //textLabel.text = "Instagram"
            webView.loadRequest(URLRequest(url: URL(string: "http://www.instagram.com")!));
        case 1: //textLabel.text = "Youtube"
            webView.loadRequest(URLRequest(url: URL(string: "https://www.youtube.com/channel/UChP2c-VMkBxykwp8CFQuZDQ")!));
        case 2: //textLabel.text = "Facebook"
            webView.loadRequest(URLRequest(url: URL(string: "https://www.facebook.com/RecyQ-381878658877532/")!));
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
