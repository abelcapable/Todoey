//
//  AppDelegate.swift
//  Todoey
//
//  Created by Abel Molnar on 2018. 01. 08..
//  Copyright © 2018. Abel Molnar. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
    
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        do {
            _ = try Realm()
            
        } catch {
            
            print("error creating new realm object \(error)")
            
        }
        
         return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

