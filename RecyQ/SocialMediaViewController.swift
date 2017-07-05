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
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet var annotationView: UIActivityIndicatorView!
    
    fileprivate let instagramURL = URL(string: "http://www.instagram.com")
    fileprivate let youtubeURL = URL(string: "https://www.youtube.com/channel/UChP2c-VMkBxykwp8CFQuZDQ")
    fileprivate let facebookURL = URL(string: "https://www.facebook.com/RecyQ-381878658877532/")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.delegate = self
        setUpInitialWebView()
    }
    
    fileprivate func setUpInitialWebView() {
        if let instagramURL = self.instagramURL {
            self.webView.loadRequest(URLRequest(url: instagramURL))
        }
    }

    @IBAction func indexChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            if let instagramURL = self.instagramURL {
                self.webView.loadRequest(URLRequest(url: instagramURL))
            }
        case 1:
            if let youtubeURL = self.youtubeURL {
                self.webView.loadRequest(URLRequest(url: youtubeURL))
            }
        case 2:
            if let facebookURL = self.facebookURL {
            self.webView.loadRequest(URLRequest(url: facebookURL))
            }
        default: break
        }
    }
}

extension SocialMediaViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.annotationView.stopAnimating()
    }
}
