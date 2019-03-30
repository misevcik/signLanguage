//
//  LectionListCell.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 29/03/2019.
//  Copyright © 2019 Zdeno Bacik. All rights reserved.
//

import Foundation
import UIKit

class LectionListCell : UITableViewCell {
    
    static let reuseIdentifier = "LectionListCell"
    
    @IBOutlet weak var wordLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
