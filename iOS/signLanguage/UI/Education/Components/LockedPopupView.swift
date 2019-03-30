//
//  LockedPopupView.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 29/03/2019.
//  Copyright © 2019 Zdeno Bacik. All rights reserved.
//

import UIKit

class LockedPopupView: UIViewController {
    
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    @IBAction func okClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.layer.cornerRadius = 10
        okButton.layer.cornerRadius = okButton.bounds.height / 2
    }
}
