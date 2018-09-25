//
//  AppDelegate.swift
//  Siri Menu
//
//  Created by Cal Stephens on 9/25/18.
//  Copyright © 2018 Cal Stephens. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let rootViewController = window?.rootViewController! as! ViewController
        rootViewController.saveMenu(from: url)
        return true
    }


}

