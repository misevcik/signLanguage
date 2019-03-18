//
//  TestAnswer.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 15/03/2019.
//  Copyright © 2019 Zdeno Bacik. All rights reserved.
//

import UIKit

class TestAnswer : UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var rightnessLabel: UILabel!
    @IBOutlet weak var rightnessImage: UIImageView!
    
    private var answerOrder = Int()
    private let answerOrderPrefix = ["a) ", "b) ", "c) "]
    
    func rightAnswerSelected() {
        showRightnessSection(true)
        rightnessLabel.text = Labels.TEST_RIGHT_ANSWER
        rightnessLabel.textColor = #colorLiteral(red: 0.6452309489, green: 0.7849538922, blue: 0.2988059223, alpha: 1)
        rightnessImage.image = #imageLiteral(resourceName: "iconTestOK")
        roundedView.backgroundColor = #colorLiteral(red: 0.8549019608, green: 0.9294117647, blue: 0.7098039216, alpha: 1)
    }
    
    func wrongAnswerSelected() {
        showRightnessSection(true)
        rightnessLabel.text = Labels.TEST_WRONG_ANSWER
        rightnessLabel.textColor = #colorLiteral(red: 0.8919349313, green: 0.3245626688, blue: 0.4429816008, alpha: 1)
        rightnessImage.image = #imageLiteral(resourceName: "iconTestCancel")
        roundedView.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.8862745098, blue: 0.9098039216, alpha: 1)
    }
    
    func markRighAnswer() {
        showRightnessSection(false)
        roundedView.backgroundColor = #colorLiteral(red: 0.8549019608, green: 0.9294117647, blue: 0.7098039216, alpha: 1)
    }
    
    func disableUserInteraction() {
        roundedView.isUserInteractionEnabled = false
    }
    
    func setAnswerOrder(_ order : Int) {
        if answerOrder > 2 {
            answerOrder = 2
        }
        answerOrder = order
    }
    
    func setAnswerText(_ answerText : String) {
        showRightnessSection(false)
        answerLabel.text = answerOrderPrefix[answerOrder] + answerText
    }
    
    func select(_ selected : Bool) {
        if selected == true {
            roundedView.backgroundColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
        } else {
            roundedView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("TestAnswer", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        roundedView.layer.cornerRadius = 14
        
        showRightnessSection(false)
    }
    
    private func showRightnessSection(_ isHidden : Bool) {
        rightnessLabel.isHidden = !isHidden
        rightnessImage.isHidden = !isHidden
    }
    
}
