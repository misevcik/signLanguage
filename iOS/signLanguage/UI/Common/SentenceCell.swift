//
//  DictionarySentenceCell.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 06/01/2019.
//  Copyright © 2019 Zdeno Bacik. All rights reserved.
//

import Foundation
import UIKit

class SentenceCell : UITableViewCell {

    static let reuseIdentifier = "SentenceCell"
    
    @IBOutlet weak var sentence: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
