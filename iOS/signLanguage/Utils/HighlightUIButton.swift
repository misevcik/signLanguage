//
//  HighlightUIButton.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 26/04/2019.
//  Copyright © 2019 Zdeno Bacik. All rights reserved.
//

import UIKit

class HighlightUIButton : UIButton {
    
    @IBInspectable var highlightedBackgroundColor :UIColor?
    @IBInspectable var nonHighlightedBackgroundColor :UIColor?
    
    override var isHighlighted :Bool {
        get {
            return super.isHighlighted
        }
        set {
            if newValue {
                self.backgroundColor = highlightedBackgroundColor
            }
            else {
                self.backgroundColor = nonHighlightedBackgroundColor
            }
            super.isHighlighted = newValue
        }
    }
    
}
