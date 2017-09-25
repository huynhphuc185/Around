//
//  FirebaseService.swift
//  TestFirebase
//
//  Created by SeaN on 6/26/17.
//  Copyright © 2017 SeaN. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

public protocol FirebaseServiceProtocol {
    func onUpdatePushToken(token : String, firebaseToken : String)
}

class FirebaseService : NSObject, UNUserNotificationCenterDelegate, FIRMessagingDelegate {
    private var currentToken = String()
    private var isRelease = false
    private var delegate : FirebaseServiceProtocol!
    func setDelegate(delegate : FirebaseServiceProtocol) {
        self.delegate = delegate
    }
    
    public func initService(application : UIApplication, isRelease : Bool) {
        self.isRelease = isRelease
        initializeFCM(application)
    }
    
    public func didRegisterForRemoteNotificationsWithDeviceToken (deviceToken: Data) {
//        let token = String(format: "%@", deviceToken as CVarArg)
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        currentToken = token
        if (isRelease) {
            FIRInstanceID.instanceID().setAPNSToken(deviceToken as Data, type:FIRInstanceIDAPNSTokenType.prod)
        } else {
            FIRInstanceID.instanceID().setAPNSToken(deviceToken as Data, type:FIRInstanceIDAPNSTokenType.sandbox)
        }
        
        if let firebaseToken = FIRInstanceID.instanceID().token()
        {
            callbackUpdateToken(token: currentToken, firebaseToken: firebaseToken)
        }
//        let firebaseToken = FIRInstanceID.instanceID().token()!
//        callbackUpdateToken(token: token, firebaseToken: firebaseToken)
    }
    public func applicationWillEnterForeground(application : UIApplication) {
        removeBadge()
    }
    
    public func applicationDidBecomeActive(application : UIApplication) {
        removeBadge()
    }
    
    private func removeBadge() {
        UIApplication.shared.applicationIconBadgeNumber = 0;
    }
    private func callbackUpdateToken(token : String, firebaseToken : String) {
        if (delegate != nil) {
            delegate.onUpdatePushToken(token: token, firebaseToken: firebaseToken)
        }
    }
    
    private func initializeFCM(_ application: UIApplication)
    {
        print("initializeFCM")
        if #available(iOS 10.0, *) // enable new way for notifications on iOS 10
        {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.badge, .alert , .sound]) { (accepted, error) in
                if !accepted
                {
                    print("Notification access denied.")
                }
                else
                {
                    print("Notification access accepted.")
                    UIApplication.shared.registerForRemoteNotifications();
                }
            }
        }
        else
        {
            let type: UIUserNotificationType = [UIUserNotificationType.badge, UIUserNotificationType.alert, UIUserNotificationType.sound];
            let setting = UIUserNotificationSettings(types: type, categories: nil);
            UIApplication.shared.registerUserNotificationSettings(setting);
            UIApplication.shared.registerForRemoteNotifications();
        }
        
        FIRApp.configure()
        
        NotificationCenter.default.addObserver(self, selector: #selector(tokenRefreshNotificaiton),
                                               name: NSNotification.Name.firInstanceIDTokenRefresh, object: nil)
    }
    
    private func registrationhandler(_ registrationToken: String!, error: NSError!)
    {
        if (registrationToken != nil)
        {
            debugPrint("registrationToken = \(String(describing: registrationToken))")
        }
        else
        {
            debugPrint("Registration to GCM failed with error: \(error.localizedDescription)")
        }
    }
    
    public func tokenRefreshNotificaiton(_ notification: Foundation.Notification)
    {
        if let firebaseToken = FIRInstanceID.instanceID().token()
        {
            callbackUpdateToken(token: currentToken, firebaseToken: firebaseToken)
        }
        connectToFcm()
    }
    
    private func connectToFcm()
    {
        // Won't connect since there is no token
        guard FIRInstanceID.instanceID().token() != nil else
        {
            return;
        }
        // Disconnect previous FCM connection if it exists.
        FIRMessaging.messaging().disconnect()
        FIRMessaging.messaging().connect { (error) in
            if (error != nil)
            {
                debugPrint("Unable to connect with FCM. \(String(describing: error))")
            }
            else
            {
                debugPrint("Connected to FCM.")
            }
        }
    }
    
    // The callback to handle data message received via FCM for devices running iOS 10 or above.
    internal func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
}
