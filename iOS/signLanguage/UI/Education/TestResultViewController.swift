//
//  TestResultViewController.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 18/03/2019.
//  Copyright © 2019 Zdeno Bacik. All rights reserved.
//

import UIKit

class TestResultViewController: UIViewController {

    var resetTestCallback: (() -> Void)?
    
    @IBOutlet weak var timeResultLabel: UILabel!
    @IBOutlet weak var thumbsImage: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var countRightAnswers: UILabel!
    @IBOutlet weak var countWrongAnswers: UILabel!
    @IBOutlet weak var recomendationLabel: UILabel!
    @IBOutlet weak var cancelIcon: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBAction func resetButtonClick(_ sender: Any) {
        
        resetTestCallback!()
    }
    
    @IBAction func cancelButtonClick(_ sender: Any) {
        
        popResultView()
    }
    
    @IBAction func cancelIconClick(_ sender: Any) {
        
        popResultView()
    }
    
    private var date : Date = Date()
    private var score : Int = 0
    private var timeDuration : Int = 0
    private var rightAnswers = 0
    private var wrongAnswers = 0
    private var goFromTestDetail = false
    private let cRecommendGood = "Test úspešny, možete isť na dalšiu lekciu"
    private let cRecommendWrong = "Mali by ste si ešte zopakovať lekciu aby ste sa zdokonalili"
    private let cRecommendBad = "Test neúspešny. Zopakujte si lekciu."

    
    func popResultView() {
        
        if goFromTestDetail == true {
            popViewControllers(popViews: 2, animated: true)
        } else {
            popViewControllers(popViews: 1, animated: true)
        }
    }
    
    func goFromTestDetailView() {
        goFromTestDetail = true
    }
    
    func setLectionData(_ lection : DBLesson) {
        
        let answerCount = (lection.relDictionary!.count / 3) + 1
        
        timeDuration = Int(lection.testDuration)
        rightAnswers = Int((Float(answerCount) / 100.0 * Float(lection.testScore)).rounded())
        wrongAnswers = answerCount - rightAnswers
        score = Int(lection.testScore)
        date = lection.testDate!
    }
    
    @IBAction func clickCancel(_ sender: Any) {
        popResultView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.layer.cornerRadius = 15
        cancelButton.layer.cornerRadius = cancelButton.bounds.height / 3
        resetButton.layer.cornerRadius = resetButton.bounds.height / 3
        resetButton.layer.borderWidth = 2
        resetButton.layer.borderColor = #colorLiteral(red: 0.5160872936, green: 0.8872948289, blue: 0.9788959622, alpha: 1)
        
        
        setResultData()
        
    }
    
    private func setResultData() {
        
        let grade = Utils.gradeCalculator(score)
        let time = TimeInterval(timeDuration)
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        if goFromTestDetail == true {
            timeLabel.text = "Čas"
            timeResultLabel.text = String(format:"%02i:%02i", minutes, seconds)
            cancelIcon.imageView?.image = #imageLiteral(resourceName: "iconCancelWhite")
        } else {
            timeLabel.text = "Dátum"
            timeResultLabel.text = dateFormatter.string(from: date)
            cancelIcon.imageView?.image = #imageLiteral(resourceName: "iconBackWhite")
        }
        
        scoreLabel.text = "\(score) % (\(grade))"
        countRightAnswers.text = String(rightAnswers)
        countWrongAnswers.text = String(wrongAnswers)
        if(score >= 80) {
            recomendationLabel.text = cRecommendGood
        } else if (score >= 50 && score < 80){
            recomendationLabel.text = cRecommendWrong
        } else {
            recomendationLabel.text = cRecommendBad
        }
        
        if(score >= 50) {
            thumbsImage.image = #imageLiteral(resourceName: "thumbsUp")
        } else {
            thumbsImage.image = #imageLiteral(resourceName: "thumbsDown")
        }
    }
    
    private func popViewControllers(popViews: Int, animated: Bool = true) {
        if self.navigationController!.viewControllers.count > popViews
        {
            let vc = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - popViews - 1]
            self.navigationController?.popToViewController(vc, animated: animated)
        }
        self.navigationController?.isNavigationBarHidden = true
    }
}
