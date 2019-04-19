//
//  LectionListViewController.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 29/03/2019.
//  Copyright © 2019 Zdeno Bacik. All rights reserved.
//

import UIKit

class LectionListViewController : UIViewController {
    
    var callbackSaveCoreData: (()->())?
    
    @IBOutlet weak var lectionName: UILabel!
    @IBOutlet weak var lectionTable: UITableView!
    
    @IBAction func clickBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
        self.navigationController?.isNavigationBarHidden = true
    
    }
    
    fileprivate var lectionOrderLabel : Int = 0
    fileprivate var dbLection : DBLesson!
    fileprivate var dbWordArray = Array<DBWord>()
    
    func setLection(_ lectionArg : DBLesson, _ lectionOrderLabelArg : Int) {
        dbLection = lectionArg
        lectionOrderLabel = lectionOrderLabelArg
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbWordArray = dbLection.relDictionary?.array as! [DBWord]
        lectionTable.tableFooterView = UIView()

        lectionName.text = "Lekcia č: \(lectionOrderLabel) - \(dbLection.title!)"
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
        
        let order = indexPath.row + 1
        let word = dbWordArray[indexPath.row].word!
        
        cell.wordLabel.text = "\(order). \(word)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LectionDetailViewController") as! LectionDetailViewController
        vc.setLection(dbLection)
        vc.setPage(indexPath.row)
        vc.callbackSaveCoreData = callbackSaveCoreData
        self.show(vc, sender: true)
        
    }
    
}
