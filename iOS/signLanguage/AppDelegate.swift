//
//  AppDelegate.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 24/12/2018.
//  Copyright © 2018 Zdeno Bacik. All rights reserved.
//

import UIKit
import CoreData
import os.log

struct Log {
    static var general = OSLog(subsystem: "sk.dorteo.signLanguage", category: "dorteo")
}

//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var isFullScreen = false
    var coreDataStack = CoreDataStack(modelName: "DictionaryDatabase")
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        preloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterFullScreen), name: NSNotification.Name(rawValue: "MediaEnterFullScreen"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willExitFullScreen), name: NSNotification.Name(rawValue: "MediaExitFullScreen"), object: nil)
                
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return isFullScreen == true ? UIInterfaceOrientationMask.all : UIInterfaceOrientationMask.portrait
    }
    
    @objc func willEnterFullScreen (notification: NSNotification) {
        isFullScreen = true
    }
    
    @objc func willExitFullScreen (notification: NSNotification) {
        isFullScreen = false
    }
    
    private func preloadData() {
        
        let previouslyLaunched = UserDefaults.standard.bool(forKey: "previouslyLaunched")
        if !previouslyLaunched {
            _ = PreloadCoreData(coreDataStack: coreDataStack)
            UserDefaults.standard.set(true, forKey: "previouslyLaunched")
        }
    }
}

