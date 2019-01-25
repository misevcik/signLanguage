//
//  DictionaryViewController.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 03/01/2019.
//  Copyright © 2019 Zdeno Bacik. All rights reserved.
//

import CoreData
import UIKit
import os.log

class DictionaryViewController : UIViewController {
    
    //MARK Outlets
    @IBOutlet weak var dictionaryTable: UITableView!
        
    //MARK Persistence
    //TODO - replace with persistence conatiner in AppDelegate
    fileprivate let persistentContainer = NSPersistentContainer(name: "DictionaryDatabase")
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<DBDictionary> = {

        let fetchRequest: NSFetchRequest<DBDictionary> = DBDictionary.fetchRequest()

        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dictionary", ascending: true)]

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
}

extension DictionaryViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        dictionaryTable.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        dictionaryTable.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                dictionaryTable.insertRows(at: [indexPath], with: .fade)
            }
            break
        default:
            os_log("...", log: Log.general, type: .info)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
    }
    
}

extension DictionaryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dictionary = fetchedResultsController.fetchedObjects else { return 0 }
        return dictionary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DictionaryCell.reuseIdentifier, for: indexPath) as? DictionaryCell else {
            fatalError("Unexpected Index Path")
        }
        
        let dictionary = fetchedResultsController.object(at: indexPath)
        cell.wordLabel.text = dictionary.dictionary

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dbDictionary = self.fetchedResultsController.object(at: indexPath)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DictionaryDetailViewController") as! DictionaryDetailViewController
        vc.dbDictionary = dbDictionary
        self.show(vc, sender: true)
        
    }
}
