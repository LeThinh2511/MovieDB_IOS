//
//  AppDelegate.swift
//  MovieDB_IOS
//
//  Created by ThinhLe on 8/11/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil)
        -> Bool {
            FirebaseApp.configure()
            return true
    }
}
