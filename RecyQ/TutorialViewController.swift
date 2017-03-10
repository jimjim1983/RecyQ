//
//  TutorialViewController.swift
//  RecyQ
//
//  Created by Jim Petri on 21/02/2017.
//  Copyright © 2017 Jimsalabim. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var tutorialScrollView: UIScrollView!
    @IBOutlet var textView: UITextView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        
        let scrollViewWidth: CGFloat = self.tutorialScrollView.frame.width
        let scrollViewHeight: CGFloat = self.tutorialScrollView.frame.height
        
        textView.textAlignment = .center
        textView.text = "Recyq is goed voor het milieu"
        textView.textColor = .black
        self.startButton.layer.cornerRadius = 5.0
        
        tutorialScrollView.layer.borderWidth = 5.0
        tutorialScrollView.layer.borderColor = UIColor.green.cgColor
        tutorialScrollView.layer.cornerRadius = 33.0
        tutorialScrollView.backgroundColor = UIColor.white
        //tutorialScrollView.layer.shadowPath = UIBezierPath(roundedRect: tutorialView.bounds, cornerRadius: 33.0).cgPath
        tutorialScrollView.layer.shadowRadius = 10
        tutorialScrollView.layer.shadowOpacity = 0.2
        
        let imgOne = UIImageView(frame: CGRect(x:0, y:0, width: scrollViewWidth, height: scrollViewHeight))
        imgOne.image = UIImage(named: "TutorialTile1")
        let imgTwo = UIImageView(frame: CGRect(x:scrollViewWidth, y:0, width:scrollViewWidth, height: scrollViewHeight))
        imgTwo.image = UIImage(named: "TutorialTile2")
        let imgThree = UIImageView(frame: CGRect(x:scrollViewWidth*2, y:0, width:scrollViewWidth, height:scrollViewHeight))
        imgThree.image = UIImage(named: "TutorialTile3")
        
        self.tutorialScrollView.addSubview(imgOne)
        self.tutorialScrollView.addSubview(imgTwo)
        self.tutorialScrollView.addSubview(imgThree)
        
        self.tutorialScrollView.contentSize = CGSize(width: self.tutorialScrollView.frame.width * 3, height: self.tutorialScrollView.frame.height)
        self.tutorialScrollView.delegate = self
        self.pageControl.currentPage = 0
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth: CGFloat = scrollView.frame.width
        let currentPage: CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        self.pageControl.currentPage = Int(currentPage)
        if Int(currentPage) == 0{
            textView.text = "Dit is de eerste tutorial pagina"
        } else if Int(currentPage) == 1 {
            textView.text = "En dit is pagina 2. Leuk he?"
        } else if Int(currentPage) == 2 {
            textView.text = "Whollah, pagina 3!"
            UIView.animate(withDuration: 1.0, animations: { () -> Void in
                self.startButton.alpha = 1.0
            })
        } else {
            textView.text = "Blijf gebruik maken van RecyQ"
            
        }
    }

    @IBAction func startButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "removeBlurView"), object:  self))
    }
    

    
    
}
