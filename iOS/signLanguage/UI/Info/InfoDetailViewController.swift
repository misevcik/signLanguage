//
//  InfoDetailViewController.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 12/04/2019.
//  Copyright © 2019 Zdeno Bacik. All rights reserved.
//

import UIKit
import MessageUI


@available(iOS 10.3, *)
class InfoDetailViewController: UIViewController , MFMailComposeViewControllerDelegate  {
    
    
    @IBAction func clickBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
        self.navigationController?.isNavigationBarHidden = true
    }
    

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var aboutText: UILabel!
    @IBOutlet weak var euText: UILabel!
    @IBOutlet weak var authorText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.layer.cornerRadius = 15
        appVersionLabel.text = "VERZIA \(Bundle.main.releaseVersionNumber!)"
        
        let text = aboutText.text! as NSString
        let attrbuteString = NSMutableAttributedString(string: text as String)
        let dorteoRange = text.range(of: InfoTableViewController.EMAIL)
        let github = text.range(of: "githube.")
        attrbuteString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: dorteoRange)
        attrbuteString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: github)
        attrbuteString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: dorteoRange)
        attrbuteString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: github)
        aboutText.attributedText = attrbuteString
        aboutText.isUserInteractionEnabled = true
        aboutText.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
    
    }
    
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        let text = aboutText.text! as NSString
        let dorteoRange = (text as NSString).range(of: InfoTableViewController.EMAIL)
        let githubRange = (text as NSString).range(of: "githube.")
        
        if gesture.didTapAttributedTextInLabel(label: aboutText, inRange: dorteoRange) {

            if MFMailComposeViewController.canSendMail() == true {

                let composeVC = MFMailComposeViewController()
                composeVC.mailComposeDelegate = self

                composeVC.setToRecipients([InfoTableViewController.EMAIL])
                composeVC.setSubject("Message Subject")
                composeVC.setMessageBody("...", isHTML: false)

                // Present the view controller modally.
                self.present(composeVC, animated: true, completion: nil)
            }

        } else if gesture.didTapAttributedTextInLabel(label: aboutText, inRange: githubRange) {
            if let url = URL(string: "https://github.com/misevcik/signLanguage") {
                UIApplication.shared.open(url)
            }
        }
            
    }
    
}
