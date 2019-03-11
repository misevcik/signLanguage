//
//  WordDetailViewController.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 04/03/2019.
//  Copyright © 2019 Zdeno Bacik. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit
import CoreData

class WordDetailViewController : UIViewController {
    
    //Callback
    var callbackNextIndexPath: ((_ currentIndexPath: IndexPath) -> IndexPath?)?
    var callbackPrevIndexPath: ((_ currentIndexPath: IndexPath) -> IndexPath?)?
    
    @IBOutlet weak var lectionNameLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var sentenceTable: UITableView!
    @IBOutlet weak var sentenceLabel: UILabel!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var videoController: VideoController!
    
    fileprivate var dbWord : DBWord!
    fileprivate var fetchedResultsController: NSFetchedResultsController<DBWord>!
    //Video player
    fileprivate var  playerViewController = AVPlayerViewController()
    fileprivate var videoRate : Float = 1.0
    
    @IBAction func clickBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setWord(_ word : DBWord) {
        dbWord = word
    }
    
    func setFetchController(_ fetchController : NSFetchedResultsController<DBWord>) {
        fetchedResultsController = fetchController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoController.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerViewController.player?.currentItem)

        setLayout()
    }
    
    fileprivate func setLayout() {
        setTableLayout()
        setWordLabel()
        setVideoData()
    }
    
    fileprivate func setVideoData() {
        if dbWord.videoFront?.isEmpty == false {
            let videoPath = Bundle.main.path(forResource: dbWord.videoFront!, ofType: "mp4")!
            let videoUrl = URL(fileURLWithPath: videoPath)
            videoImage.image = Utils.getVideoImage(url: videoUrl, at: 0)
            
            playerViewController.player = AVPlayer(url: videoUrl)
            
        } else {
            videoImage.image = UIImage()
            playerViewController.player = AVPlayer()
        }
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
        
        sentenceTable.reloadData()
    }
    
    fileprivate func setWordLabel() {
        wordLabel.text = dbWord.word
    }
    
    fileprivate func changeVideoSpeed(_ speed : Float) {

        guard let asset = self.playerViewController.player!.currentItem?.asset else {
            return
        }

        let composition = AVMutableComposition()
        let assetTimeRange = CMTimeRangeMake(start: CMTime.zero, duration: asset.duration)

        do {
            try composition.insertTimeRange(assetTimeRange, of: asset, at: CMTime.zero)
            let destinationTimeRange = CMTimeMultiplyByFloat64(asset.duration, multiplier: Float64(1 / speed))
            composition.scaleTimeRange(assetTimeRange, toDuration: destinationTimeRange)
            let item = AVPlayerItem(asset: composition)
            self.playerViewController.player!.replaceCurrentItem(with: item)
        } catch {
            print("Inserting time range failed. ", error)
        }
    }
    
    fileprivate func playVideo() {
        self.present(playerViewController, animated: true) {
            self.playerViewController.player!.seek(to: .zero)
            self.playerViewController.player!.play()
        }
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        playerViewController.dismiss(animated: true, completion: nil)
    }
}

extension WordDetailViewController : VideoControllerProtocol {

    func clickForward() {
        
        let indexPath =  self.fetchedResultsController.indexPath(forObject: dbWord)
        let nextIndexPath = callbackNextIndexPath!(indexPath!)

        let nextDbWord = fetchedResultsController.object(at: nextIndexPath!)
        dbWord = nextDbWord
        
        setLayout()
    }

    func clickBackward() {
        let indexPath =  self.fetchedResultsController.indexPath(forObject: dbWord)
        let nextIndexPath = callbackPrevIndexPath!(indexPath!)
        
        let nextDbWord = fetchedResultsController.object(at: nextIndexPath!)
        dbWord = nextDbWord
        
        setLayout()
    }
    
    func clickPlayVideo() {
        playVideo()
    }

    func clickSideVideo(_ isSelected : Bool) {
    }

    func clickSlowDown(_ isSelected : Bool) {
        
        changeVideoSpeed(isSelected ? 0.5 : 1.0)
    }
}

extension WordDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
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
