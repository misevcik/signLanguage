//
//  LectionDetailViewController.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 11/03/2019.
//  Copyright © 2019 Zdeno Bacik. All rights reserved.
//

import UIKit
import CoreData
import AVKit

class LessonDetailViewController : UIViewController {

    @IBOutlet weak var sentenceTable: UITableView!
    @IBOutlet weak var sentenceLabel: UILabel!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var lessonName: UILabel!
    @IBOutlet weak var videoController: VideoController!
    
    fileprivate var dbLesson : DBLesson!
    fileprivate var dbWordArray = Array<DBWord>()
    fileprivate var dbWord : DBWord!
    fileprivate var videoHandler : VideoHandler!
    
    func setLesson(_ lesson : DBLesson) {
        dbLesson = lesson
    }
    
    @IBAction func clickBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    fileprivate var currentPage: Int = 0 {
        didSet {
            dbWord = dbWordArray[currentPage]
            
            updatePager()
            updateButtons()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoHandler = VideoHandler(self)
        
        videoController.delegate = self
   
        loadLectionData()
        fillViewData()
    }
    
    fileprivate func fillViewData() {
        setTableLayout()
        setVideo()
    }
    
    fileprivate func setTableLayout() {
        if dbWord.relSentence!.count == 0 {
            sentenceTable.isHidden = true
            sentenceLabel.isHidden = true
        } else {
            sentenceTable.isHidden = false
            sentenceLabel.isHidden = false
            sentenceTable.tableFooterView = UIView()
        }
    }
    
    fileprivate func setVideo() {
        videoHandler.setWord(dbWord)
        videoImage.image = videoHandler.getPreviewImage()
    }
    
    fileprivate func loadLectionData() {
        
        for item in dbLesson.relDictionary! {
            dbWordArray.append(item as! DBWord)
        }
        
        currentPage = 0
        lessonName.text = dbLesson.title
    }
    
    fileprivate func updatePager() {
        
//        selectedDictionary.text = self.dbWordArray[self.currentPage].word
//
//        let currentPage = String(self.currentPage + 1)
//        let sum = String(self.dbWordArray.count)
//        pager.text = currentPage + "/" + sum
    }
    
    fileprivate func updateButtons() {
        
//        moveBackward.isHidden = self.currentPage == 0
//        moveForward.isHidden = self.currentPage == self.dbWordArray.count - 1
    }
    
    fileprivate func playVideo() {
        videoHandler.playVideo()
    }

}

extension LessonDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dbWord.relSentence!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SentenceCell.reuseIdentifier, for: indexPath) as? SentenceCell else {
            fatalError("Unexpected Index Path")
        }
        
        let sentence = dbWord.relSentence!.allObjects[indexPath.row] as! DBSentence
        cell.sentence.text = sentence.sentence
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sentence = dbWord.relSentence!.allObjects[indexPath.row] as! DBSentence
        //playVideo(videoName: sentence.video!)
        
    }
}

extension LessonDetailViewController : VideoControllerProtocol {
    
    func clickForward() {
        self.currentPage = self.currentPage + 1
        fillViewData()
    }
    
    func clickBackward() {
        self.currentPage = self.currentPage - 1
        fillViewData()
    }
    
    func clickPlayVideo() {
        playVideo()
    }
    
    func clickSideVideo(_ isSelected : Bool) {
    }
    
    func clickSlowDown(_ isSelected : Bool) {
        videoHandler.changeVideoSpeed(isSelected ? 0.5 : 1.0)
    }
}

