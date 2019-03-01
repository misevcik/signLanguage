//
//  WordCell.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 28/12/2018.
//  Copyright © 2018 Zdeno Bacik. All rights reserved.
//

import Foundation
import UIKit


class WordCell : UITableViewCell {
    
    static let reuseIdentifier = "WordCell"
    
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var knowImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
        
}
