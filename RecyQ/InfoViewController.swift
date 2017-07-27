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
    @IBOutlet var zeroWasteLogoImageView: UIImageView!
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Wat gaan we doen?"
        self.zeroWasteLogoImageView.alpha = 0
        scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UITextView {
    func animate(newText: String, characterDelay: TimeInterval) {
        
        DispatchQueue.main.async {
            
            self.text = ""
            
            for (index, character) in newText.characters.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + characterDelay * Double(index)) {
                    self.text?.append(character)
                }
            }
        }
    }
    /// This animates the text as if it is being typed letter by letter.
    func setTextWithTypeAnimation(typedText: String, characterInterval: TimeInterval = 0.25, completion:@escaping () -> Void) {
        text = ""
        DispatchQueue.global(qos: .userInteractive).async {
            
            for character in typedText.characters {
                DispatchQueue.main.async {
                    
                    self.text = self.text! + String(character)
                }
                if character == "." {
                    Thread.sleep(forTimeInterval: 0.5)
                }else {
                    Thread.sleep(forTimeInterval: characterInterval)
                }
            }
            completion()
            
        }
    }
}
