//
//  EducationGridView.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 29/12/2018.
//  Copyright © 2018 Zdeno Bacik. All rights reserved.
//

import UIKit
import CoreData
import os.log

//simply guide https://www.youtube.com/watch?v=NSryf0YJHHk
//simply guid https://www.youtube.com/watch?v=s9v0YkRwYvI - implement batch insertion

class EducationViewController : UIViewController {
    
    //IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    //Variables
    fileprivate var blockOperations: [BlockOperation] = []
    
    //TODO - replace with persistence conatiner in AppDelegate
    fileprivate let persistentContainer = NSPersistentContainer(name: "DictionaryDatabase")
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<DBLesson> = {
        
        let fetchRequest: NSFetchRequest<DBLesson> = DBLesson.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    //TODO - replace with persistence conatiner in AppDelegate
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPersistenceContainer()
    }
    
    fileprivate func unlockNextLesson(_ lesson : DBLesson) {
        
        let  indexPath = fetchedResultsController.indexPath(forObject: lesson)
        let nextIndexPath = IndexPath(row: indexPath!.row + 1, section: indexPath!.section)
        //TODO check index out-of-range
        let nextLesson = fetchedResultsController.object(at: nextIndexPath)
        
        nextLesson.lock = false
        
        do {
            try persistentContainer.viewContext.save()
            return
        } catch {
            os_log("Unable to save changes", log: Log.general, type: .error)
            persistentContainer.viewContext.reset()
            return
        }
    }
    
    deinit {
        for operation: BlockOperation in blockOperations {
            operation.cancel()
        }
        blockOperations.removeAll(keepingCapacity: false)
    }
}

extension EducationViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        DispatchQueue.main.async {
            self.collectionView!.performBatchUpdates({ () -> Void in
                for operation: BlockOperation in self.blockOperations {
                    operation.start()
                }
            }, completion: { (finished) -> Void in
                self.blockOperations.removeAll(keepingCapacity: false)
            })
        }
    }
        
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if type == NSFetchedResultsChangeType.update {
            blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        DispatchQueue.main.async {
                            this.collectionView!.reloadItems(at: [indexPath!])
                        }
                    }
                })
            )
        }
    }
    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
//
//        if type == NSFetchedResultsChangeType.update {
//            blockOperations.append(
//                BlockOperation(block: { [weak self] in
//                    if let this = self {
//                        DispatchQueue.main.async {
//                            this.collectionView!.reloadSections(NSIndexSet(index: sectionIndex) as IndexSet)
//                        }
//                    }
//                })
//            )
//        }
//
//    }
    
}

extension EducationViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = fetchedResultsController.sections?[section].numberOfObjects {
            return count
        }
        return 0
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EducationCell.reuseIdentifier, for: indexPath as IndexPath) as! EducationCell

        let lesson = fetchedResultsController.object(at: indexPath)
        if lesson.lock == false {
            cell.coverLabel.text = lesson.detail
            cell.coverImage.image = UIImage(named: lesson.image!)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let lesson = fetchedResultsController.object(at: indexPath)
        
        if lesson.lock == true {
            return
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EducationDetailViewController") as! EducationDetailViewController
        vc.setLesson(lesson)
        vc.unlockNextLessonCallback = unlockNextLesson
        
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

