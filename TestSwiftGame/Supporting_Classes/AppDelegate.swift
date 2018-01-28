//
//  AppDelegate.swift
//  TestSwiftGame
//
//  Created by EKT DIGIDESIGN on 12/6/17.
//  Copyright © 2017 EKT DIGIDESIGN. All rights reserved.
//

import UIKit

private var myGameControllerPointer_: UIViewController!

@UIApplicationMain

class AppDelegate: UIResponder ,UIApplicationDelegate {

    var window: UIWindow?
    var gameController = UIViewController()
    let audio = KTF_MusicPlayer.sharedInstance()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
            audio.playMusic(fileName: "bg_music")
        audio.setMusicVolume(volume: 0.1)
//set window frame (size)
        window = UIWindow(frame: UIScreen.main.bounds)

        //set the view controller
        gameController = GameViewController.init(nibName: nil, bundle: nil)
        window!.rootViewController = gameController
 
        myGameControllerPointer_ = gameController
        
        //make window visible
        window!.makeKeyAndVisible()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        exit(0)
       // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
    //    exit(0)
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

