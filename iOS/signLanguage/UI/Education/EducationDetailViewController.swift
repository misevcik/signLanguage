//
//  CategoryDetailViewController.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 06/01/2019.
//  Copyright © 2019 Zdeno Bacik. All rights reserved.
//

import UIKit
import UPCarouselFlowLayout
import CoreData

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
    @IBOutlet weak var lessonName: UILabel!
    @IBOutlet weak var selectedDictionary: UILabel!
    
    

    @IBAction func backAction(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func nextClick(_ sender: Any) {

        self.currentPage = self.currentPage + 1
        self.collectionView.scrollToItem(at: IndexPath(item: self.currentPage, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    @IBAction func previousClick(_ sender: Any) {
        self.currentPage = self.currentPage - 1
        self.collectionView.scrollToItem(at: IndexPath(item: self.currentPage, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    //Variables
    fileprivate var dbLesson : DBLesson!
    fileprivate var dbDictionaryItems = [DBDictionary]()
    
    fileprivate var currentPage: Int = 0 {
        didSet {
            updatePageView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLessonData()
        
        self.setupLayout()
        
        // Set internal variables
        self.lessonName.text = dbLesson.detail
        self.currentPage = 0
    }
    
    fileprivate func setupLayout() {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: 30)
    }
    
}

extension EducationDetailViewController {
    
    fileprivate func loadLessonData() {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate!.persistentContainer.viewContext
        
        do {
            let fetchRequest: NSFetchRequest<DBLesson> = DBLesson.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", 0)
           
            let records  = try context.fetch(fetchRequest)
            
            dbLesson = records.first!
            for item in dbLesson.relDictionary! {
                dbDictionaryItems.append(item as! DBDictionary)
            }
        }
        catch {
            print ("fetch task failed", error)
        }
    }
    
    fileprivate func updatePageView() {
    
        selectedDictionary.text = self.dbDictionaryItems[self.currentPage].dictionary
        
        let currentPage = String(self.currentPage + 1)
        let sum = String(self.dbDictionaryItems.count)
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
}

extension EducationDetailViewController : UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dbDictionaryItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EducationDetailCell.identifier, for: indexPath) as! EducationDetailCell
        let dbDictionary = dbDictionaryItems[(indexPath as NSIndexPath).row]
        cell.image.image = UIImage(named: dbDictionary.image!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let dbDictionary = dbDictionaryItems[(indexPath as NSIndexPath).row]
        let alert = UIAlertController(title: dbDictionary.dictionary, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollingFinished(scrollView: scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate {
            return
        }
        else {
            scrollingFinished(scrollView: scrollView)
        }
    }
    
    func scrollingFinished(scrollView: UIScrollView) {
        
        let pageSide = self.pageSize.width
        let offset = scrollView.contentOffset.x
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
    }
    
}
