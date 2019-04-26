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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var coreDataStack = CoreDataStack(modelName: "DictionaryDatabase")
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let arr = NSArray(objects: "Slovak")
        UserDefaults.standard.set(arr, forKey: "AppleLanguages")
        
        preloadData()

        UIApplication.shared.isStatusBarHidden = false
        
        return true
    }
    
    func preloadData() {
        
        let previouslyLaunched = UserDefaults.standard.bool(forKey: "previouslyLaunched")
        if !previouslyLaunched {
            _ = PreloadCoreData(coreDataStack: coreDataStack)
            UserDefaults.standard.set(true, forKey: "previouslyLaunched")
        }
    }
}

