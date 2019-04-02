//
//  LockedPopupView.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 29/03/2019.
//  Copyright © 2019 Zdeno Bacik. All rights reserved.
//

import UIKit

enum LockedPopupEnum {
    case LECTION
    case TEST
}

class LockedPopupView: UIViewController {
    
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var lockText: UILabel!
    @IBOutlet weak var infoText: UILabel!
    
    private var popUpType : LockedPopupEnum = LockedPopupEnum.LECTION
    
    @IBAction func okClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setPopupType(_ popUpTypeArg : LockedPopupEnum ) {
        popUpType = popUpTypeArg
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.layer.cornerRadius = 10
        okButton.layer.cornerRadius = okButton.bounds.height / 2
        
        if popUpType == LockedPopupEnum.LECTION {
            lockText.text = "Lekcia je zamknuta"
            infoText.text = "Lekcia sa odomkne az po absolvovani predchadzajucich lekcii"
        } else if popUpType == LockedPopupEnum.TEST {
            lockText.text = "Test je zamknutý"
            infoText.text = "Test sa odomkne az po absolvovani prislušnej lekcie"
        }
    }
}
