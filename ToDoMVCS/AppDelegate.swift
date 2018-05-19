//
//  AppDelegate.swift
//  ToDoMVCS
//
//  Created by DianQK on 2018/5/18.
//  Copyright © 2018 DianQK. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        _ = PersistentManager.persistentContainer
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        PersistentManager.saveContext()
    }

}

