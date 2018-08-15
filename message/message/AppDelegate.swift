//
//  AppDelegate.swift
//  message
//
//  Created by RD-Air01 on 2018/8/11.
//  Copyright © 2018年 RD-Air01. All rights reserved.
//

import UIKit
import Firebase //匯入Firebase模組

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure() //配置Firebase
        MessageManager.sharedInstance().getMessengerStatus() //取得推播權限狀態
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    //當推播註冊成功就會調用，並取得deviceToken，一有deviceToken就會產生FCMToken
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let fcmToken = MessageManager.sharedInstance().getFcmToken() //取得FCMToken
        DatabaseManager.sharedInstance().uploadToken(fcmToken!) //上傳到Firebase
    }
}

