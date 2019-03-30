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
        loadPersistenceContainer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        testTable.indexPathsForSelectedRows?.forEach {
            testTable.deselectRow(at: $0, animated: true)
        }
    }
    
    fileprivate let persistentContainer = NSPersistentContainer(name: "DictionaryDatabase")
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<DBLesson> = {
        
        let fetchRequest: NSFetchRequest<DBLesson> = DBLesson.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
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
    
}

extension TestViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        testTable.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        testTable.endUpdates()
    }
    
    fileprivate func configureTestCell(_ cell: TestCell, lection : DBLesson) {
        
        if lection.locked == true {
            cell.lockImage.isHidden = false
            cell.lockImage.image = lockImage
            cell.detailLabel.text = "ZAMKNUTY TEST"
        } else {
            if lection.testDate == nil {
                // Test not done
                cell.scoreLabel.isHidden = true
                cell.lockImage.isHidden = false
                cell.lockImage.image = unlockImage
                cell.detailLabel.text = "ODOMKNUTY TEST"
            } else {
                // Test done
                let testAnswersCount = (lection.relDictionary!.count / 3) + 1
                let score = lection.testScore
                let correctAnswers = Int((Float(testAnswersCount) / 100.0 * Float(score)).rounded())
                let wrongAnswers = testAnswersCount - correctAnswers
                let grade = Utils.gradeCalculator(Int(score))
                
                cell.scoreLabel.isHidden = false
                cell.lockImage.isHidden = true
                cell.detailLabel.text = "\(correctAnswers) SPRÁVNE / \(wrongAnswers) NESPRÁVNE"
                cell.scoreLabel.text  = "\(score) % (\(grade))"
            }
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
        
        // Test wasn't passed
        if lection.testDate == nil {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TestDetailViewController") as! TestDetailViewController
            vc.saveToCoreDataCallback = saveResultToCoreData
            vc.setLection(lection)
            self.show(vc, sender: true)
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TestResultViewController") as! TestResultViewController
            vc.resetTestCallback = resetTest
            vc.setLectionData(lection)
            self.show(vc, sender: true)
        }
    }
    
    private func saveResultToCoreData() {
        do {
            
            try persistentContainer.viewContext.save()
        } catch {
            os_log("Unable to save changes", log: Log.general, type: .error)
            persistentContainer.viewContext.reset()
        }
    }
    
    private func resetTest() {
        
        let lection = fetchedResultsController.object(at: testTable.indexPathForSelectedRow!)
        lection.testDate = nil
        saveResultToCoreData()
        
        _ = navigationController?.popViewController(animated: false)
        self.navigationController?.isNavigationBarHidden = true
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TestDetailViewController") as! TestDetailViewController
        vc.saveToCoreDataCallback = saveResultToCoreData
        vc.setLection(lection)
        self.show(vc, sender: true)
    }

}
