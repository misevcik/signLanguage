//
//  DictionaryDetailViewController.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 03/01/2019.
//  Copyright © 2019 Zdeno Bacik. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import CoreData

class WordDetailViewController : UIViewController {
    
    //MARK Outlets
    @IBAction func actionPlay(_ sender: Any) {
        playVideo()
    }
    
    @IBAction func actionBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBOutlet weak var word: UILabel!
    @IBOutlet weak var wordLevel: UILabel!
    
    //MARK - local variables
    var dbWord : DBWord!
    var dbSentences : Array<DBSentence>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        word.text = dbWord.word
        wordLevel.text = String(describing: dbWord.level)
    }
    
    fileprivate func playVideo() {
        
        if dbWord.videoFront?.isEmpty == true {
            return
        }
        
        if let path = Bundle.main.path(forResource: dbWord.videoFront, ofType: "mp4") {
            let video = AVPlayer(url: URL(fileURLWithPath: path))
            let videoPlayer = AVPlayerViewController()
            videoPlayer.player = video
            
            present(videoPlayer, animated: true, completion: {
                video.play()
                //video.playImmediately(atRate: 0.50)
            })
        }
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
        
        let sentence = dbWord.relSentence!.allObjects[indexPath.row]
        cell.sentence.text = (sentence as! DBSentence).sentence
        
        return cell
    }
    

}
