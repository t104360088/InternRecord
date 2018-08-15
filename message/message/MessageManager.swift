//
//  MessageManager.swift
//  message
//
//  Created by RD-Air01 on 2018/8/11.
//  Copyright © 2018年 RD-Air01. All rights reserved.
//

import Foundation
import UserNotifications
import Firebase

class MessageManager: NSObject,
UNUserNotificationCenterDelegate, MessagingDelegate {
    
    private static var mInstance: MessageManager?
    var isMessageEnable = true
    
    private override init() {
        //註冊推播，告訴APNs這個App要註冊推播，每次啟動App都應調用，因token會不定期更換
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    // MARK: Public method
    static func sharedInstance() -> MessageManager {
        if mInstance == nil {
            mInstance = MessageManager()
        }
        return mInstance!
    }
    
    //取得User設定的通知權限(denied拒絕、authorized允許、notDetermined沒有決定)
    func getMessengerStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            self.isMessageEnable = (settings.authorizationStatus != .denied) ? true : false

            if settings.authorizationStatus == .notDetermined {
                DispatchQueue.main.async {
                    self.setupMessenger()
                }
            }
        }
    }
    
    //取得FCMToken，deviceToken是屬於APNs辨識用，在FCM中也有專屬的Token
    func getFcmToken() -> String? {
        return Messaging.messaging().fcmToken
    }
    
    //開啟App推播權限設定畫面
    func openAppSetting() {
        let url = URL(string: UIApplicationOpenSettingsURLString)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    //向使用者請求推播權限，通常在第一次使用App就會詢問
    private func setupMessenger() {
        UNUserNotificationCenter.current().delegate = self
        
        //要求推播中的哪些權限(alert提示內容、badge角標數字、sound音效)
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        
        Messaging.messaging().delegate = self //FCM委派
    }
    
    //當App在前景模式下收到推播時的處理，這裡設定成也同樣顯示推播
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound, .alert])
    }
    
    //當User點擊推播後的處理，預設為開啟App
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
