//
//  CategoryDetailViewController.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 06/01/2019.
//  Copyright © 2019 Zdeno Bacik. All rights reserved.
//

import UIKit

class EducationDetailViewController : UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension EducationDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DictionaryCell.reuseIdentifier, for: indexPath) as? DictionaryCell else {
            fatalError("Unexpected Index Path")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DictionaryDetailViewController") as! DictionaryDetailViewController
        self.show(vc, sender: true)
    }
}
