//
//  InfoTableViewController.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 12/04/2019.
//  Copyright © 2019 Zdeno Bacik. All rights reserved.
//

import UIKit

class InfoTableViewController: UITableViewController {

    @IBOutlet var infoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.infoTableView.backgroundColor = #colorLiteral(red: 0.9656763673, green: 0.965699017, blue: 0.9656868577, alpha: 1)
        self.infoTableView.backgroundView = nil;
        self.infoTableView.isOpaque = false

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "InfoDetailViewController") as! InfoDetailViewController
            self.show(vc, sender: true)
        }
        
    }
    
}
