//
//  QuizCell.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 29/01/2019.
//  Copyright © 2019 Zdeno Bacik. All rights reserved.
//

import UIKit

class QuizCell : UICollectionViewCell {
    
    static let reuseIdentifier = "QuizCell"
        
    @IBOutlet weak var videoFrame: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
