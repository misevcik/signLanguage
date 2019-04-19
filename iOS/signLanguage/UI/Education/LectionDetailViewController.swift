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
    
    var callbackSaveCoreData: (()->())?

    @IBOutlet weak var pagerLabel: UILabel!
    @IBOutlet weak var sentenceTable: UITableView!
    @IBOutlet weak var sentenceLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var videoController: VideoController!
    
    private var playerViewController = AVPlayerViewController()
    private var dbLection : DBLesson!
    private var dbWordArray = Array<DBWord>()
    private var dbWord : DBWord!
    private var videoHandler : VideoHandler!
    private var goToPage : Int = 0
    
    //Variable used for progress bar
    private var wordVisitUpdate = false
    
    func setLection(_ lection : DBLesson) {
        dbLection = lection
    }
    
    func setPage(_ page : Int) {
        goToPage = page
    }
    
    @IBAction func clickBack(_ sender: Any) {
        
        if lectionVisitor() == true {
            callbackSaveCoreData!()
        }

        _ = navigationController?.popViewController(animated: true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private var currentPage: Int = 0 {
        didSet {
            dbWord = dbWordArray[currentPage]
            
            wordVisitor(dbWord)
            
            updatePager()
            updateButtons()
            updatePageData()
        }
    }
    
    private func lectionVisitor() -> Bool {
        
        if wordVisitUpdate == true {
            
            var count : Int = 0
            for dbWord in dbWordArray {
                if dbWord.visited == true {
                    count += 1
                }
            }
            
            if dbLection.visitedWord < count {
                dbLection.visitedWord = Int32(count)
            }
            
            return true
        }
        
        return false
    }
    
    private func wordVisitor(_ word : DBWord) {
        
        if dbWord.visited == false {
            dbWord.visited = true
            wordVisitUpdate = true
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoHandler = VideoHandler(self)
        videoController.delegate = self
   
        loadLectionData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerViewController.player?.currentItem)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sentenceTable.indexPathsForSelectedRows?.forEach {
            sentenceTable.deselectRow(at: $0, animated: true)
        }
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        playerViewController.dismiss(animated: true, completion: nil)
    }
    
    private func updatePageData() {
        updateTableLayout()
        updateVideoFrame()
        
        wordLabel.text = dbWord.word
    }

    private func updateTableLayout() {
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
    
    private func updateVideoFrame() {
        videoHandler.setVideoPath(dbWord.videoFront!)
        videoImage.image = videoHandler.getPreviewImage()
        videoImage.clipsToBounds = true
        videoImage.contentMode = .scaleAspectFill
    }
    
    private func loadLectionData() {
        
        for item in dbLection.relDictionary! {
            dbWordArray.append(item as! DBWord)
        }
        
        wordLabel.text = dbLection.title
        currentPage = goToPage
    }
    
    private func updatePager() {
        
        let currentPage = String(self.currentPage + 1)
        let sum = String(self.dbWordArray.count)
        pagerLabel.text = currentPage + "/" + sum
    }
    
    private func updateButtons() {
        
//        moveBackward.isHidden = self.currentPage == 0
//        moveForward.isHidden = self.currentPage == self.dbWordArray.count - 1
    }
    
    private func playVideo() {
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
        let videoUrl = Bundle.main.url(forResource: sentence.video, withExtension: "mp4")!
        
        let player = AVPlayer(url: videoUrl)
        playerViewController.player = player
        
        self.present(playerViewController, animated: true) {
            self.playerViewController.player?.play()
        }
        
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

