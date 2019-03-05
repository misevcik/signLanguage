//
//  EducationViewController.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 02/03/2019.
//  Copyright © 2019 Zdeno Bacik. All rights reserved.
//

import UIKit
import CoreData
import os.log

//simply guide https://www.youtube.com/watch?v=NSryf0YJHHk, https://www.youtube.com/watch?v=s9v0YkRwYvI

class LectionViewController : UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //Variables
    fileprivate var blockOperations: [BlockOperation] = []
    fileprivate var lockImage : UIImage = UIImage(named:"iconLock")!
    fileprivate var unlockImage : UIImage = UIImage(named:"iconUnlock")!
    fileprivate let sectionInsets = UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
    fileprivate let itemsPerRow: CGFloat = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPersistenceContainer()
    }
    
    fileprivate let persistentContainer = NSPersistentContainer(name: "DictionaryDatabase")
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<DBLesson> = {
        
        let fetchRequest: NSFetchRequest<DBLesson> = DBLesson.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        //fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    fileprivate func loadPersistenceContainer() {
        
        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
            if error != nil {
                os_log("Unable to Load Persistent Store", log: Log.general, type: .error)
            } else {
                do {
                    try self.fetchedResultsController.performFetch()
                } catch {
                    os_log("Unable to Perform Fetch Request", log: Log.general, type: .error)
                }
            }
        }
    }
    
    fileprivate func unlockNextLesson(_ lesson : DBLesson) {
        
        let  indexPath = fetchedResultsController.indexPath(forObject: lesson)
        let nextIndexPath = IndexPath(row: indexPath!.row + 1, section: indexPath!.section)
        //TODO check index out-of-range
        let nextLesson = fetchedResultsController.object(at: nextIndexPath)
        
        nextLesson.locked = false
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            os_log("Unable to save changes", log: Log.general, type: .error)
            persistentContainer.viewContext.reset()
        }
    }
    
    deinit {
        for operation: BlockOperation in blockOperations {
            operation.cancel()
        }
        blockOperations.removeAll(keepingCapacity: false)
    }
    
}

//extension LectionViewController: NSFetchedResultsControllerDelegate {
//
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//
//        DispatchQueue.main.async {
//            self.collectionView!.performBatchUpdates({ () -> Void in
//                for operation: BlockOperation in self.blockOperations {
//                    operation.start()
//                }
//            }, completion: { (finished) -> Void in
//                self.blockOperations.removeAll(keepingCapacity: false)
//            })
//        }
//    }
//
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//
//        if type == NSFetchedResultsChangeType.update {
//            blockOperations.append(
//                BlockOperation(block: { [weak self] in
//                    if let this = self {
//                        DispatchQueue.main.async {
//                            this.collectionView!.reloadItems(at: [indexPath!])
//                        }
//                    }
//                })
//            )
//        }
//    }
//
//        func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
//
//            if type == NSFetchedResultsChangeType.update {
//                blockOperations.append(
//                    BlockOperation(block: { [weak self] in
//                        if let this = self {
//                            DispatchQueue.main.async {
//                                this.collectionView!.reloadSections(NSIndexSet(index: sectionIndex) as IndexSet)
//                            }
//                        }
//                    })
//                )
//            }
//    
//        }
//
//}

extension LectionViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = fetchedResultsController.sections?[section].numberOfObjects {
            return count
        }
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (fetchedResultsController.sections?.count)!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LectionCell.reuseIdentifier, for: indexPath as IndexPath) as! LectionCell
        
        let lection = fetchedResultsController.object(at: indexPath)
        
        cell.lockImage.image = lection.locked ? lockImage : unlockImage
        cell.lectionName.text = String(describing: indexPath.row + 1) + ". " + lection.title!
        cell.videoCount.text = String(describing: lection.relDictionary!.count) + " " + Labels.LECTION_VIDEOS_LABEL
        if lection.image != nil {
            cell.coverImage.image = UIImage(named: lection.image!)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let lesson = fetchedResultsController.object(at: indexPath)
        
        if lesson.locked == true {
            return
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EducationDetailViewController") as! EducationDetailViewController
        vc.setLesson(lesson)
        vc.unlockNextLessonCallback = unlockNextLesson
        
        self.show(vc, sender: true)
        
    }
}

extension LectionViewController : UICollectionViewDelegateFlowLayout {
 
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - (2 * 16 + paddingSpace)
        let widthPerItem = availableWidth / itemsPerRow
  
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
}
