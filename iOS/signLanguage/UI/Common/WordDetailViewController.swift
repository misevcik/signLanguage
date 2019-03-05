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
    
    @IBOutlet weak var lectionNameLabel: UILabel!
    //@IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var favouriteImage: UIImageView!
    @IBOutlet weak var sentenceTable: UITableView!
    @IBOutlet weak var videoFrame: UIView!
    
    var dbWord : DBWord!
    var dbSentences : Array<DBSentence>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLabels()
        setupImageClick()
        
        if dbWord.videoFront?.isEmpty == false {
            playVideo(videoName: dbWord.videoFront!)
        }
    }
    
    fileprivate func setupImageClick() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.goBack))
        backImage.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func goBack(sender : UITapGestureRecognizer) {
        _ = navigationController?.popViewController(animated: true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    fileprivate func setupLabels() {
        //wordLabel.text = dbWord.word
    }
    
    fileprivate func playVideo(videoName : String) {
        
        if let path = Bundle.main.path(forResource: videoName, ofType: "mp4") {
            let player = AVPlayer(url: URL(fileURLWithPath: path))

            let layer: AVPlayerLayer = AVPlayerLayer(player: player)
            layer.frame = self.videoFrame.bounds
            layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoFrame.layer.addSublayer(layer)
            
            player.play()
            
        }
    }
    
    
}
