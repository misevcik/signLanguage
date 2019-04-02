//
//  LectionCell.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 29/12/2018.
//  Copyright © 2018 Zdeno Bacik. All rights reserved.
//

import Foundation
import UIKit

class LectionCell : UICollectionViewCell {
    
    static let reuseIdentifier = "LectionCell"
    
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var lockImage: UIImageView!
    @IBOutlet weak var lectionName: UILabel!
    @IBOutlet weak var videoCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
