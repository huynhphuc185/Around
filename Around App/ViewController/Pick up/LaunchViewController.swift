//
//  LaunchViewController.swift
//  Around
//
//  Created by phuc.huynh on 3/22/17.
//  Copyright © 2017 phuc.huynh. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import ReachabilitySwift
class LaunchViewController: UIViewController {
    @IBOutlet weak var imageGif: UIImageView!
    var isFirst = false
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.setStatusBarHidden(true, with: .none)
        imageGif.animationImages = []
        for i in 0...71
        {
            let uncacheImage = getUncachedImage(named: String(format: "intro_logo_%d.png", i))!
            imageGif.animationImages?.append(uncacheImage)
            
        }
       
    }
    func getUncachedImage (named name : String) -> UIImage?
    {
        if let imgPath = Bundle.main.path(forResource: name, ofType: nil)
        {
            return UIImage(contentsOfFile: imgPath)
        }
        return nil
    }

    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector:  #selector(applicationDidEnterBackground),
                                               name: NSNotification.Name.UIApplicationDidEnterBackground,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(applicationDidBecomeActive),
                                               name: NSNotification.Name.UIApplicationDidBecomeActive,
                                               object: nil)
        
    }
    func applicationDidEnterBackground()
    {
        
    }
    func applicationDidBecomeActive()
    {
        if isFirst{
            self.checkNetWork()
        }
        else
        {
             isFirst = true
        }
       
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.imageGif.animationDuration = 3
        self.imageGif.startAnimating(completionBlock: { (result) in
            self.imageGif.stopAnimating()
            self.imageGif.animationImages = nil
            self.imageGif.image = nil
            self.imageGif.removeFromSuperview()
            self.checkNetWork()
        })
    }
    
    func checkNetWork()
    {
        if connectedToNetwork() == false{
            customAlertViewWithCancelButton(self, title: MCLocalization.string(forKey: "CHECKNETWORK"), btnTitleNameNormal: name_confirm_Button_Normal,  btnCancelNameNormal: name_cancel_Button_Normal,titleOrangeButton: MCLocalization.string(forKey: "TRY"), titleGreyButton: MCLocalization.string(forKey: "SETTING"), isClose: false,  blockCallback: {result in
                self.checkNetWork()
            }, blockCallbackCancel: {result in
                if #available(iOS 10.0, *)
                {
                    UIApplication.shared.openURL(URL(string:"App-Prefs:root=WIFI")!)
                }
                else
                {
                    UIApplication.shared.openURL(URL(string:"prefs:root=WIFI")!)
                }
                
            })
            
        }
        else
        {
            NotificationCenter.default.addObserver(appDelegate, selector: #selector(AppDelegate.checkNetworkStatus),name: ReachabilityChangedNotification,object: appDelegate.reachability)
            do{
                try appDelegate.reachability.startNotifier()
            }catch{
                print("could not start reachability notifier")
            }
            self.afterAnimation()
        }
        
    }
    
    
    func afterAnimation()
    {
        
        DataConnect.configIP(onsuccess: { (result) in
            UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
            if defaults.object(forKey: "defaultLangue") == nil{
                defaults.setValue("vi", forKey: "defaultLangue")
                MCLocalization.sharedInstance().language = "vi"
            }
            if defaults.object(forKey: "token") == nil{
                defaults.setValue("", forKey: "token")
            }
            if defaults.value(forKey: "locations") == nil{
                let listPoint = [Address().toJSON(),Address().toJSON(),Address().toJSON()]
                defaults.setValue(listPoint, forKey: "locations")
            }
            if defaults.object(forKey: "userphone") == nil{
                defaults.setValue("", forKey: "userphone")
            }
            if defaults.object(forKey: "deviceToken") == nil{
                defaults.setValue("", forKey: "deviceToken")
                defaults.setValue("", forKey: "firebaseToken")
            }
            if defaults.object(forKey: "chatNumber") == nil{
                let hashNumberChat : [String:String] = [:]
                defaults.set(hashNumberChat, forKey: "chatNumber")
            }
            var version = 0
            if let _ = defaults.string(forKey: "versionconfig"){
                
                version = defaults.value(forKey: "versionconfig") as! Int
            }
            DataConnect.getAppConfig(version, onsuccess: { (result) in
                let obj = result as! DataConfig
                Config.sharedInstance.imagePrice_TA = obj.image?.popup_price_en
                Config.sharedInstance.imagePrice_TV = obj.image?.popup_price_vn
                
                Config.sharedInstance.imagePrice_ServicePickupTA = obj.image?.popup_pickup_service_fee_en
                Config.sharedInstance.imagePrice_ServicePickupTV = obj.image?.popup_pickup_service_fee_vn
                Config.sharedInstance.imagePrice_ServiceGiftingTA = obj.image?.popup_gifting_service_fee_en
                Config.sharedInstance.imagePrice_ServiceGiftingTV = obj.image?.popup_gifting_service_fee_vn
                
                Config.sharedInstance.ping_time = obj.smartfox?.ping_time
                Config.sharedInstance.request_shipper_timeout = obj.smartfox?.request_shipper_timeout
                Config.sharedInstance.response_shipper_timeout = obj.smartfox?.response_shipper_timeout
                Config.sharedInstance.draw_shipper_position_time_in_journey = obj.smartfox?.draw_shipper_position_time_in_journey
                Config.sharedInstance.draw_shipper_position_time_out_journey = obj.smartfox?.draw_shipper_position_time_out_journey
                Config.sharedInstance.shipper_update_postion_time_in_journey = obj.smartfox?.shipper_update_postion_time_in_journey
                Config.sharedInstance.request_shipper_count = obj.smartfox?.request_shipper_count
                Config.sharedInstance.set_schedule_control_time = obj.smartfox?.set_schedule_control_time
                Config.sharedInstance.show_cancel_request_shipper_time = obj.smartfox?.show_cancel_request_shipper_time
                Config.sharedInstance.max_delivery_day = obj.smartfox?.max_delivery_day
                Config.sharedInstance.min_gifting_payment_cost = obj.smartfox?.min_gifting_payment_cost
                Config.sharedInstance.min_pickup_payment_cost = obj.smartfox?.min_pickup_payment_cost
                Config.sharedInstance.listPayment = obj.payment
                Config.sharedInstance.max_book_order = obj.order?.max_book_order
                Config.sharedInstance.start_working_hour = obj.order?.start_working_hour
                Config.sharedInstance.end_working_hour = obj.order?.end_working_hour
                Config.sharedInstance.giftbox_fee = obj.order?.giftbox_fee
                Config.sharedInstance.maintenance = obj.maintenance
                Config.sharedInstance.update = obj.update
                Config.sharedInstance.update = obj.update
                Config.sharedInstance.phoneNumberCallCenter = obj.support?.customer_service_phone
                Config.sharedInstance.min_around_pay_payment = obj.order?.min_around_pay_payment
                Config.sharedInstance.max_item_cost_cod = obj.order?.max_item_cost_cod
                Config.sharedInstance.min_item_cost_cod = obj.order?.min_item_cost_cod
                
                Config.sharedInstance.aroundpay = obj.aroundpay
                Config.sharedInstance.min_item_cost_purchase = obj.order?.min_item_cost_purchase
                
                if let key = obj.google_key?.ios_key
                {
                    GMSServices.provideAPIKey(key)
                    GMSPlacesClient.provideAPIKey(key)
                    Config.sharedInstance.googleKey = key
                }
                appDelegate.setRootViewFirstTime()
            }, onFailure: { (error) in
                
            })
            DataConnect.sendLoginInfo(token_API, country_code: kCountryCode, phone: userPhone_API , onsuccess: { (result) in
                
            }, onFailure: { (error) in
                print("api sendlogin info loi")
            })

//            DataConnect.getUserInfo(token_API,country_code: kCountryCode,phone: userPhone_API, view: self.view, onsuccess: { (result) in
//                if let obj = result as? Profile
//                {
//                    appDelegate.nameUser = obj.fullname
//                    loadDataByGCD(url: URL(string: obj.avatar!)!, onsuccess: { (result) in
//                        if result != nil
//                        {
//                            appDelegate.imageUser = UIImage(data: result as! Data)?.circleMasked
//                        }
//                        else
//                        {
//                            appDelegate.imageUser = UIImage(named: "avatar_Background")
//                        }
//                        
//                    })
//                    
//                }
//            }) { error in
//                appDelegate.imageUser = UIImage(named: "avatar_Background")
//            }
            
            

        }, onFailure: { (error) in
            
        })
    }
    
    
    
    override var prefersStatusBarHidden: Bool
    {
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
