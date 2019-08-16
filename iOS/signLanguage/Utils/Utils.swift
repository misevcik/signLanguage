//
//  Utils.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 01/02/2019.
//  Copyright © 2019 Zdeno Bacik. All rights reserved.
//

import UIKit
import AVKit

enum DeviceSize {
    case big, medium, small
}

class Utils {
    
    static func getVideoImage(url: URL, at time: TimeInterval) -> UIImage? {
        
        let asset = AVURLAsset(url: url)
        let frame = asset.duration.seconds / 2
        
        let assetIG = AVAssetImageGenerator(asset: asset)
        assetIG.appliesPreferredTrackTransform = true
        assetIG.apertureMode = AVAssetImageGenerator.ApertureMode.encodedPixels
        assetIG.requestedTimeToleranceAfter = CMTime.zero;
        assetIG.requestedTimeToleranceBefore = CMTime.zero;
        assetIG.maximumSize = CGSize(width: 842, height: 480)

        let image: CGImage
        do {
            image = try assetIG.copyCGImage(at: CMTimeMake(value: Int64(frame) , timescale: 1), actualTime: nil)
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
    
    static func getDeviceSize() -> DeviceSize {
        
        var devicetype: DeviceSize {
            
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                return .small
            case 1334:
                return .medium
            case 2208:
                return .big
            case 2436:
                return .big
            default:
                return .big
            }
        }
        
        return devicetype
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

extension UIImageView {
    
    func setRounded() {
        self.layer.cornerRadius = (self.frame.width / 2) //instead of let radius = CGRectGetWidth(self.frame) / 2
        self.layer.masksToBounds = true
    }
}


extension UITableView {
    func lastIndexpath() -> IndexPath {
        let section = max(numberOfSections - 1, 0)
        let row = max(numberOfRows(inSection: section) - 1, 0)
        
        return IndexPath(row: row, section: section)
    }
}


extension NSString{
    @objc func SKfirstUpperCaseChar() -> String{
        
        if self.length == 0 {
            return ""
        }
        
        
        let character = self.substring(to: 1)
        
        if character == "C" && self.substring(to: 2 ) == "Ch" {
            return "CH"
        }
        
        if character == "Ú" {
            return "U"
        }
        
        if character == "Ť" {
            return "T"
        }
        
        if character == "Ď" {
            return "D"
        }
        
        if character == "Á" {
            return "A"
        }
        
        return character.capitalized
    }

    @objc func UniversalfirstUpperCaseChar() -> String{
        
        if self.length == 0 {
            return ""
        }
        
        
        let character = self.substring(to: 1)
        
        switch character {
        case "Á":
            return "A"
        case "Č":
            return "C"
        case "Ď":
            return "D"
        case "Š":
            return "S"
        case "Ť":
            return "T"
        case "Ú":
            return "U"
        case "Ž":
            return "Z"
        default:
            return character.capitalized
        }
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

extension UIDevice {
    var hasNotch: Bool {
        if #available(iOS 11.0, *) {
            let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
            return bottom > 0
        } else {
            return false
        }
    }
}

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        //let textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
        //(labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        
        //let locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
        // locationOfTouchInLabel.y - textContainerOffset.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}




