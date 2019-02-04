//
//  QuizItem.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 01/02/2019.
//  Copyright © 2019 Zdeno Bacik. All rights reserved.
//

import UIKit

class QuizItem {
    
    var cellImage = UIImage()
    var answerList : [(answer: String, isCorrect: Bool)] = []
    var selectedAnswer : Int = -1
}
