//
//  AppDelegate.swift
//  CurrencyAssistant
//
//  Created by neilson on 2022-03-19.
//

import UIKit
import Foundation
import UserNotifications

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            // regist remote notification
        let userNotificationCenter = UNUserNotificationCenter.current()
        userNotificationCenter.delegate = self
        userNotificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            print("Permission granted: \(granted)")
            userNotificationCenter.getNotificationSettings { settings in
                if (settings.authorizationStatus == .authorized) {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        }
        return true
    }
    
    // Handle remote notification registration.
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenComponents = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let deviceTokenString = tokenComponents.joined()
        
            // Forward the token to your provider, using a custom method.
        print("Token: \(deviceTokenString)")
            //98cdb0a8650c318ffafe45a4430bd4e1aca58d773ca195f2122637affd4897c5
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        /* Example Payload
         {
         "aps" : {
         "alert" : {
         "title" : "Check out our new special!",
         "body" : "Avocado Bacon Burger on sale"
         },
         "sound" : "default",
         "badge" : 1,
         },
         "special" : "avocado_bacon_burger",
         "price" : "9.99"
         }
         */
        let userInfo = response.notification.request.content.userInfo
        print("User info \(userInfo)")
        completionHandler()
    }
}
