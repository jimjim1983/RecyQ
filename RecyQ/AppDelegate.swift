//
//  AppDelegate.swift
//  RecyQ
//
//  Created by Jim Petri on 21/03/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var client: MSClient?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let tabbarController = UITabBarController()
        let firstTab = StatsViewController(nibName: "StatsViewController", bundle:  nil)
        let secondTab = StoreViewController(nibName: "StoreViewController", bundle:  nil)
        let thirdTab = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        let controllers = [firstTab,secondTab,thirdTab]
        tabbarController.viewControllers = controllers
        firstTab.tabBarItem = UITabBarItem(title: "Stats", image: UIImage(named: "stats"), tag: 1)
        secondTab.tabBarItem = UITabBarItem(title: "Shop", image: UIImage(named: "shop.png"), tag: 2)
        thirdTab.tabBarItem = UITabBarItem(title: "Profiel", image: UIImage(named: "profile.png"), tag: 3)
        
        self.window?.rootViewController = tabbarController
        
        self.client = MSClient(
            applicationURLString:"https://recyqdb.azurewebsites.net"
        )
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let client = delegate.client!
        let item = ["voornaam":"Alyson"]
//        let item = ["text":"Awesome item"]
        let itemTable = client.tableWithName("User")
        
        itemTable.insert(item) {
            (insertedItem, error) in
            if (error != nil) {
                print("Error" + error!.description);
            } else {
                if let itemString = insertedItem! ["voornaam"] {
//                if let itemString = insertedItem!["id"] {
                print("This is \(itemString)")
                    thirdTab.string = "\(itemString)"
//                thirdTab.emailLabel.text = "\(itemString)"
                    
                }
            }
        }
        
        return true

    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

