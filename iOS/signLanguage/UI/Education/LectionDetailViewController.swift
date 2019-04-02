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

class LectionDetailViewController : UIViewController {

    @IBOutlet weak var pagerLabel: UILabel!
    @IBOutlet weak var sentenceTable: UITableView!
    @IBOutlet weak var sentenceLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var videoController: VideoController!
    
    fileprivate var dbLection : DBLesson!
    fileprivate var dbWordArray = Array<DBWord>()
    fileprivate var dbWord : DBWord!
    fileprivate var videoHandler : VideoHandler!
    fileprivate var goToPage : Int = 0
    
    func setLection(_ lection : DBLesson) {
        dbLection = lection
    }
    
    func setPage(_ page : Int) {
        goToPage = page
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
            updatePageData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoHandler = VideoHandler(self)
        videoController.delegate = self
   
        loadLectionData()
    }
    
    fileprivate func updatePageData() {
        updateTableLayout()
        updateVideoFrame()
        
        wordLabel.text = dbWord.word
    }

    fileprivate func updateTableLayout() {
        if dbWord.relSentence!.count == 0 {
            sentenceTable.isHidden = true
            sentenceLabel.isHidden = true
        } else {
            sentenceTable.isHidden = false
            sentenceLabel.isHidden = false
            sentenceTable.tableFooterView = UIView()
        }
        
        sentenceTable.reloadData()
    }
    
    fileprivate func updateVideoFrame() {
        videoHandler.setVideoPath(dbWord.videoFront!)
        videoImage.image = videoHandler.getPreviewImage()
        videoImage.clipsToBounds = true
        videoImage.contentMode = .scaleAspectFill
    }
    
    fileprivate func loadLectionData() {
        
        for item in dbLection.relDictionary! {
            dbWordArray.append(item as! DBWord)
        }
        
        wordLabel.text = dbLection.title
        currentPage = goToPage
    }
    
    fileprivate func updatePager() {
        
        let currentPage = String(self.currentPage + 1)
        let sum = String(self.dbWordArray.count)
        pagerLabel.text = currentPage + "/" + sum
    }
    
    fileprivate func updateButtons() {
        
//        moveBackward.isHidden = self.currentPage == 0
//        moveForward.isHidden = self.currentPage == self.dbWordArray.count - 1
    }
    
    fileprivate func playVideo() {
        videoHandler.playVideo()
    }

}

extension LectionDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
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

extension LectionDetailViewController : VideoControllerProtocol {
    
    func clickForward() {
        
        if self.currentPage == dbWordArray.count - 1 {
            self.currentPage = 0
        } else {
            self.currentPage = self.currentPage + 1
        }
        
    }
    
    func clickBackward() {
        
        if self.currentPage == 0 {
            self.currentPage = dbWordArray.count - 1
        } else {
            self.currentPage = self.currentPage - 1
        }
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

