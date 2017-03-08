//
//  InfoViewController.swift
//  RecyQ
//
//  Created by Alyson Vivattanapa on 5/4/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func terugButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }


}
