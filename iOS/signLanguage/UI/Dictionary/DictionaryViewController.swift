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

        fetchRequest.predicate = NSPredicate(format: "inDictionary == %@", NSNumber(value: true))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "word", ascending: true)]
        //fetchRequest.sortDescriptors = [NSSortDescriptor(key: "word", ascending: true, selector: #selector(NSString.localizedCompare(_:)))]

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: "word.firstUpperCaseChar", cacheName: "cache")

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
    
    fileprivate func saveData() {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            os_log("Unable to save changes", log: Log.general, type: .error)
            persistentContainer.viewContext.reset()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        loadPersistenceContainer()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dictionaryTable.indexPathsForSelectedRows?.forEach {
            dictionaryTable.deselectRow(at: $0, animated: true)
        }
    }
    
    func setupLayout() {
        
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = #colorLiteral(red: 0.9656763673, green: 0.965699017, blue: 0.9656868577, alpha: 1)
    }
    
    func nextIndexPath(_ currentIndexPath: IndexPath) -> IndexPath? {
        var nextRow = 0
        var nextSection = 0
        var iteration = 0
        var startRow = currentIndexPath.row
        for section in currentIndexPath.section ..< self.dictionaryTable.numberOfSections {
            nextSection = section
            for row in startRow ..< dictionaryTable.numberOfRows(inSection: section) {
                nextRow = row
                iteration += 1
                if iteration == 2 {
                    let nextIndexPath = IndexPath(row: nextRow, section: nextSection)
                    return nextIndexPath
                }
            }
            startRow = 0
        }
        
        return IndexPath(row: 0, section: 0)
    }
    
    func prevIndexPath(_ currentIndexPath: IndexPath) -> IndexPath? {
   
        //Todo Write previous index
        return self.dictionaryTable.lastIndexpath()
    }
}

extension DictionaryViewController: NSFetchedResultsControllerDelegate {
    
    fileprivate func configure(_ cell: WordCell, at indexPath: IndexPath) {
        
        let dictionary = fetchedResultsController.object(at: indexPath)
        
        cell.wordLabel.text = dictionary.word
        cell.favoriteImage.image = dictionary.favorite ? #imageLiteral(resourceName: "iconHeart-red") : #imageLiteral(resourceName: "iconHeart-black")
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        dictionaryTable.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        dictionaryTable.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .update:
            if let indexPath = indexPath, let cell = dictionaryTable.cellForRow(at: indexPath) as? WordCell {
                configure(cell, at: indexPath)
            }
            break
        default:
            os_log("...", log: Log.general, type: .info)
        }
    }
}

// https://developer.apple.com/documentation/coredata/nsfetchedresultscontroller
extension DictionaryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        let numberOfSections = self.fetchedResultsController.sections?.count

        return numberOfSections!
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.fetchedResultsController.sectionIndexTitles
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sections = self.fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return self.fetchedResultsController.section(forSectionIndexTitle: title, at: index)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.indexTitle
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = #colorLiteral(red: 0.9656763673, green: 0.965699017, blue: 0.9656868577, alpha: 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WordCell.reuseIdentifier, for: indexPath) as? WordCell else {
            fatalError("Unexpected Index Path")
        }

        let dictionary = fetchedResultsController.object(at: indexPath)
        
        cell.wordLabel.text = dictionary.word
        cell.favoriteImage.image = dictionary.favorite ? #imageLiteral(resourceName: "iconHeart-red") : #imageLiteral(resourceName: "iconHeart-black")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dbWord = self.fetchedResultsController.object(at: indexPath)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WordDetailViewController") as! WordDetailViewController
        vc.setWord(dbWord)
        vc.setFetchController(fetchedResultsController)
        vc.callbackNextIndexPath = nextIndexPath
        vc.callbackPrevIndexPath = prevIndexPath
        vc.callbackSaveCoreData = saveData
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
            self.fetchedResultsController.fetchRequest.predicate = NSPredicate(format:"word BEGINSWITH [cd] %@", searchText)
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
