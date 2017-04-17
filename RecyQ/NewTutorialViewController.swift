//
//  NewTutorialViewController.swift
//  RecyQ
//
//  Created by Jim Petri on 17/04/2017.
//  Copyright © 2017 Jimsalabim. All rights reserved.
//

import UIKit

class NewTutorialViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textView1: UITextView!
    @IBOutlet weak var textView2: UITextView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stepsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tabBarController?.tabBar.isHidden = true

        self.scrollView.frame = CGRect(x:0, y:0, width: self.view.frame.width, height: self.view.frame.height)
        let scrollViewWidth:CGFloat = self.scrollView.frame.width
        let scrollViewHeight:CGFloat = self.scrollView.frame.height
        
        textView1.font = UIFont(name: "VolvoBroad", size: 38)!
        textView1.textAlignment = .center
        textView2.textAlignment = .center
        stepsTextView.textAlignment = .center
        textView1.text = "Welkom bij RecyQ"
        textView2.text = "Je account is nu geopend. Je kunt nu beginnen met het scheiden van plastic, textiel en papier"
        stepsTextView.text = "Stap 1"
        textView2.textColor = .black
        stepsTextView.textColor = .black
        self.startButton.addBorderWith(width: 1, color: .darkGray)
        
        let imgOne = UIImageView(frame: CGRect(x:66, y:175,width:textView1.frame.width, height:textView1.frame.height))
        imgOne.image = UIImage(named: "recyqgroen")
        let imgTwo = UIImageView(frame: CGRect(x:scrollViewWidth+66, y:175,width:textView1.frame.width, height:textView1.frame.height))
        imgTwo.image = UIImage(named: "recyqblauw")
        let imgThree = UIImageView(frame: CGRect(x:scrollViewWidth*2+66, y:175,width:textView1.frame.width, height:textView1.frame.height))
        imgThree.image = UIImage(named: "recyqrood")
        let imgFour = UIImageView(frame: CGRect(x:scrollViewWidth*3+66, y:175,width:textView1.frame.width, height:textView1.frame.height))
        imgFour.image = UIImage(named: "recyqgeel")
        
        self.scrollView.addSubview(imgOne)
        self.scrollView.addSubview(imgTwo)
        self.scrollView.addSubview(imgThree)
        self.scrollView.addSubview(imgFour)
        
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width * 4, height:self.scrollView.frame.height)
        self.scrollView.delegate = self
        self.pageControl.currentPage = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        let pageWidth: CGFloat = scrollView.frame.width
        let currentPage: CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
    
        self.pageControl.currentPage = Int(currentPage)
        
        if Int(currentPage) == 0 {
            textView1.text = "Welkom bij RecyQ"
            textView2.text = "Je account is geopend. Je kunt nu beginnen met het scheiden van plastic, textiel en papier"
            stepsTextView.text = "Stap 1"
            self.startButton.alpha = 0
        }
        else if Int(currentPage) == 1{
            textView1.text = "Lever je volle tassen in"
            textView2.text = "Haal een zero waste tas op bij een van de locaties om je afval in te leveren"
            stepsTextView.text = "Stap 2"
            self.startButton.alpha = 0
        }
        else if Int(currentPage) == 2{
            textView1.text = "Verzilver je gespaarde tokens"
            textView2.text = "Voor korting op producten en diensten in de Zero Waste Store en bij ondernemers in de Amsterdamse Poort"
            stepsTextView.text = "Stap 3"
            self.startButton.alpha = 0
        }
        else {
            textView1.text = "Red het milieu"
            textView2.text = "Draag bij aan een betere wereld"
            stepsTextView.text = "Klaar"

            self.startButton.alpha = 1.0
            }
        }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.tabBarController?.tabBar.isHidden = false
    }



}
