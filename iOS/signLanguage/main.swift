//
//  main.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 26/04/2019.
//  Copyright © 2019 Zdeno Bacik. All rights reserved.
//

import Foundation

import UIKit

class MyApplication: UIApplication {
    
    override init() {
        let arr = NSArray(objects: "Slovak")
        UserDefaults.standard.set(arr, forKey: "AppleLanguages")
    }
}

//START POINT
UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, NSStringFromClass(MyApplication.self), NSStringFromClass(AppDelegate.self))
