//
//  Utils.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 01/02/2019.
//  Copyright © 2019 Zdeno Bacik. All rights reserved.
//

import UIKit
import AVKit

class Utils {
    
    static func getVideoFrame(url: URL, at time: TimeInterval) -> UIImage? {
        let asset = AVURLAsset(url: url)
        
        let assetIG = AVAssetImageGenerator(asset: asset)
        assetIG.appliesPreferredTrackTransform = true
        assetIG.apertureMode = AVAssetImageGenerator.ApertureMode.encodedPixels
        
        let cmTime = CMTime(seconds: time, preferredTimescale: 60)
        let image: CGImage
        do {
            image = try assetIG.copyCGImage(at: cmTime, actualTime: nil)
        } catch let error {
            print("Error: \(error)")
            return nil
        }
        
        return UIImage(cgImage: image)
    }
    
}
