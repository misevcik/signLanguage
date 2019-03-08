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
    
    @IBOutlet weak var lectionNameLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var sentenceTable: UITableView!
    @IBOutlet weak var videoFrame: UIView!
    @IBOutlet weak var videoController: VideoController!
    
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
    
    fileprivate var dbWord : DBWord!
    fileprivate var playerViewController = AVPlayerViewController()
    fileprivate var fetchedResultsController: NSFetchedResultsController<DBWord>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoController.delegate = self
        sentenceTable.tableFooterView = UIView()
        
        loadLabel()
        loadVideo()
    }
    
    fileprivate func loadVideo() {
        if dbWord.videoFront?.isEmpty == false {
            showVideo(videoName: dbWord.videoFront!)
        }
    }
    
    fileprivate func loadLabel() {
        wordLabel.text = dbWord.word
    }
    
    fileprivate func showVideo(videoName : String) {
        
        if let path = Bundle.main.path(forResource: videoName, ofType: "mp4") {
            
            let player = AVPlayer(url: URL(fileURLWithPath: path))
            
            //playerViewController.showsPlaybackControls = true
            playerViewController.player = player
            playerViewController.view.frame = videoFrame.bounds
            playerViewController.view.backgroundColor = #colorLiteral(red: 0.9656763673, green: 0.965699017, blue: 0.9656868577, alpha: 1)
            playerViewController.videoGravity = AVLayerVideoGravity.resizeAspect
            self.addChild(playerViewController)
            videoFrame.addSubview(playerViewController.view)
            playerViewController.didMove(toParent: self)
        }
    }
    
}

extension WordDetailViewController : VideoControllerProtocol {

    func clickForward() {
        
        let indexPath =  self.fetchedResultsController.indexPath(forObject: dbWord)
        let nextIndexPath = callbackNextIndexPath!(indexPath!)

        let nextDbWord = fetchedResultsController.object(at: nextIndexPath!)
        dbWord = nextDbWord
        
        loadVideo()
        loadLabel()
        sentenceTable.reloadData()
    }

    func clickBackward() {

    }

    func clickSideVideo() {

    }

    func clickSlowDown() {

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
