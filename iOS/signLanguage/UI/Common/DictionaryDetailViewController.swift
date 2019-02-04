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

class DictionaryDetailViewController : UIViewController {
    
    //MARK Outlets
    @IBAction func actionPlay(_ sender: Any) {
        playVideo()
    }
    
    @IBAction func actionBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBOutlet weak var dictionary: UILabel!
    @IBOutlet weak var dictionaryLevel: UILabel!
    
    //MARK - local variables
    var dbDictionary : DBDictionary!
    var dbSentences : Array<DBSentence>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        dictionary.text = dbDictionary.dictionary
        dictionaryLevel.text = String(describing: dbDictionary.level)
    }
    
    fileprivate func playVideo() {
        
        if let path = Bundle.main.path(forResource: "SampleVideo", ofType: "mp4") {
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

extension DictionaryDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dbDictionary.relSentence!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SentenceCell.reuseIdentifier, for: indexPath) as? SentenceCell else {
            fatalError("Unexpected Index Path")
        }
        
        let sentence = dbDictionary.relSentence!.allObjects[indexPath.row]
        cell.sentence.text = (sentence as! DBSentence).detail
        
        return cell
    }
    

}
