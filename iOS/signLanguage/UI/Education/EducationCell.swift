//
//  EducationCell.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 29/12/2018.
//  Copyright © 2018 Zdeno Bacik. All rights reserved.
//

import Foundation
import UIKit

class EducationCell : UICollectionViewCell {
    
    static let reuseIdentifier = "EducationCell"
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var coverLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
