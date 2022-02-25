//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: CLTypingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "⚡️FlashChat"
        
        
     /*   var charIndex = 0
        titleLabel.text = ""
        let tittleText = "⚡️FlashChat"
        for i in tittleText {
            Timer.scheduledTimer(withTimeInterval: 0.2 * Double(charIndex), repeats: false) { (timer) in
                self.titleLabel.text?.append(i)
            }
            charIndex += 1
        }*/
        
       
    }
    

}
