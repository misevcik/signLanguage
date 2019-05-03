//
//  InfoTableViewController.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 12/04/2019.
//  Copyright © 2019 Zdeno Bacik. All rights reserved.
//

import UIKit
import StoreKit
import MessageUI

@available(iOS 10.3, *)
class InfoTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet var infoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.infoTableView.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        self.infoTableView.backgroundView = nil;
        self.infoTableView.isOpaque = false

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "InfoDetailViewController") as! InfoDetailViewController
            self.show(vc, sender: true)
            
        } else if indexPath.row == 1 {
            SKStoreReviewController.requestReview()
            
        } else if indexPath.row == 2 {
            
            if MFMailComposeViewController.canSendMail() == true {
            
                let composeVC = MFMailComposeViewController()
                composeVC.mailComposeDelegate = self
                
                composeVC.setToRecipients(["info@dorteo.sk"])
                composeVC.setSubject("Message Subject")
                composeVC.setMessageBody("...", isHTML: false)
                
                // Present the view controller modally.
                self.present(composeVC, animated: true, completion: nil)
            }
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    
}
