//
//  TestCell.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 03/03/2019.
//  Copyright © 2019 Zdeno Bacik. All rights reserved.
//

import UIKit

class TestCell : UITableViewCell {
    
    static let reuseIdentifier = "TestCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var lockImage: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
