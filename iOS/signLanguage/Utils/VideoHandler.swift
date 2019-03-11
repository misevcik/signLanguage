//
//  Video.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 11/03/2019.
//  Copyright © 2019 Zdeno Bacik. All rights reserved.
//

import AVKit
import UIKit

class VideoHandler {
    
    fileprivate var playerViewController = AVPlayerViewController()
    fileprivate var videoPreview = UIImageView()
    fileprivate var dbWord : DBWord!
    fileprivate var parent : UIViewController!
    
    init(_ parentController : UIViewController) {
        
        parent = parentController
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerViewController.player?.currentItem)
    }
    
    func setWord(_ word : DBWord) {
        dbWord = word
        
        setVideoData()
    }
    
    func getPreviewImage() ->UIImage {
        return videoPreview.image!
    }
    
    func playVideo() {
        parent.present(playerViewController, animated: true) {
            self.playerViewController.player!.seek(to: .zero)
            self.playerViewController.player!.play()
        }
    }
    
    func changeVideoSpeed(_ speed : Float) {
        
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
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        playerViewController.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func setVideoData() {
        if dbWord.videoFront?.isEmpty == false {
            let videoPath = Bundle.main.path(forResource: dbWord.videoFront!, ofType: "mp4")!
            let videoUrl = URL(fileURLWithPath: videoPath)
            videoPreview.image = Utils.getVideoImage(url: videoUrl, at: 0)
            
            playerViewController.player = AVPlayer(url: videoUrl)
            
        } else {
            videoPreview.image = UIImage()
            playerViewController.player = AVPlayer()
        }
    }
    
    
    
}
