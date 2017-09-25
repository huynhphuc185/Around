//
//  OrderViewController.swift
//  Shipper
//
//  Created by phuc.huynh on 9/14/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import UIKit
import ObjectMapper

class OrderViewController: StatusbarViewController,protocolPaymentWebView {
    var estObj : EstimateObject?
    //var listAddress:[PointLocation]?
    var sender: DataSender = DataSender()
    var online_payment_order_id = 0
    internal var dates: [Date]! = []
    @IBOutlet weak var sidebarButton: UIBarButtonItem!
    @IBOutlet weak var tblview: UITableView!
    @IBOutlet weak var constrainHeightTablview: NSLayoutConstraint!
    
    
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var btnConfirm: UIButton!
    
    @IBOutlet weak var btnCash: UIButton!
    @IBOutlet weak var btnOnline: UIButton!
    @IBOutlet weak var btnViAround: UIButton!
    
    
    @IBOutlet weak var imageOnline: UIButton!
    @IBOutlet weak var imageCheckOnline: UIButton!
    
    
    @IBOutlet weak var imageViAround: UIButton!
    @IBOutlet weak var imageCoinAround: UIButton!
    @IBOutlet weak var lblCoin: UILabel!
    
    @IBOutlet weak var imageCash: UIButton!
    @IBOutlet weak var imageCheckCash: UIButton!
    
    
    @IBOutlet weak var lblOnline: UILabel!
    @IBOutlet weak var lblViAround: UILabel!
    @IBOutlet weak var lblCash: UILabel!
    
    
    @IBOutlet weak var lblItemCost: UILabel!
    @IBOutlet weak var lblServiceFee: UILabel!
    @IBOutlet weak var lblShippingFee: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblItemCostLayout: UILabel!
    @IBOutlet weak var constrainsItemCostHeight: NSLayoutConstraint!
    @IBOutlet weak var constrainsItemCostTop: NSLayoutConstraint!
    var returnFromMatching = false
    var error_codeFromMatching : Int?
    var paymentObj : PaymentObject?
    var id_Request : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        sidebarButton.action = #selector(self.backtoMap)
        tblview.rowHeight = UITableViewAutomaticDimension
        tblview.estimatedRowHeight = 300
        
        btnConfirm.isEnabled = false
        let currentTime = Time()
        currentTime.year = Calendar.current.component(.year, from: Date())
        currentTime.month = Calendar.current.component(.month, from: Date())
        currentTime.day = Calendar.current.component(.day, from: Date())
        currentTime.minute = Calendar.current.component(.minute, from: Date())
        currentTime.hour = Calendar.current.component(.hour, from: Date())
        self.lblTime.text = self.setCurrentDayString(date: currentTime, needSet60Phut: true)
        DataConnect.getPayment(token_API, country_code: kCountryCode, phone: userPhone_API,view: self.view,  onsuccess: { (data) in
            if let result = data as? PaymentObject
            {
                self.paymentObj = data as? PaymentObject
                if result.payment_type == "CASH"
                {
                    self.btnPaymentMethod(self.btnCash)
                }
                else if result.payment_type == "ONLINE"
                {
                    self.btnPaymentMethod(self.btnOnline)
                }
                else
                {
                    self.btnPaymentMethod(self.btnViAround)
                }
            }
            
        }) {error in
            
        }
        let listJsonArray = NSMutableArray()
        for item in (sender.listLocationSender?.enumerated())!
        {
            if let json = item.element.toJSONString() {
                listJsonArray.add(convertStringToDictionary(json)!)
            }
        }
        let myJson = arrayDictToJSON(dictionaryOrArray: listJsonArray)!
        DataConnect.estimationCost(userPhone_API, country_code: kCountryCode, token: token_API, locations: myJson as NSString, minute: (sender.timeSender.minute), hour: (sender.timeSender.hour), day: (sender.timeSender.day), month: (sender.timeSender.month), year:(sender.timeSender.year), returntopickup: (sender.returnToPickupSender) ,view: self.view,  onsuccess: { (data) in
            if let result = data as? EstimateObject
            {
                self.btnConfirm.isEnabled = true
                self.estObj = result
                //self.lblDistance.text = NSString(format: "%.2f Km", result.distance!) as String
                self.lblShippingFee.text = NSString(format: "%@đ",setCommaforNumber(result.shipping_fee!)) as String
                self.lblItemCost.text = NSString(format: "%@đ",setCommaforNumber(result.item_cost!)) as String
                self.lblServiceFee.text = NSString(format: "%@đ",setCommaforNumber(result.service_fee!)) as String
                self.lblTotal.text = NSString(format: "%@đ", setCommaforNumber(result.total!)) as String
                
            }
        }) { error in
            showErrorMessage(error: error as! Int, vc: self)
        }
        
        
        
    }
    deinit {
        print("a")
    }
    override func viewWillAppear(_ animated: Bool) {
        DataConnect.getAroundPay_(token_API, country_code: kCountryCode, phone: userPhone_API,view: self.view,  onsuccess: { (result) in
            let cash = result as? Double
            self.lblCoin.text = NSString(format: "%@đ",setCommaforNumber(Int(cash!))) as String
        }) { (error) in
            showErrorMessage(error: error as! Int, vc: self)
        }

        if returnFromMatching
        {
            customAlertViewWithCancelButtonWithCloseButton(self, title: getErrorStringConfig(code: String(format: "%d", error_codeFromMatching!))!, btnTitleNameNormal: name_confirm_Button_Normal,  btnCancelNameNormal: name_cancel_Button_Normal,titleOrangeButton: MCLocalization.string(forKey: "TIMLAI"), titleGreyButton: MCLocalization.string(forKey: "SAU30PHUT"), isClose: true,  blockCallback: {result in
                self.returnFromMatching = false
                self.sender.timeSender = Time()
                self.confirmClick(nil)
                
            }, blockCallbackCancel: {result in
                self.lblTime.text = self.setCurrentDayString(date: self.sender.timeSender, needSet60Phut: true)
                self.returnFromMatching = false
                self.confirmClick(nil)
            },blockCallbackClose: { result in
                self.sender.timeSender = Time()
                self.returnFromMatching = false
            })
            
        }
        
    }
    
    
    override func viewDidLayoutSubviews() {
        for item in sender.listLocationSender!
        {
            if item.pickup_type == 2
            {
                self.lblItemCostLayout.text = MCLocalization.string(forKey: "SOTIENMUAHO")
                self.constrainsItemCostHeight.constant = 17
                self.constrainsItemCostTop.constant = 8
                break
            }
            else
            {
                self.constrainsItemCostHeight.constant = 0
                self.constrainsItemCostTop.constant = 0
            }
        }
        self.view.layoutIfNeeded()
        
    }
    
    func backtoMap()
    {
        tracking(actionKey: "C6.4N")
        sender.timeSender = Time()
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelClick(_ sender: AnyObject) {
        
    }
    @IBAction func btnChangePositionClick(_ sender: AnyObject) {
        self.sender.listLocationSender?.swap(ind1: 1, 2)
        self.tblview.reloadData()
        
        
    }
    @IBAction func btnPaymentMethod(_ sender: UIButton) {
        if sender.tag == 1
        {
            imageOnline.isSelected = true
            imageViAround.isSelected = false
            imageCash.isSelected = false
            lblOnline.textColor = UIColor(hex: colorCam)
            lblViAround.textColor = UIColor(hex: colorXamNhat)
            lblCash.textColor = UIColor(hex: colorXamNhat)
            lblOnline.font = UIFont(name: "OpenSans-Semibold", size: 14)
            lblViAround.font = UIFont(name: "OpenSans", size: 14)
            lblCash.font = UIFont(name: "OpenSans", size: 14)
            imageCheckOnline.isSelected = false
            imageCoinAround.isSelected = false
            imageCheckCash.isSelected = false
            lblCoin.textColor = UIColor(hex: colorXamNhat)
            paymentObj?.payment_type = "ONLINE"
            DataConnect.updatePayment(paymentObj!, numberPhone: userPhone_API, country_code: kCountryCode, token: token_API,view: self.view,  onsuccess: { (result) in
            }, onFailure: { error in
                showErrorMessage(error: error as! Int, vc: self)
                
                
            })
        }
        else if sender.tag == 2
        {
            
            imageOnline.isSelected = false
            imageViAround.isSelected = true
            imageCash.isSelected = false
            lblOnline.textColor = UIColor(hex: colorXamNhat)
            lblViAround.textColor = UIColor(hex: colorCam)
            lblCash.textColor = UIColor(hex: colorXamNhat)
            lblOnline.font = UIFont(name: "OpenSans", size: 14)
            lblViAround.font = UIFont(name: "OpenSans-Semibold", size: 14)
            lblCash.font = UIFont(name: "OpenSans", size: 14)
            imageCheckOnline.isSelected = false
            imageCoinAround.isSelected = true
            imageCheckCash.isSelected = false
            lblCoin.textColor = UIColor(hex: colorCam)
            
            paymentObj?.payment_type = "AROUND_PAY"
            DataConnect.updatePayment(paymentObj!, numberPhone: userPhone_API, country_code: kCountryCode, token: token_API,view: self.view,  onsuccess: { (result) in
            }, onFailure: { error in
                showErrorMessage(error: error as! Int, vc: self)
                
                
            })
            
        }
        else if sender.tag == 3
        {
            
            imageOnline.isSelected = false
            imageViAround.isSelected = false
            imageCash.isSelected = true
            lblOnline.textColor = UIColor(hex: colorXamNhat)
            lblViAround.textColor = UIColor(hex: colorXamNhat)
            lblCash.textColor = UIColor(hex: colorCam)
            lblOnline.font = UIFont(name: "OpenSans", size: 14)
            lblViAround.font = UIFont(name: "OpenSans", size: 14)
            lblCash.font = UIFont(name: "OpenSans-Semibold", size: 14)
            imageCheckOnline.isSelected = false
            imageCoinAround.isSelected = false
            imageCheckCash.isSelected = false
            lblCoin.textColor = UIColor(hex: colorXamNhat)
            paymentObj?.payment_type = "CASH"
            DataConnect.updatePayment(paymentObj!, numberPhone: userPhone_API, country_code: kCountryCode, token: token_API,view: self.view,  onsuccess: { (result) in
            }, onFailure: { error in
                showErrorMessage(error: error as! Int, vc: self)
                
                
            })
            
            
        }
        
    }
    func showCalendar(dateChoose: Time,blockCallback: @escaping callBack)
    {
        let myAlert = giftingStoryBoard.instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController
        myAlert.blockCallBack = blockCallback
        myAlert.dateChoose = dateChoose
        myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(myAlert, animated: false, completion: nil)
    }
    @IBAction func btnShowPrice(_ sender: AnyObject?){
        let myAlert = pickUpStoryBoard.instantiateViewController(withIdentifier: "PopUpGiaViewController") as! PopUpGiaViewController
        if MCLocalization.sharedInstance().language == "en" {
            myAlert.imageURL = Config.sharedInstance.imagePrice_TA
        }
        else{
            myAlert.imageURL = Config.sharedInstance.imagePrice_TV
        }
        myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(myAlert, animated: false, completion: nil)
    }
    @IBAction func btnShowPriceServiceFee(_ sender: AnyObject?){
        let myAlert = pickUpStoryBoard.instantiateViewController(withIdentifier: "PopUpGiaViewController") as! PopUpGiaViewController
        
        if MCLocalization.sharedInstance().language == "en" {
            myAlert.imageURL = Config.sharedInstance.imagePrice_ServicePickupTA
        }
        else{
            myAlert.imageURL = Config.sharedInstance.imagePrice_ServicePickupTV
        }
        myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(myAlert, animated: false, completion: nil)
    }

    @IBAction func btnSetdeliveryTime(_ sender_: AnyObject?){
        showCalendar(dateChoose:sender.timeSender, blockCallback: { (result) in
            self.sender.timeSender = result as! Time
            if self.sender.timeSender.day == 0
            {
                let currentTime = Time()
                currentTime.year = Calendar.current.component(.year, from: Date())
                currentTime.month = Calendar.current.component(.month, from: Date())
                currentTime.day = Calendar.current.component(.day, from: Date())
                currentTime.minute = Calendar.current.component(.minute, from: Date())
                currentTime.hour = Calendar.current.component(.hour, from: Date())
                self.lblTime.text = self.setCurrentDayString(date: currentTime, needSet60Phut: true)
            }
            else
            {
                self.lblTime.text = self.setCurrentDayString(date: self.sender.timeSender, needSet60Phut: false)
            }
            
            
            //            let listJsonArray = NSMutableArray()
            //            for item in (self.sender.listLocationSender?.enumerated())!
            //            {
            //                if let json = item.element.toJSONString() {
            //                    listJsonArray.add(convertStringToDictionary(json)!)
            //                }
            //            }
            //            let myJson = arrayDictToJSON(dictionaryOrArray: listJsonArray)!
            //            DataConnect.estimationCost(userPhone_API, country_code: kCountryCode, token: token_API, locations: myJson as NSString, minute: (self.sender.timeSender.minute), hour: (self.sender.timeSender.hour), day: (self.sender.timeSender.day), month: (self.sender.timeSender.month), year:(self.sender.timeSender.year), returntopickup: (self.sender.returnToPickupSender) ,view: self.view,  onsuccess: { (data) in
            //                if let result = data as? EstimateObject
            //                {
            //                    //self.estObj = result
            //                    //self.lblDistance.text = NSString(format: "%.2f Km", result.distance!) as String
            //                    self.lblShippingFee.text = NSString(format: "%@đ",setCommaforNumber(result.shipping_fee!)) as String
            //                    self.lblItemCost.text = NSString(format: "%@đ",setCommaforNumber(result.item_cost!)) as String
            //                    self.lblServiceFee.text = NSString(format: "%@đ",setCommaforNumber(result.service_fee!)) as String
            //                    self.lblTotal.text = NSString(format: "%@đ", setCommaforNumber(result.total!)) as String
            //
            //                }
            //            }) { error in
            //                showErrorMessage(error: error as! Int, vc: self)
            //            }
            
            
        })
    }
    func setCurrentDayString(date:Time,needSet60Phut : Bool) -> String{
        if needSet60Phut
        {
            if returnFromMatching
            {
                let mins15304500 :Int?
                if date.minute <= 15
                {
                    mins15304500 = 15
                }
                else if date.minute <= 30
                {
                    mins15304500 = 30
                }
                else if date.minute <= 45
                {
                    mins15304500 = 45
                }
                else
                {
                    mins15304500 = 60
                }
                
                let dateBackFromMatching = String(format: "%02d-%02d-%02d %02d:%02d", sender.timeSender.year,sender.timeSender.month,sender.timeSender.day,sender.timeSender.hour,sender.timeSender.minute).toDateTime(dateFormatStr: "yyyy-MM-dd HH:mm") as Date
                let miliMore15Mins = dateBackFromMatching.timeIntervalSinceNow + Double((mins15304500! - date.minute)*60)
                let date15Mins = Date(timeIntervalSinceNow: miliMore15Mins)
                let newHour =  Calendar.current.component(.hour, from: date15Mins)
                let newMin =  Calendar.current.component(.minute, from: date15Mins)
                let currentTimeString = formatTimeWithFormat(min: newMin, hour: newHour, formatString: "h:mm a")
                let currentDateString = formatDateWithFormat(day: date.day, month: date.month, year: date.year, formatString: "dd/MM/yyyy")
                return currentTimeString + " " + currentDateString
            }
            else
            {
                let mins15304500 :Int?
                if date.minute <= 15
                {
                    mins15304500 = 15
                }
                else if date.minute <= 30
                {
                    mins15304500 = 30
                }
                else if date.minute <= 45
                {
                    mins15304500 = 45
                }
                else
                {
                    mins15304500 = 60
                }
                let now = Date()
                let miliMore15Mins: Double?
                miliMore15Mins = now.timeIntervalSinceNow + Double((mins15304500! - date.minute)*60)  + 3600
                let date15Mins = Date(timeIntervalSinceNow: miliMore15Mins!)
                
                let newHour =  Calendar.current.component(.hour, from: date15Mins)
                let newMin =  Calendar.current.component(.minute, from: date15Mins)
                
                let currentTimeString = formatTimeWithFormat(min: newMin, hour: newHour, formatString: "h:mm a")
                let currentDateString = formatDateWithFormat(day: date.day, month: date.month, year: date.year, formatString: "dd/MM/yyyy")
                return currentTimeString + " " + currentDateString
            }
            
        }
        else
        {
            let currentTimeString = formatTimeWithFormat(min: date.minute, hour: date.hour, formatString: "h:mm a")
            let currentDateString = formatDateWithFormat(day: date.day, month: date.month, year: date.year, formatString: "dd/MM/yyyy")
            return currentTimeString + " " + currentDateString
        }
        
    }
    @IBAction func confirmClick(_ sender_: AnyObject?) {
        tracking(actionKey: "C15.5Y")
        if connectedToNetwork() == false{
            customAlertView(self, title: MCLocalization.string(forKey: "FINDINGWHENDIS"), btnTitleNameNormal: name_confirm_Button_Normal,titleButton: MCLocalization.string(forKey: "CONFIRM"),blockCallback: {result in
                self.navigationController?.popToRootViewController(animated: true)
            })
            
        }
        else
        {
            if paymentObj?.payment_type == "CASH"
            {
                if estObj == nil{
                    return
                }
                if (estObj?.total!)! >= Config.sharedInstance.min_pickup_payment_cost!
                {
                    customAlertView(self, title: MCLocalization.string(forKey: "LIMITCOST", withPlaceholders: ["%value%" : setCommaforNumber(Config.sharedInstance.min_pickup_payment_cost!)]), btnTitleNameNormal: name_confirm_Button_Normal,titleButton: MCLocalization.string(forKey: "CONFIRM"),blockCallback: {result in
                        
                    })
                    return
                }
            }
            if sender.timeSender.day != 0 &&  sender.timeSender.month != 0 && sender.timeSender.year != 0
            {
                let dateDelivery = String(format: "%02d-%02d-%02d %02d:%02d", sender.timeSender.year,sender.timeSender.month,sender.timeSender.day,sender.timeSender.hour,sender.timeSender.minute).toDateTime(dateFormatStr: "yyyy-MM-dd HH:mm")
                let now = Date()
                let minuteBetween2Time = dateDelivery.timeIntervalSince(now)
                if minuteBetween2Time/60 < Double(Config.sharedInstance.set_schedule_control_time! - 2)
                {
                    customAlertView(self, title: MCLocalization.string(forKey: "LIMITTIME"), btnTitleNameNormal: name_confirm_Button_Normal,titleButton: MCLocalization.string(forKey: "CONFIRM"),blockCallback: {result in
                        
                    })
                    return
                }
            }
            
            DataConnect.getRequestOrderID(token_API, country_code: kCountryCode, phone: userPhone_API, view: self.view, onsuccess: { (result) in
                self.id_Request = result as? String
                self.blockCallBackFromSmartFoxPickup(order_ID: 0)
            }, onFailure: { (error) in
            })
        }
    }
    
    func blockCallBackFromSmartFoxPickup(order_ID : Int)
    {
        let listJsonArray : ISFSArray = SFSArray.newInstance()
        for item in (self.sender.listLocationSender?.enumerated())!
        {
            if let json = item.element.toJSONString() {
                listJsonArray.addUtfString(json)
                
            }
        }
        if SmartFoxObject.sharedInstance.smartFox.isConnected
        {
            let param = SFSObject.newInstance()
            param?.putUtfString("command", value: kCmdRequestShipper)
            param?.putUtfString("type", value: "PICKUP")
            param?.putInt("minute", value: (self.sender.timeSender.minute))
            param?.putInt("hour", value: (self.sender.timeSender.hour))
            param?.putInt("day", value: (self.sender.timeSender.day))
            param?.putInt("month", value:(self.sender.timeSender.month))
            param?.putInt("year", value: (self.sender.timeSender.year))
            param?.putBool("return_to_pickup", value: (self.sender.returnToPickupSender))
            param?.putSFSArray("locations", value: listJsonArray)
            param?.putInt("online_payment_order_id", value: order_ID)
            param?.putUtfString("id_request", value: self.id_Request)
            SmartFoxObject.sharedInstance.sendExtendsionRequest(kExtCmd, param: param, isNeedShowLoading: true)
        }
        else
        {
            SmartFoxObject.sharedInstance.connectedToSmartfox()
        }
        SmartFoxObject.sharedInstance.blockCallBack = {
            (type , result) in
            
            if type == kCmdConnectedSuccess
            {
                loginToZone()
            }
//            else if type == kCmdDisconnect
//            {
//                customAlertView(self, title: MCLocalization.string(forKey: "DISCONNECT"), btnTitleNameNormal: name_confirm_Button_Normal,titleButton: MCLocalization.string(forKey: "CONFIRM"),blockCallback:{result in
//                    
//                })
//            }
//            else if type == kCmdSendIDRequest
//            {
//                self.id_Request = result as? String
//                
//            }
            else if type == kCmdLoginSuccess2ND
            {
                
                let param = SFSObject.newInstance()
                param?.putUtfString("command", value: kCmdRequestShipper)
                param?.putUtfString("type", value: "PICKUP")
                param?.putInt("minute", value: (self.sender.timeSender.minute))
                param?.putInt("hour", value: (self.sender.timeSender.hour))
                param?.putInt("day", value: (self.sender.timeSender.day))
                param?.putInt("month", value:(self.sender.timeSender.month))
                param?.putInt("year", value: (self.sender.timeSender.year))
                param?.putBool("return_to_pickup", value: (self.sender.returnToPickupSender))
                param?.putSFSArray("locations", value: listJsonArray)
                param?.putInt("online_payment_order_id", value: order_ID)
                param?.putUtfString("id_request", value: self.id_Request)
                SmartFoxObject.sharedInstance.sendExtendsionRequest(kExtCmd, param: param, isNeedShowLoading: true)
                
            }
            else if type == kCmdChangeRequestScreen
            {
                let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "MatchingShipperViewController") as! MatchingShipperViewController
                vc.flagisPickupOrGifting =  false
                vc.sender = self.sender
                vc.online_payment_order_id = order_ID
                if self.id_Request == nil
                {
                    print("khong co id request")
                }
                else
                {
                    print(self.id_Request!)
                }
                vc.id_Request = self.id_Request
                self.navigationController?.pushViewController(vc, animated: true)
            }
                
            else if type == kCmdRequestShipper
            {
                let data = result as? RequestShipper
                if data?.is_follow_journey == true {
                    
                }
                else
                {
                    appDelegate.listSelected.removeAll()
                    customAlertView(self, title: MCLocalization.string(forKey: "FOLLOWJOUNEYSTACK"), btnTitleNameNormal: name_confirm_Button_Normal, titleButton: "OK",blockCallback: {result in
                        appDelegate.setRootView(isShowFollowJouneyStackScreen: true)
                    })
                    
                    
                }
            }
            else if type == kCmdRequestError
            {
                let data = result as? RequestShipper
                
                if (data?.is_max_process)!
                {
                    customAlertView(self, title: getErrorStringConfig(code: String(format: "%d", (data?.code)!))!, btnTitleNameNormal: name_confirm_Button_Normal,titleButton: "OK", blockCallback: {result in
                    })
                    return
                    
                }
                if (data?.is_set_schedule_time)!
                {
                    customAlertView(self, title: getErrorStringConfig(code: String(format: "%d", (data?.code)!))!, btnTitleNameNormal: name_confirm_Button_Normal,titleButton: "OK", blockCallback: {result in
                        //phuc
                        let date = data?.set_schedule_time?.toDateTime(dateFormatStr: "yyyy-MM-dd HH:mm:ss")
                        self.sender.timeSender.day = Calendar.current.component(.day, from: date! as Date)
                        self.sender.timeSender.month = Calendar.current.component(.month, from: date! as Date)
                        self.sender.timeSender.year = Calendar.current.component(.year, from: date! as Date)
                        self.sender.timeSender.minute = Calendar.current.component(.minute, from: date! as Date)
                        self.sender.timeSender.hour = Calendar.current.component(.hour, from: date! as Date)
                        self.lblTime.text =  self.setCurrentDayString(date: self.sender.timeSender, needSet60Phut: false)
                        
                    })
                    
                    
                }
                else{
                    if (data?.is_online_payment) == false
                    {
                        if data?.is_not_enough_aroundpay == true
                        {
                            
                            customAlertViewWithCancelButton(self, title: getErrorStringConfig(code: String(format: "%d", (data?.code)!))!, btnTitleNameNormal: name_confirm_Button_Normal,  btnCancelNameNormal: name_cancel_Button_Normal,titleOrangeButton: MCLocalization.string(forKey: "NAP"), titleGreyButton: MCLocalization.string(forKey: "CANCEL"), isClose: false,  blockCallback: {result in
                                showProgressHub()
                                DataConnect.getAroundPay_(token_API, country_code: kCountryCode, phone: userPhone_API,view: self.view,  onsuccess: { (result) in
                                    hideProgressHub()
                                    let cash = result as? Double
                                    let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "ViAroundViewController") as! ViAroundViewController
                                    vc.money = cash
                                    self.present(vc, animated: true, completion: nil)
                                    
                                    
                                }) { (error) in
                                    hideProgressHub()
                                    showErrorMessage(error: error as! Int, vc: self)
                                }                        }, blockCallbackCancel: {result in
                                    
                            })
                            
                        }
                        else
                        {
                            customAlertView(self, title: getErrorStringConfig(code: String(format: "%d", (data?.code)!))!, btnTitleNameNormal: name_confirm_Button_Normal,titleButton: "OK", blockCallback: {result in
                                
                            })
                        }
                        
                        
                    }
                    else
                    {
                        let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "BankViewController") as! BankViewController
                        vc.order_id = data?.online_payment_order_id
                        self.online_payment_order_id = (data?.online_payment_order_id)!
                        vc.delegate = self
                        let nav = UINavigationController(rootViewController: vc)
                        nav.modalPresentationStyle = .overCurrentContext
                        nav.modalTransitionStyle = .crossDissolve
                        nav.isNavigationBarHidden = true
                        self.present(nav, animated: true, completion: nil)                    }
                }
                
                
                
                
                
            }
            else if type == kCmdError
            {
                customAlertView(self, title: getErrorStringConfig(code: String(describing: result as! Int))! , btnTitleNameNormal: name_confirm_Button_Normal,titleButton: "OK",  blockCallback: { (result) in
                })
                
            }
        }
    }
    func callBack(isPayment: Bool, order_ID: Int) {
        if isPayment == true
        {
            if sender.timeSender.day != 0 &&  sender.timeSender.day != 0 && sender.timeSender.day != 0
            {
                blockCallBackFromSmartFoxPickup(order_ID: order_ID)
            }
            else
            {
                let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "MatchingShipperViewController") as! MatchingShipperViewController
                vc.sender =  sender
                vc.flagisPickupOrGifting = false
                vc.online_payment_order_id = order_ID
                if self.id_Request == nil
                {
                    print("khong co id request")
                }
                else
                {
                    print(self.id_Request!)
                }
                vc.id_Request = self.id_Request
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
extension OrderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (tableView.indexPathsForVisibleRows!.last! as NSIndexPath).row {
            // End of loading
            constrainHeightTablview.constant = tblview.contentSize.height
            self.view.layoutIfNeeded()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sender.listLocationSender == nil
        {
            return 0
        }
        return sender.listLocationSender!.count
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let obj = sender.listLocationSender?[indexPath.row]
        if obj?.role == 3
        {
            let cell = self.tblview.dequeueReusableCell(withIdentifier: "OrderCellDrop") as! OrderCellDrop
            cell.lblAddress.text = obj?.address
            return cell
        }
        else
        {
            let cell = self.tblview.dequeueReusableCell(withIdentifier: "OrderCellPickUp") as! OrderCellPickUp
            
            if MCLocalization.sharedInstance().language == "vi"
            {
                cell.lblDiadiemLayhang.text = MCLocalization.string(forKey: "DIADIEMLAYHANG") + String(format:" %d",(indexPath.row + 1))
            }
            else
            {
                if indexPath.row == 0
                {
                    cell.lblDiadiemLayhang.text =  "1st " + MCLocalization.string(forKey: "DIADIEMLAYHANG")
                }
                else if indexPath.row ==  1
                {
                    cell.lblDiadiemLayhang.text =  "2nd " + MCLocalization.string(forKey: "DIADIEMLAYHANG")
                }
                else if indexPath.row ==  2{
                    cell.lblDiadiemLayhang.text =  "3rd " + MCLocalization.string(forKey: "DIADIEMLAYHANG")
                }
            }
            cell.lblAddress.text = obj?.address
            if indexPath.row == 0
            {
                cell.imageLocation.image = UIImage(named:"location1")
            }
            else if indexPath.row == 1
            {
                cell.imageLocation.image = UIImage(named:"location2")
            }
            else if indexPath.row == 2
            {
                cell.imageLocation.image = UIImage(named:"location3")
            }
            cell.lblItemName.text = obj?.item_name
            cell.lblNote.text = obj?.note
            if obj?.note == ""
            {
                cell.constrainsNote.constant = 0
                cell.constrainstopNote.constant = 0
                cell.constrainsBottomNote.constant = 0
                cell.constrainsLine.constant = -2
                cell.viewNote.isHidden = true
                self.view.layoutIfNeeded()
            }
            if obj?.pickup_type == 1
            {
                cell.lblMuahoThuHo.text = MCLocalization.string(forKey: "VANCHUYEN").uppercased()
                cell.lblPrice.isHidden = true
            }
            else if obj?.pickup_type == 2
            {
                cell.lblMuahoThuHo.text = MCLocalization.string(forKey: "MUAHO").uppercased()
                cell.lblPrice.isHidden = false
                cell.lblPrice.text = String(format: "%@đ", (obj?.item_cost.stringFormattedWithSeparator)!)
            }
            else if obj?.pickup_type == 3
            {
                cell.lblMuahoThuHo.text = MCLocalization.string(forKey: "THUHO").uppercased()
                cell.lblPrice.isHidden = false
                cell.lblPrice.text = String(format: "%@đ", (obj?.item_cost.stringFormattedWithSeparator)!)
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}



class OrderHistoryCell : UITableViewCell
{
    static let identifier = "OrderHistoryCell"
    @IBOutlet weak var lblPickupType: UILabel!
    @IBOutlet weak var lbltotalMoney: UILabel!
    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var btnDatlai: UIButton!
    @IBOutlet weak var imageService: UIImageView!
    @IBOutlet weak var viewTypeService: UIView!
    @IBOutlet weak var lblOrderID: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var constrainsWidthBtnDatlai: NSLayoutConstraint!
    @IBOutlet weak var constrainsspaceBtnDatlai: NSLayoutConstraint!
    @IBOutlet weak var constrainsWidthCenter: NSLayoutConstraint!
}

class OrderCellPickUp : UITableViewCell
{
    static let identifier = "OrderCellPickup"
    @IBOutlet weak var lblMuahoThuHo: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblNumberLocation: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDiadiemLayhang: UILabel!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var viewItemName: UIView!
    @IBOutlet weak var viewNote: UIView!
    @IBOutlet weak var imageLocation: UIImageView!
    @IBOutlet weak var constrainsNote: NSLayoutConstraint!
    @IBOutlet weak var constrainstopNote: NSLayoutConstraint!
    @IBOutlet weak var constrainsBottomNote: NSLayoutConstraint!
    @IBOutlet weak var constrainsLine: NSLayoutConstraint!
}

class OrderCellDrop : UITableViewCell
{
    static let identifier = "OrderCellDrop"
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var viewAddres: UIView!
}



class DateCell : UICollectionViewCell
{
    static let identifier = "DateCell"
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var viewBottom: UIView!
}





