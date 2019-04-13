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
    var callbackSaveCoreData: (()->())?
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var lectionNameLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var sentenceTable: UITableView!
    @IBOutlet weak var sentenceLabel: UILabel!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var videoController: VideoController!
    
    fileprivate var dbWord : DBWord!
    fileprivate var fetchedResultsController: NSFetchedResultsController<DBWord>!
    fileprivate var videoHandler : VideoHandler!
    
    @IBAction func clickBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func clickToFavorite(_ sender: UIButton) {
        dbWord.favorite = !dbWord.favorite
        updateFavoriteButton(dbWord.favorite)
        callbackSaveCoreData!()
    }
    
    func setWord(_ word : DBWord) {
        dbWord = word
    }
    
    func setFetchController(_ fetchController : NSFetchedResultsController<DBWord>) {
        fetchedResultsController = fetchController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoHandler = VideoHandler(self)
        
        videoController.delegate = self
        
        updatePageData()
    }
    
    fileprivate func updatePageData() {
        updateTableLayout()
        updateWordLabel()
        updateVideoFrame()
        updateFavoriteButton(dbWord.favorite)
    }
    
    fileprivate func updateFavoriteButton(_ isFavorite : Bool) {
        if isFavorite == true {
            favoriteButton.setImage(#imageLiteral(resourceName: "iconHeart-red"), for: UIControl.State.normal)
        } else {
            favoriteButton.setImage(#imageLiteral(resourceName: "iconHeart-black"), for: UIControl.State.normal)
        }
    }
    
    fileprivate func updateVideoFrame() {
        videoHandler.setVideoPath(self.dbWord.videoFront!)
        videoImage.image = videoHandler.getPreviewImage()
        videoImage.clipsToBounds = true
        videoImage.contentMode = .scaleAspectFill
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
    
    fileprivate func updateWordLabel() {
        wordLabel.text = dbWord.word
    }
}

extension WordDetailViewController : VideoControllerProtocol {

    func clickForward() {
        
        let indexPath =  self.fetchedResultsController.indexPath(forObject: dbWord)
        let nextIndexPath = callbackNextIndexPath!(indexPath!)

        let nextDbWord = fetchedResultsController.object(at: nextIndexPath!)
        dbWord = nextDbWord
        
        updatePageData()
    }

    func clickBackward() {
        let indexPath =  self.fetchedResultsController.indexPath(forObject: dbWord)
        let nextIndexPath = callbackPrevIndexPath!(indexPath!)
        
        let nextDbWord = fetchedResultsController.object(at: nextIndexPath!)
        dbWord = nextDbWord
        
        updatePageData()
    }
    
    func clickPlayVideo() {
        videoHandler.playVideo()
    }

    func clickSideVideo(_ isSelected : Bool) {
    }

    func clickSlowDown(_ isSelected : Bool) {
        
        videoHandler.changeVideoSpeed(isSelected ? 0.5 : 1.0)
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
