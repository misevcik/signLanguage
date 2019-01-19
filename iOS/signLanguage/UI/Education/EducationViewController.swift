//
//  EducationGridView.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 29/12/2018.
//  Copyright © 2018 Zdeno Bacik. All rights reserved.
//

import Foundation
import UIKit

//simply guide https://www.youtube.com/watch?v=NSryf0YJHHk

class EducationViewController : UIViewController {
    
    fileprivate var items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
}

extension EducationViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier, for: indexPath as IndexPath) as! CategoryCell
        
        cell.groupNameLabel.text = self.items[indexPath.item]
        cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.item)!")
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EducationDetailViewController") as! EducationDetailViewController
        self.show(vc, sender: true)
        
    }
}

extension EducationViewController : UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.size.width / 3 - 5
        let height = collectionView.bounds.size.height / 4 - 5
        
        return CGSize(width: width , height: height)
    }
}

