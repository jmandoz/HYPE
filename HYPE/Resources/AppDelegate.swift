//
//  AppDelegate.swift
//  HYPE
//
//  Created by Jason Mandozzi on 7/9/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit
import UserNotifications
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (userDidAllow, error) in
            if let error = error {
                print("There was an error in \(#function) ; \(error) ; \(error.localizedDescription)")
                
            }
            if userDidAllow == true {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        //testing the app
//        let testHype = "Go hang a salami, I'm a lasagna hog"
//        let hypeC = HypeController()
//        hypeC.saveHype(text: testHype) { (success) in
//            if success {
//                print("I think it worked")
//            }
//        }
//        hypeC.fetchHype { (success) in
//            for hype in hypeC.hypes {
//                print(hype.hypeText)
//            }
//        }
        return true
    }
    //this is what happens whn the user agrees to push notifications
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        HypeController.shared.subscribeToRemoteNotifications { (error) in
            if let error = error {
                print("There was an error in \(#function) ; \(error) ; \(error.localizedDescription)")
            }
        }
    }
    //this is what happens when the user declines push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Error registering APNS : \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        HypeController.shared.fetchHype { (success) in
            if success {
                //TODO: - Notification?
                
            }
        }
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
    
}

