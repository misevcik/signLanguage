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
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        //Write update function
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
        
        if lection.locked == true {
            cell.lockImage.image = lockImage
        } else {
            //TODO fill result
            if lection.score == 0 {
                cell.lockImage.image = unlockImage
                cell.detailLabel.text = Labels.TEST_NO_TEST_LABEL
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TestDetailViewController") as! TestDetailViewController
        self.show(vc, sender: true)
    }
}
