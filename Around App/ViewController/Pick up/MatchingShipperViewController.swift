//
//  MatchingShipperViewController.swift
//  Around
//
//  Created by phuc.huynh on 8/30/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import UIKit
class MatchingShipperViewController: StatusbarViewController {
    var flagisPickupOrGifting : Bool?
    var sender:DataSender = DataSender()
    var online_payment_order_id = 0
    //  let listJsonArray : ISFSArray = SFSArray.newInstance()
    @IBOutlet weak var viewa: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    var imageZoom1: UIImageView!
    var imageZoom2: UIImageView!
    var imageBIke : UIImageView!
    var id_Request : String?
    var flagReconectSocketFromBackground = false
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    var flagRequestShipperOrReconnect = false
    override func viewDidLoad() {
        super.viewDidLoad()
        initImageZoom()
        zoomIn()
        self.btnCancel.isHidden = true
        if flagisPickupOrGifting == false{
            let listJsonArray : ISFSArray = SFSArray.newInstance()
            for item in (self.sender.listLocationSender?.enumerated())!
            {
                if let json = item.element.toJSONString() {
                    listJsonArray.addUtfString(json)
                    
                }
            }
            blockCallBackFromSmartFox(service: "PICKUP", listLocation: listJsonArray)
        }
        else
        {
            blockCallBackFromSmartFox(service: "GIFTING", listLocation: nil)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.activeAgain), name: NSNotification.Name.UIApplicationWillEnterForeground, object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.backgroundMode), name: NSNotification.Name.UIApplicationDidEnterBackground, object:nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(applicationDidBecomeActive),
                                               name: NSNotification.Name.UIApplicationDidBecomeActive,
                                               object: nil)
    }
    func applicationDidBecomeActive()
    {
        if flagReconectSocketFromBackground{
            flagReconectSocketFromBackground = false
            reConnectedSmartFox()
        }
    }
    func initImageZoom()
    {
        imageZoom1 = UIImageView()
        imageZoom1.image = UIImage(named: "uhaha-2")
        imageZoom2 = UIImageView()
        imageZoom2.image = UIImage(named: "uhaha-3")
        imageBIke = UIImageView()
        imageBIke.image = UIImage(named: "ahihi")
        self.viewa.addSubview(imageZoom1)
        self.viewa.addSubview(imageZoom2)
        self.viewa.addSubview(imageBIke)
        
        let topZ1 = NSLayoutConstraint(item: imageZoom1, attribute: .top, relatedBy: .equal, toItem: viewa, attribute: .top, multiplier: 1, constant: 0)
        let leadZ1 = NSLayoutConstraint(item: imageZoom1, attribute: .leading, relatedBy: .equal, toItem: viewa, attribute: .leading, multiplier: 1, constant: 0)
        let trailZ1 = NSLayoutConstraint(item: imageZoom1, attribute: .trailing, relatedBy: .equal, toItem: viewa, attribute: .trailing, multiplier: 1, constant: 0)
        let bottomZ1 = NSLayoutConstraint(item: imageZoom1, attribute: .bottom, relatedBy: .equal, toItem: viewa, attribute: .bottom, multiplier: 1, constant: 0)
        imageZoom1.autoresizesSubviews = false
        imageZoom1.translatesAutoresizingMaskIntoConstraints = false
        viewa.addConstraints([topZ1,leadZ1,trailZ1,bottomZ1])
        
        
        
        let centerX = NSLayoutConstraint(item: imageZoom2, attribute: .centerX, relatedBy: .equal, toItem: viewa, attribute: .centerX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: imageZoom2, attribute: .centerY, relatedBy: .equal, toItem: viewa, attribute: .centerY, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: imageZoom2, attribute: .width, relatedBy: .equal, toItem: viewa, attribute: .width, multiplier: 0.38, constant: 0)
        let height = NSLayoutConstraint(item: imageZoom2, attribute: .height, relatedBy: .equal, toItem: viewa, attribute: .height, multiplier: 0.38, constant: 0)
        imageZoom2.autoresizesSubviews = false
        imageZoom2.translatesAutoresizingMaskIntoConstraints = false
        viewa.addConstraints([centerX,centerY,width,height])
        
        
        
        let topZBike = NSLayoutConstraint(item: imageBIke, attribute: .top, relatedBy: .equal, toItem: viewa, attribute: .top, multiplier: 1, constant: 0)
        let leadZBike = NSLayoutConstraint(item: imageBIke, attribute: .leading, relatedBy: .equal, toItem: viewa, attribute: .leading, multiplier: 1, constant: 0)
        let trailZBike = NSLayoutConstraint(item: imageBIke, attribute: .trailing, relatedBy: .equal, toItem: viewa, attribute: .trailing, multiplier: 1, constant: 0)
        let bottomZBike = NSLayoutConstraint(item: imageBIke, attribute: .bottom, relatedBy: .equal, toItem: viewa, attribute: .bottom, multiplier: 1, constant: 0)
        imageBIke.autoresizesSubviews = false
        imageBIke.translatesAutoresizingMaskIntoConstraints = false
        viewa.addConstraints([topZBike,leadZBike,trailZBike,bottomZBike])
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        
    }
    func activeAgain() {
        zoomIn()
    }
    func backgroundMode(){
        imageZoom1.removeFromSuperview()
        imageZoom2.removeFromSuperview()
        imageBIke.removeFromSuperview()
        initImageZoom()
    }
    
    func zoomIn()
    {
        
        UIView.animate(withDuration: 1.7, delay: 0, options: .repeat, animations: {
            self.imageZoom1.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
            self.imageZoom1.alpha = 0
            self.imageZoom2.transform = CGAffineTransform(scaleX: 5, y: 5)
            self.imageZoom2.alpha = 0
        }, completion: nil)
        
    }

    func blockCallBackFromSmartFox(service: String ,listLocation: ISFSArray?)
    {
        if online_payment_order_id == 0
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(Config.sharedInstance.show_cancel_request_shipper_time!)) {
                self.btnCancel.isHidden = false
            }
        }
        else
        {
            if SmartFoxObject.sharedInstance.smartFox.isConnected
            {
                let param = SFSObject.newInstance()
                param?.putUtfString("command", value: kCmdRequestShipper)
                param?.putUtfString("type", value: service)
                param?.putInt("minute", value: (self.sender.timeSender.minute))
                param?.putInt("hour", value: (self.sender.timeSender.hour))
                param?.putInt("day", value: (self.sender.timeSender.day))
                param?.putInt("month", value:(self.sender.timeSender.month))
                param?.putInt("year", value: (self.sender.timeSender.year))
                param?.putBool("return_to_pickup", value: (self.sender.returnToPickupSender))
                if listLocation != nil{
                    param?.putSFSArray("locations", value: listLocation)
                }
                param?.putInt("online_payment_order_id", value: self.online_payment_order_id)
                param?.putUtfString("id_request", value: self.id_Request)
                SmartFoxObject.sharedInstance.sendExtendsionRequest(kExtCmd, param: param, isNeedShowLoading: false)
            }
            else
            {
                SmartFoxObject.sharedInstance.connectedToSmartfox()
            }
        }
        
        SmartFoxObject.sharedInstance.blockCallBack = {
            (type , result) in
            
            if type == kCmdConnectedSuccess
            {
                loginToZone()
            }
            else if type == kCmdLoginSuccess2ND
            {
                if self.flagRequestShipperOrReconnect == false{
                    let param = SFSObject.newInstance()
                    param?.putUtfString("command", value: kCmdRequestShipper)
                    param?.putUtfString("type", value: service)
                    param?.putInt("minute", value: (self.sender.timeSender.minute))
                    param?.putInt("hour", value: (self.sender.timeSender.hour))
                    param?.putInt("day", value: (self.sender.timeSender.day))
                    param?.putInt("month", value:(self.sender.timeSender.month))
                    param?.putInt("year", value: (self.sender.timeSender
                        .year))
                    param?.putBool("return_to_pickup", value: (self.sender.returnToPickupSender))
                    if listLocation != nil{
                        param?.putSFSArray("locations", value: listLocation)
                    }
                    param?.putInt("online_payment_order_id", value: self.online_payment_order_id)
                    param?.putUtfString("id_request", value: self.id_Request)
                    SmartFoxObject.sharedInstance.sendExtendsionRequest(kExtCmd, param: param, isNeedShowLoading: false)
                }
                else
                {
                    if self.id_Request != nil
                    {
                        let param = SFSObject.newInstance()
                        param?.putUtfString("command", value: kCmdCkeckRequest)
                        param?.putUtfString("id_request", value: self.id_Request)
                        SmartFoxObject.sharedInstance.sendExtendsionRequest(kExtCmd, param: param, isNeedShowLoading: false)
                    }
                    else
                    {
                        customAlertView(self, title: MCLocalization.string(forKey: "FINDINGWHENDIS"), btnTitleNameNormal: name_confirm_Button_Normal,titleButton: MCLocalization.string(forKey: "CONFIRM"),blockCallback: {result in
                            self.navigationController?.popViewController(animated: true)
                        })
                    }
                }
                
            }
            else if type == kCmdDisconnect
            {
                self.flagRequestShipperOrReconnect = true
                if UIApplication.shared.applicationState == .active
                {
                    self.reConnectedSmartFox()
                }
                else
                {
                    self.flagReconectSocketFromBackground = true
                }
            }
            else if type == kCmdCkeckRequest
            {
                let checkrequestObj = result as? CheckRequest
                if checkrequestObj?.status == -1
                {
                    customAlertView(self, title: MCLocalization.string(forKey: "FINDINGWHENDIS"), btnTitleNameNormal: name_confirm_Button_Normal,titleButton: MCLocalization.string(forKey: "CONFIRM"),blockCallback: {result in
                        self.navigationController?.popViewController(animated: true)
                    })
                }
                else if  checkrequestObj?.status == 0
                {
                    
                }
                else
                {
                    let param = SFSObject.newInstance()
                    param?.putUtfString("command", value: kcmdGetFollowJourney)
                    param?.putInt("id_order", value: (checkrequestObj?.status)!)
                    SmartFoxObject.sharedInstance.sendExtendsionRequest(kExtCmd, param: param, isNeedShowLoading: true)
                }
                
            }
            else if type == kcmdGetFollowJourney
            {

                    let objFollowJourney = result as! FollowJourneyObject
//                    let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "FollowJouneyMapViewController") as! FollowJouneyMapViewController
//                    vc.listPoint = objFollowJourney.locations
//                    vc.senderShipper = objFollowJourney.shipper
//                    vc.flagFromSlideMenu = true
//                    vc.order_id = self.order_id
//                    self.navigationController?.pushViewController(vc, animated: true)
                
               // shipper: obj.shipper!, flagPayment: obj.is_payment!, order_id: obj.order_id
                
                let resPonseObj = ResponseShipper()
                resPonseObj.shipper = objFollowJourney.shipper
                resPonseObj.is_payment = objFollowJourney.is_payment
                resPonseObj.order_id = objFollowJourney.order_id
                resPonseObj.listLocation = objFollowJourney.locations
                self.shipperAccept(resPonseObj , service : service)
                
            }

            else if type == kCmdShipperAccept
            {
                self.shipperAccept(result as! ResponseShipper , service : service)
            }
            else if type == kCmdShipperCancel
            {
                self.shipperCancel(error :  result as! ResponseShipperError , service : service)
            }
            else if type == kCmdRequestError
            {
                let data = result as? RequestShipper
                customAlertView(self, title: getErrorStringConfig(code: String(format: "%d", (data?.code)!))!, btnTitleNameNormal: name_confirm_Button_Normal,titleButton: "OK", blockCallback: {result in
                    self.navigationController?.popViewController(animated: true)
                    
                })
            }
            else if type == kCmdError
            {
                customAlertView(self, title: getErrorStringConfig(code: String(describing: result as! Int))!, btnTitleNameNormal: name_confirm_Button_Normal,titleButton: "OK", blockCallback: {result in
                    appDelegate.setRootView(isShowFollowJouneyStackScreen: false)
                })
                
                
            }
            else if type == kCmdCancelRequestByUser
            {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
    
    
    func shipperAccept(_ obj : ResponseShipper, service: String)
    {
        appDelegate.listSelected.removeAll()
        if service == "PICKUP"{
            appDelegate.order_id_following = obj.order_id
            appDelegate.setRootViewFollowJouney(locations: (sender.listLocationSender!), shipper: obj.shipper!, flagPayment: obj.is_payment!, order_id: obj.order_id!)
        }
        else
        {
            appDelegate.order_id_following = obj.order_id
            appDelegate.setRootViewFollowJouney(locations: obj.listLocation, shipper: obj.shipper!, flagPayment: obj.is_payment!, order_id: obj.order_id!)
        }
        
        
        
        
    }
    func shipperCancel(error: ResponseShipperError,service: String)
    {
        if service == "PICKUP"
        {
            
                
                if error.is_set_schedule_time!
                {
                    let date = error.set_schedule_time?.toDateTime(dateFormatStr: "yyyy-MM-dd HH:mm:ss")
                    for item in (self.navigationController?.viewControllers)!
                    {
                        if let vc = item as? OrderViewController
                        {
                            vc.sender.timeSender.day = Calendar.current.component(.day, from: date! as Date)
                            vc.sender.timeSender.month = Calendar.current.component(.month, from: date! as Date)
                            vc.sender.timeSender.year = Calendar.current.component(.year, from: date! as Date)
                            vc.sender.timeSender.minute = Calendar.current.component(.minute, from: date! as Date)
                            vc.sender.timeSender.hour = Calendar.current.component(.hour, from: date! as Date)
                            vc.returnFromMatching = true
                            vc.error_codeFromMatching = error.code
                            self.navigationController?.popToViewController(vc, animated: true)
                            break
                        }
                        
                    }
                    
                }
                else
                {
                    customAlertView(self, title: getErrorStringConfig(code: String(describing: error.code!))!, btnTitleNameNormal: name_confirm_Button_Normal, titleButton: "OK", blockCallback: { (result) in
                        if error.is_show_follow_list_screen!
                        {
                            appDelegate.setRootView(isShowFollowJouneyStackScreen: true)
                        }
                        else
                        {
                            self.navigationController?.popViewController(animated: true)
                        }
                    })
                    
                }
   
        }else
        {
            if error.is_set_schedule_time!
            {
                let date = error.set_schedule_time?.toDateTime(dateFormatStr: "yyyy-MM-dd HH:mm:ss")
                for item in (self.navigationController?.viewControllers)!
                {
                    if let vc = item as? CartViewController
                    {
                        vc.timeDelivery.day = Calendar.current.component(.day, from: date! as Date)
                        vc.timeDelivery.month = Calendar.current.component(.month, from: date! as Date)
                        vc.timeDelivery.year = Calendar.current.component(.year, from: date! as Date)
                        vc.timeDelivery.minute = Calendar.current.component(.minute, from: date! as Date)
                        vc.timeDelivery.hour = Calendar.current.component(.hour, from: date! as Date)
                        vc.returnFromMatching = true
                        vc.error_codeFromMatching = error.code
                        self.navigationController?.popToViewController(vc, animated: true)
                        break
                    }
                    
                }

            }
            else
            {
                customAlertView(self, title: getErrorStringConfig(code: String(describing: error.code!))!, btnTitleNameNormal: name_confirm_Button_Normal, titleButton: "OK", blockCallback: { (result) in
                    if error.is_show_follow_list_screen!
                    {
                        appDelegate.setRootView(isShowFollowJouneyStackScreen: true)
                    }
                    else
                    {
                        self.navigationController?.popViewController(animated: true)
                    }
                })

            }
            
//            customAlertView(self, title: getErrorStringConfig(code: String(describing: error.code!))!, btnTitleNameNormal: name_confirm_Button_Normal, titleButton: "OK", blockCallback: { (result) in
//                if error.is_set_schedule_time!
//                {
//                    let date = error.set_schedule_time?.toDateTime(dateFormatStr: "yyyy-MM-dd HH:mm:ss")
//                    for item in (self.navigationController?.viewControllers)!
//                    {
//                        if let vc = item as? CartViewController
//                        {
//                            vc.timeDelivery.day = Calendar.current.component(.day, from: date! as Date)
//                            vc.timeDelivery.month = Calendar.current.component(.month, from: date! as Date)
//                            vc.timeDelivery.year = Calendar.current.component(.year, from: date! as Date)
//                            vc.timeDelivery.minute = Calendar.current.component(.minute, from: date! as Date)
//                            vc.timeDelivery.hour = Calendar.current.component(.hour, from: date! as Date)
//                            self.navigationController?.popToViewController(vc, animated: true)
//                            break
//                        }
//                        
//                    }
//                    
//                }
//                else{
//                    if error.is_show_follow_list_screen!
//                    {
//                        appDelegate.setRootView(isShowFollowJouneyStackScreen: true)
//                    }
//                    else
//                    {
//                        self.navigationController?.popViewController(animated: true)
//                    }
//                    
//                }
//            })
        }
    }
    @IBAction func btnCancel (_ senderr: UIButton)
    {
        let param = SFSObject.newInstance()
        param?.putUtfString("command", value: kCmdCancelRequestByUser)
        SmartFoxObject.sharedInstance.sendExtendsionRequest(kExtCmd, param: param, isNeedShowLoading: true)
    }
    func reConnectedSmartFox()
    {
        
        if connectedToNetwork()
        {
            registerBackgroundTask()
            if  SmartFoxObject.sharedInstance.smartFox != nil && SmartFoxObject.sharedInstance.smartFox.isConnected != true
            {
                SmartFoxObject.sharedInstance.connectedToSmartfox()
            }
        }
        else
        {
            //SmartFoxObject.sharedInstance.blockCallBack!(kCmdDisconnect, nil)
            customAlertViewWithCancelButton(self, title: MCLocalization.string(forKey: "DISCONNECT"), btnTitleNameNormal: name_confirm_Button_Normal,  btnCancelNameNormal: name_cancel_Button_Normal,titleOrangeButton: MCLocalization.string(forKey: "TRY"), titleGreyButton: MCLocalization.string(forKey: "EXIT"), isClose: false,  blockCallback: {result in
                self.reConnectedSmartFox()
            }, blockCallbackCancel: {result in
                appDelegate.setRootView(isShowFollowJouneyStackScreen: false)
            })
        }
    }
    func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        assert(backgroundTask != UIBackgroundTaskInvalid)
    }
    
    func endBackgroundTask() {
        print("Background task ended.")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskInvalid
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
