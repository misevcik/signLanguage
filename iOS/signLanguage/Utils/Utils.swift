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
    
    static func getVideoImage(url: URL, at time: TimeInterval) -> UIImage? {
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
    
    
    static func gradeCalculator(_ result : Int) -> String {
        if result < 50 {
            return "F"
        } else if 50 <= result && result < 60 {
            return "E"
        } else if 60 <= result && result < 70 {
            return "D"
        } else if 70 <= result && result < 80 {
            return "C"
        } else if 80 <= result && result < 90 {
            return "B"
        } else {
            return "A"
        }
    }
    
}

extension UIImage {
    func createSelectionIndicator(color: UIColor, size: CGSize, lineWidth: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: lineWidth))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension UITableView {
    func lastIndexpath() -> IndexPath {
        let section = max(numberOfSections - 1, 0)
        let row = max(numberOfRows(inSection: section) - 1, 0)
        
        return IndexPath(row: row, section: section)
    }
}

//https://stackoverflow.com/questions/48955468/how-can-i-set-nsfetchedresultscontrollers-section-sectionnamekeypath-to-be-the
extension NSString{
    @objc func firstUpperCaseChar() -> String{
        if self.length == 0 {
            return ""
        }
        
        let character = self.substring(to: 1)        
        return character.capitalized
    }
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}


