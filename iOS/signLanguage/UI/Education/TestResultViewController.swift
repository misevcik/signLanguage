//
//  TestResultViewController.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 18/03/2019.
//  Copyright © 2019 Zdeno Bacik. All rights reserved.
//

import UIKit

class TestResultViewController: UIViewController {

    
    @IBOutlet weak var testDate: UILabel!
    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var countRightAnswers: UILabel!
    @IBOutlet weak var countWrongAnswers: UILabel!
    @IBOutlet weak var recomendationLabel: UILabel!
    
    @IBAction func repeatTestClick(_ sender: Any) {
    }
    
    @IBAction func cancelTestClick(_ sender: Any) {
    }
    
    @IBAction func cancelIconClick(_ sender: Any) {
        
        if goFromTestDetail == true {
            popViewControllerss(popViews: 2, animated: true)
        } else {
            popViewControllerss(popViews: 1, animated: true)
        }
    }
    
    private var score : Int = 0
    private var timeDuration : Int = 0
    private var rightAnswers = 0
    private var wrongAnswers = 0
    private var goFromTestDetail = false
    
    func goFromTestDetailView() {
        goFromTestDetail = true
    }
    
    func setScore(_ scoreArg : Int) {
        score = scoreArg
    }
    
    func setTestDuration(_ timeDurationArg : Int) {
        timeDuration = timeDurationArg
    }
    
    func setAnswerCount(_ rightAnswersArg : Int, _ wrongAnswersArg: Int) {
        rightAnswers = rightAnswersArg
        wrongAnswers = wrongAnswersArg
    }
    
    @IBAction func clickCancel(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.layer.cornerRadius = 20
        
        fillResultData()
        
    }
    
    private func fillResultData() {
        
        let grade = Utils.gradeCalculator(score)
        let time = TimeInterval(timeDuration)
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        timeLabel.text = String(format:"%02i:%02i", minutes, seconds)
        scoreLabel.text = "\(score) % (\(grade))"
        countRightAnswers.text = String(rightAnswers)
        countWrongAnswers.text = String(wrongAnswers)
    }
    
    private func popViewControllerss(popViews: Int, animated: Bool = true) {
        if self.navigationController!.viewControllers.count > popViews
        {
            let vc = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - popViews - 1]
            self.navigationController?.popToViewController(vc, animated: animated)
        }
        self.navigationController?.isNavigationBarHidden = true
    }


}
