//
//  FavoritesViewController.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 03/01/2019.
//  Copyright © 2019 Zdeno Bacik. All rights reserved.
//

import CoreData
import UIKit
import os.log

class FavoritesViewController : UIViewController {
    
    @IBOutlet weak var dictionaryTable: UITableView!
    @IBOutlet weak var dictionaryTableTrailing: NSLayoutConstraint!
    
    private var coreDataStack : CoreDataStack!
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<DBWord> = {
        
        let fetchRequest: NSFetchRequest<DBWord> = DBWord.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "favorite == %@", NSNumber(value: true))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "word", ascending: true, selector: #selector(NSString.localizedCompare(_:)))]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.coreDataStack.mainContext, sectionNameKeyPath: "word.SKfirstUpperCaseChar", cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupManagedContext()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dictionaryTable.indexPathsForSelectedRows?.forEach {
            dictionaryTable.deselectRow(at: $0, animated: true)
        }
          
        updateTableLayout()
    }
    
    private func updateTableLayout() {
        
        if (self.fetchedResultsController.fetchedObjects?.count)! > 0 {
            dictionaryTableTrailing.constant = 4
            dictionaryTable.isHidden = false
        } else {
            dictionaryTableTrailing.constant = 16
            dictionaryTable.isHidden = true
        }
        
    }
}

extension FavoritesViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        dictionaryTable.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        dictionaryTable.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch (type) {
        case .insert:
            self.dictionaryTable.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
            break
        case .delete:
            self.dictionaryTable.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
            updateTableLayout()
            break
        default:
            os_log("...", log: Log.general, type: .info)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                dictionaryTable.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                dictionaryTable.deleteRows(at: [indexPath], with: .fade)
            }
            break
        default:
            os_log("...", log: Log.general, type: .info)
        }
    }
}


private extension FavoritesViewController {
    
    private func setupManagedContext() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        self.coreDataStack = appDelegate.coreDataStack
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            os_log("Unable to Perform Fetch Request", log: Log.general, type: .error)
        }
    }
    
    private func nextIndexPath(_ currentIndexPath: IndexPath) -> IndexPath? {
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
    
    private func prevIndexPath(_ currentIndexPath: IndexPath) -> IndexPath? {
        
        var row = currentIndexPath.row
        var section = currentIndexPath.section
        
        // Keep in same section
        if row > 0 {
            row -= 1
            return IndexPath(row : row, section: section)
        }
        
        //Go to previoius section
        if section > 0 {
            section -= 1
            row = max(dictionaryTable.numberOfRows(inSection: section) - 1, 0)
            return IndexPath(row : row, section: section)
        }
        
        //Last section, last row
        return self.dictionaryTable.lastIndexpath()
    }
    
}

extension FavoritesViewController: WordDetailDelegate {
    
    func saveCoreData(viewController: WordDetailViewController) {
        
        guard let context = viewController.context, context.hasChanges else { return }
        
        context.perform {
            do {
                try context.save()
            } catch {
                os_log("DictionaryView: saveCoreData fail", log: Log.general, type: .error)
                context.reset()
                return
            }
            
            self.coreDataStack.saveContext()
        }
    }
    
    func nextWord(word : DBWord, forward: Bool, context : NSManagedObjectContext) -> DBWord {
        
        let parentWord = coreDataStack.mainContext.object(with: word.objectID) as? DBWord
        
        let currentIndexPath =  self.fetchedResultsController.indexPath(forObject: parentWord!)
        if currentIndexPath == nil {
            return word
        }
        
        var nextIndexPath = IndexPath(row: 0, section: 0)
        
        if forward == true {
            nextIndexPath = self.nextIndexPath(currentIndexPath!)!
        } else {
            nextIndexPath = self.prevIndexPath(currentIndexPath!)!
        }
        
        let nextWord = fetchedResultsController.object(at: nextIndexPath)
        let childWord = context.object(with: nextWord.objectID) as? DBWord
        
        return childWord!
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        
        let numberOfSections = self.fetchedResultsController.sections?.count
        return numberOfSections!
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.fetchedResultsController.sectionIndexTitles
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }
    
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return self.fetchedResultsController.section(forSectionIndexTitle: title, at: index)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sections = self.fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.name
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
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
        
        let word = self.fetchedResultsController.object(at: indexPath)
        
        let childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        childContext.parent = coreDataStack.mainContext
        let childWord = childContext.object(with: word.objectID) as? DBWord
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WordDetailViewController") as! WordDetailViewController
        vc.dbWord = childWord
        vc.context = childContext
        vc.delegate = self
        
        self.show(vc, sender: true)
    }


}
