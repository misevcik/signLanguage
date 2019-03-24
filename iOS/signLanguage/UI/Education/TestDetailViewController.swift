//
//  TestDetailViewController.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 14/03/2019.
//  Copyright © 2019 Zdeno Bacik. All rights reserved.
//

import UIKit

struct TestItem {
    var answerList : [(answer: String, isCorrect: Bool)] = []
    var selectedAnswer : Int = -1
}

class TestDetailViewController: UIViewController {
    
    var saveTestResult: (() -> Void)?
    
    @IBOutlet weak var pagerLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet var answerCollection: [TestAnswer]!
    
    @IBAction func clickBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setLection(_ lection : DBLesson) {
        dbLection = lection
    }
    
    private var dbLection : DBLesson!
    private var testItemArray = Array<TestItem>()
    private var durationTimer = Timer()
    private var seconds = 0
    private var correctAnswerCount = 0
    
    private var currentPage: Int = 0 {
        didSet {
            updateAnswers()
            updatePager()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var gesture = [UITapGestureRecognizer](repeating: UITapGestureRecognizer(), count: 3)
        
        prepareTestData()
        runDurationTimer()
        
        
        for i in 0 ..< answerCollection.count {
            gesture[i] = UITapGestureRecognizer(target: self, action:  #selector(self.selectAnswer))
            answerCollection[i].addGestureRecognizer(gesture[i])
            answerCollection[i].setAnswerOrder(i)
        }
    
        currentPage = 0
    }
    
    func runDurationTimer() {
        durationTimer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateDurationTimer)), userInfo: nil, repeats: true)
    }
    
     @objc func updateDurationTimer() {
        
        self.seconds += 1
        
        let time = TimeInterval(self.seconds)
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        timerLabel.text = String(format:"%02i:%02i", minutes, seconds)
    }
    
    @objc func selectAnswer(sender : UITapGestureRecognizer) {
        for i in 0 ..< answerCollection.count {
            answerCollection[i].select(i == sender.view!.tag)
            testItemArray[currentPage].selectedAnswer = sender.view!.tag
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.updateAnswers()
            self.goNext()
        })
    }
    
    private func updatePager() {
        pagerLabel.text = "\(currentPage + 1). otázka z \(testItemArray.count)"
    }
    
    private func goNext() {
        
        if currentPage == testItemArray.count - 1 {
            processResult()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                self.currentPage += 1
            })
        }
    }
    
    private func updateAnswers() {
        
        let data = testItemArray[currentPage]
        var indexOfRightAnswer = -1
        
        for i in 0 ..< answerCollection.count {
            answerCollection[i].setAnswerText(data.answerList[i].answer)
            answerCollection[i].select(false)
            
            if data.answerList[i].isCorrect == true {
                indexOfRightAnswer = i
            }
        }
        
        //Has answer
        if data.selectedAnswer != -1 {
            let isAnswerCorrect = data.answerList[data.selectedAnswer].isCorrect
            
            if isAnswerCorrect == true {
                answerCollection[data.selectedAnswer].rightAnswerSelected()
                correctAnswerCount += 1
            } else {
                answerCollection[data.selectedAnswer].wrongAnswerSelected()
                answerCollection[indexOfRightAnswer].markRighAnswer()
            }
    
            for i in 0 ..< answerCollection.count {
                answerCollection[i].disableUserInteraction()
            }
        }
    }
    
    private func prepareTestData() {
        let wordArray = dbLection.relDictionary?.allObjects as! [DBWord]
        
        let maxQuizItems = wordArray.count / 3
        assert(maxQuizItems < answerCollection.count || maxQuizItems <= 1, "Count of quiz items is less than answers")
        
        for _ in 0...maxQuizItems {
            
            var testData = TestItem()
            let defineRightAnswerIndex = Int.random(in: 0..<2)
            let indexArray = getRandomIndexArray(wordArray.count)
            
            for i in 0...answerCollection.count - 1 {
                
                let word = wordArray[indexArray[i]]
                
                if defineRightAnswerIndex == i {
                    let path = Bundle.main.path(forResource: word.videoFront, ofType: "mp4")
                    //testData.cellImage = Utils.getVideoImage(url: URL(fileURLWithPath: path!), at: 0)!
                    testData.answerList.append((answer: word.word!, isCorrect: true))
                } else {
                    testData.answerList.append((answer: word.word!, isCorrect: false))
                }
            }
            testItemArray.append(testData)
        }
        
    }
    
    
    private func getRandomIndexArray(_ maxRange : Int) ->Array<Int> {
        
        var indexArray = Array<Int>()
        for _ in 0...answerCollection.count - 1 {
            var random: Int
            repeat {
                random = Int.random(in: 0..<maxRange - 1)
            } while indexArray.contains(random)
            indexArray.append(random)
        }
        
        return indexArray
    }
    
    private func processResult() {
        
        durationTimer.invalidate()
        let score : Int = Int(Float(correctAnswerCount) / Float(testItemArray.count) * 100)
        
        dbLection.testScore = Int32(score)
        dbLection.testDate = Date()
        dbLection.testDuration = Int32(seconds)
        
        saveTestResult!()
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TestResultViewController") as! TestResultViewController
        vc.goFromTestDetailView()
        vc.setScore(score)
        vc.setTestDuration(seconds)
        vc.setAnswerCount(correctAnswerCount, testItemArray.count - correctAnswerCount)
        self.show(vc, sender: true)
    }
}

