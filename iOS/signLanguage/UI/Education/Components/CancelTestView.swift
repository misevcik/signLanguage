//
//  CancelTestView.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 02/04/2019.
//  Copyright © 2019 Zdeno Bacik. All rights reserved.
//

import UIKit

class CancelTestView: UIViewController {
    
    var cancelTestCallback: (() -> Void)?
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var continuteButton: UIButton!
    @IBOutlet weak var headLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBAction func cancelClick(_ sender: Any) {
        cancelTestCallback!()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func continueClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.layer.cornerRadius = 10
        continuteButton.layer.cornerRadius = continuteButton.bounds.height / 3
        cancelButton.layer.cornerRadius = cancelButton.bounds.height / 3
        cancelButton.layer.borderWidth = 2
        cancelButton.layer.borderColor = #colorLiteral(red: 0.5160872936, green: 0.8872948289, blue: 0.9788959622, alpha: 1)
        
        if Utils.getDeviceSize() == .small {
            headLabel.adjustsFontSizeToFitWidth = true
            infoLabel.adjustsFontSizeToFitWidth = true
        }
    }


}
