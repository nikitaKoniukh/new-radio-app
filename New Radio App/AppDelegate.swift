//
//  AppDelegate.swift
//  New Radio App
//
//  Created by Nikita Koniukh on 22/03/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import UIKit
import BMSCore
import BMSPush
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = MainTabBarController()
        
        //permission of push notification
        
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                granted, error in
                print("Permission granted: \(granted)")
        }
        
        UIApplication.shared.registerForRemoteNotifications()
        
        registerForPush()

        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let push  = BMSPushClient.sharedInstance
       
        push.registerWithDeviceToken(deviceToken: deviceToken) { (response, statusCode, error) -> Void in
            
            if error.isEmpty {
                print( "Response during device registration: \(response) and status code is:\(statusCode)")
            } else{
                print( "Error during device registration: \(error) and status code is: \(statusCode)")
            }
        }
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "testIdentifire"{
             print("handlin app with idetifier")
            completionHandler()
        }
    }



func registerForPush() {
        let myBMSClient = BMSClient.sharedInstance
        myBMSClient.initialize(bluemixRegion: BMSClient.Region.unitedKingdom)
        let push = BMSPushClient.sharedInstance
        push.initializeWithAppGUID(appGUID: "b53c0e69-b5a2-4a48-a524-9ae474733b37",
                                   clientSecret: "232f2f5f-a033-446f-a60b-9994b4f1664c")
    }
    
    
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
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
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

