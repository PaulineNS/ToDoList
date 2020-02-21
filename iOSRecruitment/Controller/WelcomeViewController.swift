//
//  WelcomeViewController.swift
//  iOSRecruitment
//
//  Created by Pauline Nomballais on 21/02/2020.
//  Copyright © 2020 cheerz. All rights reserved.
//

import UIKit

final class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animateTheTitle()
    }
    
    // MARK: - Methods
    
    private func animateTheTitle() {
        titleLabel.text = ""
        var charIndex = 0.0
        let titleText = Constants.appName
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.2 * charIndex, repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
                if self.titleLabel.text == Constants.appName {
                    self.performSegue(withIdentifier: Constants.Segue.welcomeSegue, sender: self)
                }
            }
            charIndex += 1
        }
    }
}
