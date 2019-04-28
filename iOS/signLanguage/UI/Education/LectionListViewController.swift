//
//  LectionListViewController.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 29/03/2019.
//  Copyright © 2019 Zdeno Bacik. All rights reserved.
//

import UIKit
import CoreData

protocol LectionListDelegate {
    func saveCoreData(viewController: LectionDetailViewController)
}

class LectionListViewController : UIViewController {
    
    var lectionOrder : Int = 0
    var dbLection : DBLesson!
    var context: NSManagedObjectContext!
    var delegate : LectionListDelegate?
    
    @IBOutlet weak var lectionName: UILabel!
    @IBOutlet weak var lectionTable: UITableView!
    
    @IBAction func clickBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
        self.navigationController?.isNavigationBarHidden = true
    
    }
    
    private var dbWordArray = Array<DBWord>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbWordArray = dbLection.relDictionary?.array as! [DBWord]
        lectionTable.tableFooterView = UIView()

        lectionName.text = "Lekcia č: \(lectionOrder) - \(dbLection.title!)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lectionTable.indexPathsForSelectedRows?.forEach {
            lectionTable.deselectRow(at: $0, animated: true)
        }
    }
    
}

extension LectionListViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dbWordArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LectionListCell.reuseIdentifier, for: indexPath) as? LectionListCell else {
            fatalError("Unexpected Index Path")
        }
        
        let dbWord = dbWordArray[indexPath.row]
        
        let order = indexPath.row + 1
        let word = dbWord.word!
        
        cell.wordLabel.text = "\(order). \(word)"
        cell.arrowImage.image = dbWord.visited == true ? #imageLiteral(resourceName: "iconRightArrowRed") : #imageLiteral(resourceName: "iconRightArrow")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LectionDetailViewController") as! LectionDetailViewController
        vc.dbLection = dbLection
        vc.context = context
        vc.delegate = self
        vc.setPage(indexPath.row)
        self.show(vc, sender: true)
        
    }
    
}

extension LectionListViewController : LectionDetailDelegate {
    
    func saveCoreData(viewController: LectionDetailViewController) {
        lectionTable.reloadData()
        self.delegate!.saveCoreData(viewController: viewController)
    }
}
