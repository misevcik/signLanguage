//
//  CategoryDetailViewController.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 06/01/2019.
//  Copyright © 2019 Zdeno Bacik. All rights reserved.
//

import UIKit
import UPCarouselFlowLayout

struct Character {
    let imageName: String!
    let name: String!
    let movie: String!
}

class EducationDetailViewController : UIViewController{

    //IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var moveForward: UIButton!
    @IBOutlet weak var moveBackward: UIButton!
    @IBOutlet weak var pager: UILabel!
    

    @IBAction func nextClick(_ sender: Any) {

        self.currentPage = self.currentPage + 1
        self.collectionView.scrollToItem(at: IndexPath(item: self.currentPage, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    @IBAction func previousClick(_ sender: Any) {
        self.currentPage = self.currentPage - 1
        self.collectionView.scrollToItem(at: IndexPath(item: self.currentPage, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    //Variables
    fileprivate var items = [Character]()
    fileprivate var currentPage: Int = 0 {
        didSet {
            let character = self.items[self.currentPage]
            updatePager()
            
            //self.infoLabel.text = character.name.uppercased()
            //self.detailLabel.text = character.movie.uppercased()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLayout()
        self.items = self.createItems()
        
        self.currentPage = 0
    }
    
    fileprivate func setupLayout() {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: 30)
    }
    
}

extension EducationDetailViewController {
    
    fileprivate func updatePager() {
    
        let currentPage = String(self.currentPage + 1)
        let sum = String(self.items.count)
    
        pager.text = currentPage + "/" + sum
    }
    
    fileprivate var pageSize: CGSize {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        pageSize.width += layout.minimumLineSpacing
        return pageSize
    }
    
    fileprivate var orientation: UIDeviceOrientation {
        return UIDevice.current.orientation
    }
    
    fileprivate func createItems() -> [Character] {
        let characters = [
            Character(imageName: "wall-e", name: "Wall-E", movie: "Wall-E"),
            Character(imageName: "nemo", name: "Nemo", movie: "Finding Nemo"),
            Character(imageName: "ratatouille", name: "Remy", movie: "Ratatouille"),
            Character(imageName: "buzz", name: "Buzz Lightyear", movie: "Toy Story"),
            Character(imageName: "monsters", name: "Mike & Sullivan", movie: "Monsters Inc."),
            Character(imageName: "brave", name: "Merida", movie: "Brave")
        ]
        return characters
    }
    
    
}

extension EducationDetailViewController : UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EducationDetailCell.identifier, for: indexPath) as! EducationDetailCell
        let character = items[(indexPath as NSIndexPath).row]
        cell.image.image = UIImage(named: character.imageName)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let character = items[(indexPath as NSIndexPath).row]
        let alert = UIAlertController(title: character.name, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        let pageSide = self.pageSize.width
        let offset = scrollView.contentOffset.x
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
    }
    
}
