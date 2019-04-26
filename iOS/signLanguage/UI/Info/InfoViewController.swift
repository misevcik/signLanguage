//
//  InfoViewController.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 12/04/2019.
//  Copyright © 2019 Zdeno Bacik. All rights reserved.
//

import UIKit
import MessageUI

class InfoViewController: UIViewController {

    @IBOutlet weak var appVersionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         appVersionLabel.text = "VERZIA \(Bundle.main.releaseVersionNumber!)"
    }
    
}
