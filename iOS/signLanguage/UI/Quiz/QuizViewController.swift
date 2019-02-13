//
//  QuizViewController.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 29/01/2019.
//  Copyright © 2019 Zdeno Bacik. All rights reserved.
//

import UIKit
import AVKit
import DLRadioButton

class QuizViewController : UIViewController {
    
    //IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var radioButtons: [DLRadioButton]!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var pager: UILabel!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var backwardButton: UIButton!
    
    
    @IBAction func actionForward(_ sender: Any) {
        self.currentPage = self.currentPage + 1
        self.collectionView.scrollToItem(at: IndexPath(item: self.currentPage, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    @IBAction func actionBackward(_ sender: Any) {
        self.currentPage = self.currentPage - 1
        self.collectionView.scrollToItem(at: IndexPath(item: self.currentPage, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    @IBAction func actionOK(_ sender: Any) {
        if selectedRadioButton == -1 {
            print("Alert select the answer")
        } else {
           quizItems[currentPage].selectedAnswer = selectedRadioButton
        }
    }
    

    @IBAction func actionBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func radioButtonsAction(_ sender: DLRadioButton) {
        selectedRadioButton =  sender.tag
        print("selected tag: ", selectedRadioButton)
    }
    
    //Public function
    func setWordArray(_ wordArray : Array<DBWord>) {
        dbWordArray = wordArray
    }
    
    
    //Variables
    fileprivate var dbWordArray = Array<DBWord>()
    fileprivate var quizItems = Array<QuizItem>()
    fileprivate var selectedRadioButton : Int = -1
    
    fileprivate var currentPage: Int = 0 {
        didSet {
            updatePager()
            updateAnswerSection()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO lazy load
        loadQuizData()
        
        self.setupLayout()
        self.currentPage = 0

    }
    
    fileprivate func updateAnswerSection() {
        
        okButton.isHidden = quizItems[currentPage].selectedAnswer != -1

        for index in 0...2 {
            radioButtons[index].isSelected = quizItems[currentPage].selectedAnswer == index
            
            let answer = quizItems[currentPage].answerList[index].answer
            radioButtons[index].setTitle(" " + answer, for: .normal)
        }
    }
    
    fileprivate func updatePager() {
        
        let currentPage = String(self.currentPage + 1)
        let sum = String(self.quizItems.count)
        pager.text = currentPage + "/" + sum
        
    }
    
    fileprivate func getRandomIndexArray() ->Array<Int> {
        
        var indexArray = Array<Int>()
        for _ in 0...radioButtons.count - 1 {
            var random: Int
            repeat {
                random = Int.random(in: 0..<dbWordArray.count - 1)
            } while indexArray.contains(random)
            indexArray.append(random)
        }
        
        return indexArray
    }
    
    fileprivate func loadQuizData() {
        
        let maxQuizItems = dbWordArray.count / 3
        assert(maxQuizItems < radioButtons.count, "Count of quiz items is less than answers")
        
        for _ in 0...maxQuizItems {
            
            let quizItem = QuizItem()
            let defineRightAnswerIndex = Int.random(in: 0..<2)
            let indexArray = getRandomIndexArray()
            
            for i in 0...radioButtons.count - 1 {
            
                let word = dbWordArray[indexArray[i]]
            
                if defineRightAnswerIndex == i {
                    let path = Bundle.main.path(forResource: word.videoFront, ofType: "mp4")
                    quizItem.cellImage = Utils.getVideoFrame(url: URL(fileURLWithPath: path!), at: 1)!
                    quizItem.answerList.append((answer: word.word!, isCorrect: true))
                } else {
                    quizItem.answerList.append((answer: word.word!, isCorrect: false))
                }
            }
            quizItems.append(quizItem)
        }
    }
    
    fileprivate func setupLayout() {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: 30)
    }
    
    fileprivate var pageSize: CGSize {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        pageSize.width += layout.minimumLineSpacing
        return pageSize
    }
    
    fileprivate var orientation: UIDeviceOrientation {
        return UIDevice.current.orientation
    }
}


extension QuizViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return quizItems.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuizCell.reuseIdentifier, for: indexPath as IndexPath) as! QuizCell
        cell.videoFrame.image = quizItems[indexPath.row].cellImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuizCell.reuseIdentifier, for: indexPath as IndexPath) as! QuizCell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollingFinished(scrollView: scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate {
            return
        }
        else {
            scrollingFinished(scrollView: scrollView)
        }
    }
    
    func scrollingFinished(scrollView: UIScrollView) {
        
        let pageSide = self.pageSize.width
        let offset = scrollView.contentOffset.x
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
    }
}
