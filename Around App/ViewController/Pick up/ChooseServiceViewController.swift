//
//  ChooseServiceViewController.swift
//  Around
//
//  Created by phuc.huynh on 9/28/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
class ChooseServiceViewController: StatusbarViewController,SWRevealViewControllerDelegate {
    var flagShowFollowJourneyStack = false
    var locationManager = CLLocationManager()
    var listBanner : ListBanner?
    @IBOutlet weak var viewCloseSlideMenu: UIView!
    @IBOutlet weak var defNav: DefaultNavigation!
    @IBOutlet weak var imageChoose1: UIImageView!
    @IBOutlet weak var imageChoose2: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataConnect.getUserInfo(token_API,country_code: kCountryCode,phone: userPhone_API, isNeedShowProcess: false, onsuccess: { (result) in
            if let obj = result as? Profile
            {
                appDelegate.nameUser = obj.fullname
                loadDataByGCD(url: URL(string: obj.avatar!)!, onsuccess: { (result) in
                    if result != nil
                    {
                        appDelegate.imageUser = UIImage(data: result as! Data)?.circleMasked
                    }
                    else
                    {
                        appDelegate.imageUser = UIImage(named: "avatar_Background")
                    }
                    
                })
                
            }
        }) { error in
            appDelegate.imageUser = UIImage(named: "avatar_Background")
        }
        defNav.setTransparent()
        if CLLocationManager.authorizationStatus() == .notDetermined || CLLocationManager.authorizationStatus() == .denied  || CLLocationManager.authorizationStatus() == .restricted
        {
            self.locationManager.requestWhenInUseAuthorization()
        }
        DataConnect.sendDevicetoken(defaults.value(forKey: "deviceToken") as! String, country_code: kCountryCode, phone: userPhone_API,  firebase_devicetoken: defaults.value(forKey: "firebaseToken") as! String, onsuccess: { (result) in
            print("sendDeviceToken success")
        }) { (error) in
            print("sendDeviceToken error")
        }
        self.revealViewController().delegate = self
        viewCloseSlideMenu.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        viewCloseSlideMenu.isHidden = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        imageChoose1.image = UIImage(named: MCLocalization.string(forKey: "IMAGECHOOSE2"))
        imageChoose2.image = UIImage(named: MCLocalization.string(forKey: "IMAGECHOOSE1"))
        self.revealViewController().callbackHistoryOrder = {(historyObj) in
            let hisObj = historyObj as! HistoryObject
            appDelegate.setViewPickupFromChooseService(listPointPreorder: hisObj.locations!)
        }
        DataConnect.getOrderNumber(token_API, country_code: kCountryCode, phone: userPhone_API, onsuccess: { (result) in
            let numberLeftMenu = result as? NumberLeftMenu
            let total = (numberLeftMenu?.number_event)! + (numberLeftMenu?.number_order)! + (numberLeftMenu?.number_notification)!
            if total == 0
            {
                self.defNav.topItem?.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
                self.defNav.topItem?.leftBarButtonItem?.tintColor = UIColor.white
            }
            else
            {
                let btnNotiMenu = MIBadgeButton()
                btnNotiMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
                btnNotiMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                btnNotiMenu.setImage(UIImage(named: "menu"), for: .normal)
                btnNotiMenu.badgeString = String(format: "%d", total)
                let menuNotiBarButton = UIBarButtonItem(customView: btnNotiMenu)
                self.defNav.topItem?.leftBarButtonItem = menuNotiBarButton
            }
            
            
        }) { (error) in
            self.defNav.topItem?.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            self.defNav.topItem?.leftBarButtonItem?.tintColor = UIColor.white
        }

    }
    override func viewDidAppear(_ animated: Bool) {
        if flagShowFollowJourneyStack{
            flagShowFollowJourneyStack = false
            let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "FollowJourneyStackViewController") as! FollowJourneyStackViewController
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
        }
        else
        {
            if Config.sharedInstance.maintenance?.status == 1
            {
                if MCLocalization.sharedInstance().language == "en"
                {
                    customAlertView(self, title: (Config.sharedInstance.maintenance?.message)!, btnTitleNameNormal: name_confirm_Button_Normal,titleButton: MCLocalization.string(forKey: "CONFIRM")) { result in
                        Config.sharedInstance.maintenance = nil
                        Config.sharedInstance.update = nil
                        exit(0)
                    }
                }
                else
                {
                    customAlertView(self, title: (Config.sharedInstance.maintenance?.vn_message)!, btnTitleNameNormal: name_confirm_Button_Normal,titleButton: MCLocalization.string(forKey: "CONFIRM")) { result in
                        Config.sharedInstance.maintenance = nil
                        Config.sharedInstance.update = nil
                        exit(0)
                    }
                }
            }
            else
            {
                
                if Config.sharedInstance.update?.status == 1
                {
                    if MCLocalization.sharedInstance().language == "en"
                    {
                        customAlertViewWithCancelButton(self, title: (Config.sharedInstance.update?.message)!, btnTitleNameNormal: name_confirm_Button_Normal,  btnCancelNameNormal: name_cancel_Button_Normal,titleOrangeButton: MCLocalization.string(forKey: "UPDATE"), titleGreyButton: MCLocalization.string(forKey: "SKIP"), isClose: false,  blockCallback: {result in
                            if let url = URL(string: (Config.sharedInstance.update?.url)!),
                                UIApplication.shared.canOpenURL(url){
                                UIApplication.shared.openURL(url)
                            }
                            Config.sharedInstance.maintenance = nil
                            Config.sharedInstance.update = nil
                        }, blockCallbackCancel: {result in
                            Config.sharedInstance.maintenance = nil
                            Config.sharedInstance.update = nil
                            DataConnect.getListBanner(token_API, country_code: kCountryCode, phone: userPhone_API, position: 0, view: self.view, onsuccess: { (result) in
                                self.listBanner = result as? ListBanner
                                self.loadBanner()
                            }) { (error) in
                            }
                        })
                    }
                    else
                    {
                        customAlertViewWithCancelButton(self, title: (Config.sharedInstance.update?.vn_message)!, btnTitleNameNormal: name_confirm_Button_Normal,  btnCancelNameNormal: name_cancel_Button_Normal,titleOrangeButton: MCLocalization.string(forKey: "UPDATE"), titleGreyButton: MCLocalization.string(forKey: "SKIP"), isClose: false,  blockCallback: {result in
                            if let url = URL(string: (Config.sharedInstance.update?.url)!),
                                UIApplication.shared.canOpenURL(url){
                                UIApplication.shared.openURL(url)
                            }
                            Config.sharedInstance.maintenance = nil
                            Config.sharedInstance.update = nil
                        }, blockCallbackCancel: {result in
                            Config.sharedInstance.maintenance = nil
                            Config.sharedInstance.update = nil
                            DataConnect.getListBanner(token_API, country_code: kCountryCode, phone: userPhone_API, position: 0, view: self.view, onsuccess: { (result) in
                                self.listBanner = result as? ListBanner
                                self.loadBanner()
                            }) { (error) in
                            }
                        })
                        
                    }
                }
                else if Config.sharedInstance.update?.status == 2
                {
                    if MCLocalization.sharedInstance().language == "en"
                    {
                        customAlertView(self, title: (Config.sharedInstance.update?.message)!, btnTitleNameNormal: name_confirm_Button_Normal,titleButton: MCLocalization.string(forKey: "UPDATE")) { result in
                            if let url = URL(string: (Config.sharedInstance.update?.url)!),
                                UIApplication.shared.canOpenURL(url){
                                UIApplication.shared.openURL(url)
                            }
                            Config.sharedInstance.maintenance = nil
                            Config.sharedInstance.update = nil
                            exit(0)
                            
                        }
                    }
                    else
                    {
                        customAlertView(self, title: (Config.sharedInstance.update?.vn_message)!, btnTitleNameNormal: name_confirm_Button_Normal,titleButton: MCLocalization.string(forKey: "UPDATE")) { result in
                            if let url = URL(string: (Config.sharedInstance.update?.url)!),
                                UIApplication.shared.canOpenURL(url){
                                UIApplication.shared.openURL(url)
                            }
                            Config.sharedInstance.maintenance = nil
                            Config.sharedInstance.update = nil
                            exit(0)
                            
                        }
                        
                    }
                }
                else
                {
                    DataConnect.getListBanner(token_API, country_code: kCountryCode, phone: userPhone_API, position: 0, view: self.view, onsuccess: { (result) in
                        self.listBanner = result as? ListBanner
                        self.loadBanner()
                    }) { (error) in
                    }
                    
                }
                
                
            }
            
        }
        
    }
    
    func loadBanner()
    {
        for item in (listBanner?.data?.enumerated())!
        {
            if item.element.type == 0
            {
                
                let myAlert = bannerStoryBoard.instantiateViewController(withIdentifier: "BannerImageViewController") as! BannerImageViewController
                myAlert.bannerObj = item.element
                myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                listBanner?.data?.remove(at: item.offset)
                
                self.topMostViewController().present(myAlert, animated: false, completion: {
                    self.loadBanner()
                })
                break
                
            }
            else if item.element.type == 1
            {
                
                let myAlert = bannerStoryBoard.instantiateViewController(withIdentifier: "BannerImageViewController") as! BannerImageViewController
                myAlert.bannerObj = item.element
                myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                listBanner?.data?.remove(at: item.offset)
                
                self.topMostViewController().present(myAlert, animated: false, completion: {
                    self.loadBanner()
                })
                break
                
                
            }
            else if item.element.type == 2
            {
                if item.element.show_number == 1
                {
                    let myAlert = bannerStoryBoard.instantiateViewController(withIdentifier: "BannerProductViewController") as! BannerProductViewController
                    myAlert.listBanner = item.element.contents
                    myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                    listBanner?.data?.remove(at: item.offset)
                    
                    self.topMostViewController().present(myAlert, animated: false, completion: {
                        self.loadBanner()
                    })
                    break
                }
                else if item.element.show_number == 4
                {
                    let myAlert = bannerStoryBoard.instantiateViewController(withIdentifier: "BannerFourProductViewController") as! BannerFourProductViewController
                    myAlert.listBanner = item.element
                    myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                    listBanner?.data?.remove(at: item.offset)
                    
                    self.topMostViewController().present(myAlert, animated: false, completion: {
                        self.loadBanner()
                    })
                    break
                }
            }
            else if item.element.type == 3
            {
                let myAlert = pickUpStoryBoard.instantiateViewController(withIdentifier: "PopUpEventTextViewController") as! PopUpEventTextViewController
                myAlert.listBanner = item.element
                myAlert.isSelectButtonConfirm = false
                myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                listBanner?.data?.remove(at: item.offset)
                self.topMostViewController().present(myAlert, animated: false, completion: {
                    self.loadBanner()
                })
                break
                
            }
            else if item.element.type == 4
            {
                let myAlert = pickUpStoryBoard.instantiateViewController(withIdentifier: "PopUpEventTextViewController") as! PopUpEventTextViewController
                myAlert.listBanner = item.element
                myAlert.isSelectButtonConfirm = true
                myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                listBanner?.data?.remove(at: item.offset)
                self.topMostViewController().present(myAlert, animated: false, completion: {
                    self.loadBanner()
                })
                break
                
            }
            
        }
    }
    
    func revealController(_ revealController: SWRevealViewController!, animateTo position: FrontViewPosition) {
        self.dismissKeyboard()
        if position == .right
        {
            viewCloseSlideMenu.isHidden = false
        }
        else
        {
            viewCloseSlideMenu.isHidden = true
        }
        
    }
    
    @IBAction func choose1Click(_ sender: AnyObject) {
        tracking(actionKey: "C4.1Y")
        appDelegate.setViewPickupFromChooseService(listPointPreorder: [])
    }
    
    @IBAction func choose2Click(_ sender: AnyObject) {
        tracking(actionKey: "C4.2Y")
        appDelegate.setViewGiftingFromChooseService()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
