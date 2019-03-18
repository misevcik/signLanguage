//
//  TestResultViewController.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 18/03/2019.
//  Copyright © 2019 Zdeno Bacik. All rights reserved.
//

import UIKit

class TestResultViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    private var testResult : Int = 0
    
    func setTestResult(_ result : Int) {
        testResult = result
    }
    
    @IBAction func clickCancel(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.layer.cornerRadius = 20
        
        let grade = Utils.gradeCalculator(testResult)
        resultLabel.text = "\(testResult) % (\(grade))"
    }

}
