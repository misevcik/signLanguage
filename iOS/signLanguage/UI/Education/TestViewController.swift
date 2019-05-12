//
//  TestViewController.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 02/03/2019.
//  Copyright © 2019 Zdeno Bacik. All rights reserved.
//

import UIKit
import CoreData
import os.log

class TestViewController : UIViewController {
    
    
    @IBOutlet weak var testTable: UITableView!
    
    fileprivate var lockImage : UIImage = UIImage(named:"iconLock")!
    fileprivate var unlockImage : UIImage = UIImage(named:"iconUnlock")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupManagedContext()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        testTable.indexPathsForSelectedRows?.forEach {
            testTable.deselectRow(at: $0, animated: true)
        }
    }
    
    private var coreDataStack : CoreDataStack!
    private var context : NSManagedObjectContext!
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<DBLesson> = {
        
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
    
}

extension TestViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        testTable.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        testTable.endUpdates()
    }
    
    fileprivate func configureTestCell(_ cell: TestCell, lection : DBLesson) {
        
        if lection.locked == false {
            if lection.testDate == nil {
                // Test not done
                cell.scoreLabel.isHidden = true
                cell.lockImage.image = unlockImage
                cell.detailLabel.text = "SKUS SA OTESTOVAT"
            } else {
                // Test done
                let testAnswersCount = (lection.relDictionary!.count / 3) + 1
                let score = lection.testScore
                let correctAnswers = Int((Float(testAnswersCount) / 100.0 * Float(score)).rounded())
                let wrongAnswers = testAnswersCount - correctAnswers
                let grade = Utils.gradeCalculator(Int(score))
                
                cell.scoreLabel.isHidden = false
                cell.detailLabel.text = "\(correctAnswers) SPRÁVNE / \(wrongAnswers) NESPRÁVNE"
                cell.scoreLabel.text  = "\(score)% (\(grade))"
            }
        } else {
            cell.lockImage.isHidden = false
            cell.lockImage.image = lockImage
            cell.detailLabel.text = "ZAMKNUTY TEST"
        }
        
        //adjust font to small resolution
        if Utils.getDeviceSize() == .small {
            cell.nameLabel.adjustsFontSizeToFitWidth = true
            cell.scoreLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .update:
            if let indexPath = indexPath, let cell = testTable.cellForRow(at: indexPath) as? TestCell {
                let lection = fetchedResultsController.object(at: indexPath)
                configureTestCell(cell, lection: lection)
            }
            break
        default:
            os_log("...", log: Log.general, type: .info)
        }
    }
}

extension TestViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let lection = fetchedResultsController.fetchedObjects else { return 0 }
        return lection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TestCell.reuseIdentifier, for: indexPath) as? TestCell else {
            fatalError("Unexpected Index Path")
        }
        
        let lection = fetchedResultsController.object(at: indexPath)
        
        cell.nameLabel.text = String(describing: indexPath.row + 1) + ". Test - " + lection.title!
        
        configureTestCell(cell, lection: lection)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let lection = fetchedResultsController.object(at: indexPath)
        
        if lection.locked == true {
            let vc = LockedPopupView()
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            vc.setPopupType(LockedPopupEnum.TEST)
            self.present(vc, animated: true, completion: nil)
        }
        
        // Date == nil - test wasn't tried yet
        if lection.testDate == nil {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TestDetailViewController") as! TestDetailViewController
            vc.callbackSaveCoreData = saveCoreData
            vc.setLection(lection)
            self.show(vc, sender: true)
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TestResultViewController") as! TestResultViewController
            vc.resetTestCallback = resetTest
            vc.setLectionData(lection)
            self.show(vc, sender: true)
        }
    }
    
    fileprivate func saveCoreData() {
        
        guard context.hasChanges else { return }
        
        self.context.perform {
            do {
                try self.context.save()
            } catch  {
                os_log("TestView: saveCoreData fail", log: Log.general, type: .error)
                self.context.reset()
                return
            }
            
            self.coreDataStack.saveContext()
        }
    }
    
    private func resetTest() {
        
        let lection = fetchedResultsController.object(at: testTable.indexPathForSelectedRow!)
        lection.testDate = nil
        saveCoreData()
        
        _ = navigationController?.popViewController(animated: false)
        self.navigationController?.isNavigationBarHidden = true
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TestDetailViewController") as! TestDetailViewController
        vc.callbackSaveCoreData = saveCoreData
        vc.setLection(lection)
        self.show(vc, sender: true)
    }

}
