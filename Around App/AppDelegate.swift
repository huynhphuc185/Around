//
//  AppDelegate.swift
//  Around App
//
//  Created by phuc.huynh on 8/3/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import ReachabilitySwift
import SystemConfiguration
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,FirebaseServiceProtocol{
    var window: UIWindow?
    var isPickup: Bool?
    var imageShipper: UIImage?
    var imageUser: UIImage?
    var nameUser: String?
    var order_id_following: Int?
    var isShowProgress = false
    var listSelected: [Int] = []
    let reachability = Reachability()!
    var networkStatus : Reachability.NetworkStatus!
    var firebase = FirebaseService()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        for family: String in UIFont.familyNames
//          {
//              print("\(family)")
//              for names: String in UIFont.fontNames(forFamilyName: family)
//               {
//                   print("== \(names)")
//           }
//           }
//        
    
        firebase.setDelegate(delegate: self)
        firebase.initService(application: application, isRelease: false)
      
        let languageURLPairs = [
            "en": Bundle.main.url(forResource: "en.json", withExtension: nil),
            "vi": Bundle.main.url(forResource: "vi.json", withExtension: nil)
        ]
        MCLocalization.load(fromLanguageURLPairs: languageURLPairs, defaultLanguage: "en")
        MCLocalization.sharedInstance().noKeyPlaceholder = "[No '{key}' in '{language}']"
       // FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "LaunchViewController") as! LaunchViewController
        self.window =  UIWindow(frame: UIScreen.main.bounds)
        self.window?.tintColor = UIColor(hex: "007AFF")
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = vc
        return true
        
    }
    func onUpdatePushToken(token : String, firebaseToken : String) {
        print("Token: " + token + ", firebaseToken: " + firebaseToken)
        defaults.setValue(token, forKey: "deviceToken")
        defaults.setValue(firebaseToken, forKey: "firebaseToken")
        
        
    }
    

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        firebase.didRegisterForRemoteNotificationsWithDeviceToken(deviceToken: deviceToken)
    }

    func setRootViewFirstTime()
    {
        if token_API == ""
        {
//            let desiredViewController = pickUpStoryBoard.instantiateViewController(withIdentifier: "TutorialViewController") as! TutorialViewController
//            let snapshot:UIView = (self.window?.snapshotView(afterScreenUpdates: true))!
//            desiredViewController.view.addSubview(snapshot);
//            self.window?.rootViewController = desiredViewController;
//            UIView.animate(withDuration: 0.3, animations: {() in
//                snapshot.layer.opacity = 0;
//                snapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5);
//            }, completion: {
//                (value: Bool) in
//                snapshot.removeFromSuperview();
//            });
            
            let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "TutorialViewController") as! TutorialViewController
            self.window =  UIWindow(frame: UIScreen.main.bounds)
            self.window?.makeKeyAndVisible()
            self.window?.rootViewController = vc
            
        }
        else{
            self.isPickup = nil
            let mainVC = pickUpStoryBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "ChooseServiceViewController") as! ChooseServiceViewController
            let nvc = UINavigationController(rootViewController: vc)
            mainVC.setFront(nvc, animated: true)
            let transition = CATransition()
            transition.type = kCATransitionFade
            self.window?.set(rootViewController: mainVC, withTransition: transition)
//            nvc.isNavigationBarHidden = true
//            let snapshot:UIView = (self.window?.snapshotView(afterScreenUpdates: true))!
//            mainVC.view.addSubview(snapshot);
//            self.window?.rootViewController = mainVC;
//            UIView.animate(withDuration: 0.3, animations: {() in
//                snapshot.layer.opacity = 0;
//                snapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5);
//            }, completion: {
//                (value: Bool) in
//                snapshot.removeFromSuperview();
//            });        }
        
        }
    }
    func setViewPickupFromChooseService(listPointPreorder: [PointLocation])
    {
        isPickup = true
        let mainVC = pickUpStoryBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "MapDirectorViewController") as! MapDirectorViewController
        vc.listPoint = listPointPreorder
        let nvc = UINavigationController(rootViewController: vc)
        mainVC.setFront(nvc, animated: true)
        nvc.isNavigationBarHidden = true
        
        let transition = CATransition()
        transition.type = kCATransitionFade
        self.window?.set(rootViewController: mainVC, withTransition: transition)
//        let snapshot:UIView = (self.window?.snapshotView(afterScreenUpdates: true))!
//        mainVC.view.addSubview(snapshot);
//        self.window?.rootViewController = mainVC;
//        UIView.animate(withDuration: 0.3, animations: {() in
//            snapshot.layer.opacity = 0;
//            snapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5);
//        }, completion: {
//            (value: Bool) in
//            snapshot.removeFromSuperview();
//        });
    }
    
    func setViewGiftingFromChooseService()
    {
        isPickup = false
        let mainVC = pickUpStoryBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        let vc = giftingStoryBoard.instantiateViewController(withIdentifier: "HomeGiftingViewController") as! HomeGiftingViewController
        let nvc = UINavigationController(rootViewController: vc)
        mainVC.setFront(nvc, animated: true)
        nvc.isNavigationBarHidden = true
        let transition = CATransition()
        transition.type = kCATransitionFade
        self.window?.set(rootViewController: mainVC, withTransition: transition)
//        let snapshot:UIView = (self.window?.snapshotView(afterScreenUpdates: true))!
//        mainVC.view.addSubview(snapshot);
//        self.window?.rootViewController = mainVC;
//        UIView.animate(withDuration: 0.3, animations: {() in
//            snapshot.layer.opacity = 0;
//            snapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5);
//        }, completion: {
//            (value: Bool) in
//            snapshot.removeFromSuperview();
//        });
    }
    
    
    func setRootView(isShowFollowJouneyStackScreen: Bool)
    {
     //   clearCache()
        self.order_id_following = nil
        
        self.isPickup = nil
        if SmartFoxObject.sharedInstance.smartFox != nil && SmartFoxObject.sharedInstance.smartFox.isConnected
        {
            SmartFoxObject.sharedInstance.disConnected(_isNeedReconnect: false)
        }
        let mainVC = pickUpStoryBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "ChooseServiceViewController") as! ChooseServiceViewController
        vc.flagShowFollowJourneyStack = isShowFollowJouneyStackScreen
        let nvc = UINavigationController(rootViewController: vc)
        nvc.isNavigationBarHidden = true
        mainVC.setFront(nvc, animated: true)
        let transition = CATransition()
        transition.type = kCATransitionFade
        self.window?.set(rootViewController: mainVC, withTransition: transition)
        
//        let snapshot:UIView = (self.window?.snapshotView(afterScreenUpdates: true))!
//        mainVC.view.addSubview(snapshot);
//        self.window?.rootViewController = mainVC;
//        UIView.animate(withDuration: 0.3, animations: {() in
//            snapshot.layer.opacity = 0;
//            snapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5);
//        }, completion: {
//            (value: Bool) in
//            snapshot.removeFromSuperview();
//        });        
    }

    func setRootViewWhenInvalidToken()
    {
        if SmartFoxObject.sharedInstance.smartFox != nil
        {
            SmartFoxObject.sharedInstance.disConnected(_isNeedReconnect: false)
        }
        defaults.set("", forKey: "token")
        defaults.set("", forKey: "userphone")
        let desiredViewController = pickUpStoryBoard.instantiateViewController(withIdentifier: "TutorialViewController") as! TutorialViewController
        let snapshot:UIView = (self.window?.snapshotView(afterScreenUpdates: true))!
        desiredViewController.view.addSubview(snapshot);
        self.window?.rootViewController = desiredViewController;
        UIView.animate(withDuration: 0.3, animations: {() in
            snapshot.layer.opacity = 0;
            snapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5);
        }, completion: {
            (value: Bool) in
            snapshot.removeFromSuperview();
        });
    }
    
    func setRootViewFollowJouney(locations : [PointLocation] , shipper: ShipperInfoObject, flagPayment: Bool, order_id: Int)
    {
        
        let mainVC = pickUpStoryBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "FollowJouneyMapViewController") as! FollowJouneyMapViewController
        vc.listPoint = locations
        vc.senderShipper = shipper
        vc.order_id = order_id
        let nvc = UINavigationController(rootViewController: vc)
        mainVC.setFront(nvc, animated: true)
        nvc.isNavigationBarHidden = true
//        self.window =  UIWindow(frame: UIScreen.main.bounds)
//        self.window?.makeKeyAndVisible()
//        self.window?.rootViewController = mainVC
        let transition = CATransition()
        transition.type = kCATransitionFade
        self.window?.set(rootViewController: mainVC, withTransition: transition)

    }
    
    func checkNetworkStatus()
    {
        networkStatus = reachability.currentReachabilityStatus
        
        if (networkStatus == Reachability.NetworkStatus.notReachable)
        {
            DispatchQueue.main.async(execute: {
                self.perform(#selector(self.alertLostNetWork), with: nil, afterDelay: 0.0)
            })
        }
        
    }
    func alertLostNetWork() {
        
        let topVc = (self.window?.rootViewController)!
        if SmartFoxObject.sharedInstance.smartFox.isConnected == false
        {
            if topVc is SWRevealViewController
            {
                if UIApplication.topViewController() is FollowJouneyMapViewController ||  UIApplication.topViewController() is DemoChatViewController || UIApplication.topViewController() is FullOrderSubViewController
                {
                    
                }
                else
                {
                    let myAlert = pickUpStoryBoard.instantiateViewController(withIdentifier: "NetworkViewController") as! NetworkViewController
                    myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                    topVc.topMostViewController().present(myAlert, animated: true, completion: nil)
                }


            }
            else
            {
                let myAlert = pickUpStoryBoard.instantiateViewController(withIdentifier: "NetworkViewController") as! NetworkViewController
                myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                topVc.present(myAlert, animated: true, completion: nil)
            }
            
        }
        
        
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        firebase.applicationWillEnterForeground(application: application)
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        firebase.applicationDidBecomeActive(application: application)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
   
    
}

