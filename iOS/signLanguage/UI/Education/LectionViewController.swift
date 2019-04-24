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
    private var blockOperations: [BlockOperation] = []
    private var lockImage : UIImage = UIImage(named:"iconLock")!
    private var unlockImage : UIImage = UIImage(named:"iconUnlock")!
    private let sectionInsets = UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
    private let itemsPerRow: CGFloat = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupManagedContext()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    private var coreDataStack : CoreDataStack!
    private var context : NSManagedObjectContext!
    
    private lazy var fetchedResultsController: NSFetchedResultsController<DBLesson> = {
        
        let fetchRequest: NSFetchRequest<DBLesson> = DBLesson.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    fileprivate func setupManagedContext() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        self.coreDataStack = appDelegate.coreDataStack
        self.context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.context.parent = coreDataStack.mainContext
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            os_log("Unable to Perform Fetch Request", log: Log.general, type: .error)
        }
    }
    
    fileprivate func saveCoreData() {
        
        guard context.hasChanges else { return }
        
        self.context.perform {
            do {
                try self.context.save()
            } catch  {
                os_log("LectionView: saveCoreData fail", log: Log.general, type: .error)
                self.context.reset()
                return
            }
            
            self.coreDataStack.saveContext()
        }
    }
    
    
    private func unlockNextLesson(_ lesson : DBLesson) {

        let  indexPath = fetchedResultsController.indexPath(forObject: lesson)
        let nextIndexPath = IndexPath(row: indexPath!.row + 1, section: indexPath!.section)
        //TODO check index out-of-range
        let nextLection = fetchedResultsController.object(at: nextIndexPath)

        nextLection.locked = false

        saveCoreData()
    }
    
    private func setLectionProgressBar(_ dbLection : DBLesson, _ cell : LectionCell) {
        
        if dbLection.visitedWord > 0 {
            
            let max = dbLection.relDictionary?.array.count
            let visitedWord = dbLection.visitedWord
            let ratio = Float(visitedWord) / Float(max!)
            
            cell.progressBar.isHidden = false
            cell.progressBar.progress = Float(ratio)
            
        }
        
    }
    
    deinit {
        for operation: BlockOperation in blockOperations {
            operation.cancel()
        }
        blockOperations.removeAll(keepingCapacity: false)
    }
    
}

extension LectionViewController: NSFetchedResultsControllerDelegate {

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

        func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {

            if type == NSFetchedResultsChangeType.update {
                blockOperations.append(
                    BlockOperation(block: { [weak self] in
                        if let this = self {
                            DispatchQueue.main.async {
                                this.collectionView!.reloadSections(NSIndexSet(index: sectionIndex) as IndexSet)
                            }
                        }
                    })
                )
            }
    
        }

}

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
        
        setLectionProgressBar(lection, cell)
        
        cell.lockImage.image = lection.locked ? lockImage : unlockImage
        cell.lectionName.text = String(describing: indexPath.row + 1) + ". " + lection.title!
        cell.videoCount.text = String(describing: lection.relDictionary!.count) + " " + "VIDEI"
        if lection.image != nil {
            cell.coverImage.image = UIImage(named: lection.image!)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let lesson = fetchedResultsController.object(at: indexPath)
        
        if lesson.locked == true {
            let vc = LockedPopupView()
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            vc.setPopupType(LockedPopupEnum.LECTION)
            self.present(vc, animated: true, completion: nil)
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LectionListViewController") as! LectionListViewController
        vc.setLection(lesson, indexPath.row + 1)
        vc.callbackSaveCoreData = saveCoreData
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
