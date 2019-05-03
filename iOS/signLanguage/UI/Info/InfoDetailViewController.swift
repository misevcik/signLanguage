//
//  InfoDetailViewController.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 12/04/2019.
//  Copyright © 2019 Zdeno Bacik. All rights reserved.
//

import UIKit

class InfoDetailViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var aboutText: UILabel!
    @IBOutlet weak var euText: UILabel!
    
    @IBAction func clickBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.layer.cornerRadius = 15
        appVersionLabel.text = "VERZIA \(Bundle.main.releaseVersionNumber!)"
        
        if Utils.getDeviceSize() == .small {
            aboutText.adjustsFontSizeToFitWidth = true
            euText.adjustsFontSizeToFitWidth = true
        }

    }
    
}
