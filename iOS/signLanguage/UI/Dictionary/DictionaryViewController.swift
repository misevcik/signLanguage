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
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK Persistence
    fileprivate let persistentContainer = NSPersistentContainer(name: "DictionaryDatabase")
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<DBWord> = {

        let fetchRequest: NSFetchRequest<DBWord> = DBWord.fetchRequest()

        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "word", ascending: true)]

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
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    }
}

extension DictionaryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dictionary = fetchedResultsController.fetchedObjects else { return 0 }
        return dictionary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WordCell.reuseIdentifier, for: indexPath) as? WordCell else {
            fatalError("Unexpected Index Path")
        }
        
        let dictionary = fetchedResultsController.object(at: indexPath)
        cell.wordLabel.text = dictionary.word

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dbWord = self.fetchedResultsController.object(at: indexPath)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WordDetailViewController") as! WordDetailViewController
        vc.dbWord = dbWord
        self.show(vc, sender: true)
        
    }
}

extension DictionaryViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        performSearch(searchText)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchBar.showsCancelButton = false
        self.searchBar.endEditing(true)
        self.searchBar.text = ""
        performSearch(searchBar.text!)
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool{
        self.searchBar.showsCancelButton = true
        return true
    }
    
    func performSearch(_ searchText : String) {
    
        if searchText.count > 0 {
            self.fetchedResultsController.fetchRequest.predicate = NSPredicate(format:"word contains[cd] %@", searchText)
        }
        else {
            self.fetchedResultsController.fetchRequest.predicate = nil
        }
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            os_log("Unable to Perform Fetch Request", log: Log.general, type: .error)
        }
        
        self.dictionaryTable.reloadData()
    }
}
