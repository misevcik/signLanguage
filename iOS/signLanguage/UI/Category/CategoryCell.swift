//
//  EducationCell.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 29/12/2018.
//  Copyright © 2018 Zdeno Bacik. All rights reserved.
//

import Foundation
import UIKit

class CategoryCell : UICollectionViewCell {
    
    static let reuseIdentifier = "CategoryCell"
    
    @IBOutlet weak var groupNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
