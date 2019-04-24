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
        
    private var coreDataStack : CoreDataStack!
    private var context : NSManagedObjectContext!
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<DBWord> = {
        
        let fetchRequest: NSFetchRequest<DBWord> = DBWord.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "favorite == %@", NSNumber(value: true))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "word", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "word.firstUpperCaseChar", cacheName: nil)
        
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
                os_log("FavoriteView: saveCoreData fail", log: Log.general, type: .error)
                self.context.reset()
                return
            }
            
            self.coreDataStack.saveContext()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupManagedContext()
        
        NotificationCenter.default.addObserver(self, selector: #selector(contextDidSave(_:)), name: Notification.Name.NSManagedObjectContextDidSave, object: coreDataStack.mainContext)
    }
    
    @objc func contextDidSave(_ notification: Notification) {
        print(notification)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dictionaryTable.indexPathsForSelectedRows?.forEach {
            dictionaryTable.deselectRow(at: $0, animated: true)
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


extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {

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
        
        let dbWord = self.fetchedResultsController.object(at: indexPath)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WordDetailViewController") as! WordDetailViewController
        vc.setWord(dbWord)
        vc.setFetchController(fetchedResultsController)
        vc.callbackSaveCoreData = saveCoreData
        self.show(vc, sender: true)
        
    }


}
