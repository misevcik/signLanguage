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

protocol WordDetailDelegate {
    func saveCoreData(viewController: WordDetailViewController)
    func nextWord(word : DBWord, forward: Bool, context: NSManagedObjectContext) ->DBWord
}

class WordDetailViewController : UIViewController {
    

    var dbWord : DBWord!
    var indexPath : IndexPath!
    var context: NSManagedObjectContext!
    var delegate: WordDetailDelegate?
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var lectionNameLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var sentenceTable: UITableView!
    @IBOutlet weak var sentenceLabel: UILabel!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var videoController: VideoController!
    
    private var sentenceVideoPlayer = AVPlayerViewController()
    private var videoHandler : VideoHandler!
    private var isSideVideo : Bool = false
    private var isSlowDownVideo : Bool = false
    
    @IBAction func clickBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func clickToFavorite(_ sender: UIButton) {
        dbWord.favorite = !dbWord.favorite
        updateFavoriteButton(dbWord.favorite)
        delegate?.saveCoreData(viewController: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoHandler = VideoHandler(self)
        
        videoController.delegate = self
        
        updatePageData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: sentenceVideoPlayer.player?.currentItem)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sentenceTable.indexPathsForSelectedRows?.forEach {
            sentenceTable.deselectRow(at: $0, animated: true)
        }
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        sentenceVideoPlayer.dismiss(animated: true, completion: nil)
    }

}

extension WordDetailViewController : VideoControllerProtocol {

    func clickForward() {
        
        dbWord = delegate?.nextWord(word : dbWord, forward: true, context: context)
        updatePageData()
    }

    func clickBackward() {
        dbWord = delegate?.nextWord(word : dbWord, forward: false, context: context)
        updatePageData()
    }
    
    func clickPlayVideo() {
        videoHandler.playVideo()
    }

    func clickSideVideo(_ isSelected : Bool) {
        isSideVideo = isSelected
        updateVideoFrame()
    }

    func clickSlowDown(_ isSelected : Bool) {
        isSlowDownVideo = isSelected
        videoHandler.changeVideoSpeed(isSlowDownVideo ? 0.5 : 1.0)
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
        let videoUrl = Bundle.main.url(forResource: sentence.video, withExtension: "mp4")!
        
        let player = AVPlayer(url: videoUrl)
        sentenceVideoPlayer.player = player
        
        self.present(sentenceVideoPlayer, animated: true) {
            self.sentenceVideoPlayer.player?.play()
        }        
    }
}

private extension WordDetailViewController {
    private func updatePageData() {
        updateTableLayout()
        updateWordLabel()
        updateVideoFrame()
        updateFavoriteButton(dbWord.favorite)
    }
    
    private func updateFavoriteButton(_ isFavorite : Bool) {
        if isFavorite == true {
            favoriteButton.setImage(#imageLiteral(resourceName: "iconHeart-red"), for: UIControl.State.normal)
        } else {
            favoriteButton.setImage(#imageLiteral(resourceName: "iconHeart-black"), for: UIControl.State.normal)
        }
    }
    
    private func updateVideoFrame() {
        let videoPath = isSideVideo ? self.dbWord.videoSide! : self.dbWord.videoFront!
        
        videoHandler.setVideoPath(videoPath)
        if isSlowDownVideo == true {
            videoHandler.changeVideoSpeed(0.5)
        }
        videoImage.image = videoHandler.getPreviewImage()
        videoImage.clipsToBounds = true
        videoImage.contentMode = .scaleAspectFill
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
    
    private func updateWordLabel() {
        wordLabel.text = dbWord.word
    }
}

