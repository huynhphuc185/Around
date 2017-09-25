//
//  CartViewController.swift
//  Around
//
//  Created by phuc.huynh on 12/22/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import UIKit
import GooglePlaces
class CartViewController: StatusBarWithSearchBarViewController,protocolPaymentWebView{
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var txtPickupLocation: UITextField!
    
    @IBOutlet weak var btnCash: UIButton!
    @IBOutlet weak var btnOnline: UIButton!
    @IBOutlet weak var btnViAround: UIButton!
    
    @IBOutlet weak var txtRecieptname: BottomLineTextfield!
    @IBOutlet weak var txtRecipentPhone: BottomLineTextfield!
    @IBOutlet weak var txtNote: BottomLineTextfield!
    @IBOutlet weak var viewNguoiNhan: UIView!
    @IBOutlet weak var imageOnline: UIButton!
    @IBOutlet weak var imageCheckOnline: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    
    @IBOutlet weak var imageViAround: UIButton!
    @IBOutlet weak var imageCoinAround: UIButton!
    @IBOutlet weak var lblCoin: UILabel!
    
    @IBOutlet weak var imageCash: UIButton!
    @IBOutlet weak var imageCheckCash: UIButton!
    
    
    @IBOutlet weak var lblOnline: UILabel!
    @IBOutlet weak var lblViAround: UILabel!
    @IBOutlet weak var lblCash: UILabel!
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var viewClose: UIView!
    @IBOutlet weak var lblItemCost: UILabel!
    @IBOutlet weak var lblServiceFee: UILabel!
    @IBOutlet weak var lblShippingFee: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    //@IBOutlet weak var btnGiftCart: UIButton!
    @IBOutlet weak var viewWhenSearchLocation: UIView!
    @IBOutlet weak var tblSearchLocation: UITableView!
    @IBOutlet weak var constrainTop: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblTime_Date_Delivery: UILabel!
    @IBOutlet weak var imageViewClock: UIImageView!
    var kindOfProduct: String?
    var timeDelivery = Time()
    var online_payment_order_id = 0
    var listSelect : [Product]?
    var blockUpdateTable : callBack?
    var resultsArray = [Address]()
    var flagPickupDelivery : Bool?
    let placeClient = GMSPlacesClient()
    var id_category: Int?
    var cartObj : Cart = Cart()
    var listSearchArray: [Address] = []
    var returnFromMatching = false
    var error_codeFromMatching : Int?
    var id_Request: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        if defaults.object(forKey: "third") == nil{
            defaults.setValue("third", forKey: "third")
            if DeviceType.IS_IPHONE_5
            {
                showTutorial(self, imageName: MCLocalization.string(forKey: "IMAGEDEMO3_IP5"))
            }
            else if DeviceType.IS_IPHONE_6
            {
                showTutorial(self, imageName: MCLocalization.string(forKey: "IMAGEDEMO3_IP6"))
            }
            else if DeviceType.IS_IPHONE_6P
            {
                showTutorial(self, imageName: MCLocalization.string(forKey: "IMAGEDEMO3"))
            }
            
        }
        
        self.tblView.isScrollEnabled = true
        searchBar.delegate = self
        self.txtPickupLocation.textColor = UIColor(hex:colorXam)
        self.tblSearchLocation.isHidden = true
        viewWhenSearchLocation.isHidden = true
        viewClose.isHidden = true
        let gesture1 = UITapGestureRecognizer(target: self, action: #selector(self.closeInputData))
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(self.closeInputData))
        self.viewWhenSearchLocation.addGestureRecognizer(gesture1)
        self.viewClose.addGestureRecognizer(gesture2)
        txtPickupLocation.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        getArraySearchString()
        let currentTime = Time()
        currentTime.year = Calendar.current.component(.year, from: Date())
        currentTime.month = Calendar.current.component(.month, from: Date())
        currentTime.day = Calendar.current.component(.day, from: Date())
        currentTime.minute = Calendar.current.component(.minute, from: Date())
        currentTime.hour = Calendar.current.component(.hour, from: Date())
        self.lblTime_Date_Delivery.text = self.setCurrentDayString(date: currentTime, needSet60Phut: true)
        
        txtNote.useUnderline()
        txtRecieptname.useUnderline()
        txtRecipentPhone.useUnderline()
    }

    override func viewWillAppear(_ animated: Bool) {
        btnConfirm.isEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        makeTopNavigationSearchbar(isMenuScreen: false, isCartScreen: true,needShake: false)
        let viewWhiteFirst = UIView(frame: CGRect(x: 0, y: 64, width: ScreenSize.SCREEN_WIDTH, height: ScreenSize.SCREEN_HEIGHT - 64))
        viewWhiteFirst.backgroundColor = UIColor.white
        self.view.addSubview(viewWhiteFirst)
        DataConnect.getCart(token_API, country_code: kCountryCode, phone: userPhone_API,view: self.view,  onsuccess: { (result) in
            viewWhiteFirst.isHidden = true
            self.btnConfirm.isEnabled = true
            self.cartObj = (result as! Cart)
            self.inputDataFromServer(cart: self.cartObj)
        }) { (error) in
            viewWhiteFirst.isHidden = true
            showErrorMessage(error: error as! Int, vc: self)
        }
        
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
                self.timeDelivery = Time()
                self.btnComfirm(nil)
                
            }, blockCallbackCancel: {result in
                self.returnFromMatching = false
                self.lblTime_Date_Delivery.text = self.setCurrentDayString(date: self.timeDelivery, needSet60Phut: true)
                self.btnComfirm(nil)
            },blockCallbackClose: { result in
                self.timeDelivery = Time()
                self.returnFromMatching = false
            })
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    // MARK: Function
    func blockCallBackFromSmartFoxGifting(order_ID : Int)
    {
        if SmartFoxObject.sharedInstance.smartFox.isConnected
        {
            let param = SFSObject.newInstance()
            param?.putUtfString("command", value: kCmdRequestShipper)
            param?.putUtfString("type", value: "GIFTING")
            param?.putInt("minute", value: timeDelivery.minute)
            param?.putInt("hour", value: timeDelivery.hour)
            param?.putInt("day", value:timeDelivery.day)
            param?.putInt("month", value:timeDelivery.month)
            param?.putInt("year", value: timeDelivery.year)
            param?.putBool("return_to_pickup", value: false)
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
            else if type == kCmdLoginSuccess2ND
            {
                let param = SFSObject.newInstance()
                param?.putUtfString("command", value: kCmdRequestShipper)
                param?.putUtfString("type", value: "GIFTING")
                param?.putInt("minute", value: self.timeDelivery.minute)
                param?.putInt("hour", value: self.timeDelivery.hour)
                param?.putInt("day", value:self.timeDelivery.day)
                param?.putInt("month", value:self.timeDelivery.month)
                param?.putInt("year", value: self.timeDelivery.year)
                param?.putBool("return_to_pickup", value: false)
                param?.putInt("online_payment_order_id", value: order_ID)
                param?.putUtfString("id_request", value: self.id_Request)
                SmartFoxObject.sharedInstance.sendExtendsionRequest(kExtCmd, param: param, isNeedShowLoading: true)
                
            }
            else if type == kCmdDisconnect
            {
                //                customAlertView(self, title: MCLocalization.string(forKey: "DISCONNECT"), btnTitleNameNormal: name_confirm_Button_Normal,titleButton: MCLocalization.string(forKey: "CONFIRM"),blockCallback:
                //                    {
                //                        result in
                //                })
            }
//            else if type == kCmdSendIDRequest
//            {
//                self.id_Request = result as? String
//                
//            }
            else if type == kCmdChangeRequestScreen
            {
                let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "MatchingShipperViewController") as! MatchingShipperViewController
                vc.flagisPickupOrGifting =  true
                vc.sender.timeSender = self.timeDelivery
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
                if data?.is_follow_journey == false {
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
                        self.timeDelivery.day = Calendar.current.component(.day, from: date! as Date)
                        self.timeDelivery.month = Calendar.current.component(.month, from: date! as Date)
                        self.timeDelivery.year = Calendar.current.component(.year, from: date! as Date)
                        self.timeDelivery.minute = Calendar.current.component(.minute, from: date! as Date)
                        self.timeDelivery.hour = Calendar.current.component(.hour, from: date! as Date)
                        self.lblTime_Date_Delivery.text =  self.setCurrentDayString(date: self.timeDelivery, needSet60Phut: false)
                        
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
                        self.present(nav, animated: true, completion: nil)
                    }
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
            if timeDelivery.day != 0 &&  timeDelivery.month != 0 && timeDelivery.year != 0
            {
                blockCallBackFromSmartFoxGifting(order_ID: order_ID)
            }
            else
            {
                let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "MatchingShipperViewController") as! MatchingShipperViewController
                vc.flagisPickupOrGifting =  true
                vc.sender.timeSender = timeDelivery
                vc.online_payment_order_id =  order_ID
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
    
    func inputDataFromServer(cart: Cart)
    {
        if cart.product.count == 0
        {
            self.dismiss(animated: true, completion: nil)
            return
        }
        lblItemCost.text = String(format: "%@đ", cart.item_cost!.stringFormattedWithSeparator)
        lblServiceFee.text =   String(format: "%@đ", cart.service_fee!.stringFormattedWithSeparator)
        lblShippingFee.text =  String(format: "%@đ", cart.shipping_fee!.stringFormattedWithSeparator)
        lblTotal.text =   String(format: "%@đ", cart.total!.stringFormattedWithSeparator)
        txtRecieptname.text = cart.recipent_name
        txtRecipentPhone.text = cart.recipent_phone
        txtNote.text = cart.recipent_note
        if cart.locations.count != 0
        {
            txtPickupLocation.text = cart.locations[0].address
        }
        
        if cart.payment_type == "CASH"
        {
            btnPaymentMethod(btnCash)
        }
        else if cart.payment_type == "ONLINE"
        {
            btnPaymentMethod(btnOnline)
        }
        else
        {
            btnPaymentMethod(btnViAround)
        }
        if cart.product.count >= 0
        {
            self.tableViewHeightConstraint?.constant = CGFloat((cart.product.count) * 100)
        }
        self.tblView.reloadData()
    }
    func keyboardWillShow(notification: NSNotification) {
        //        self.txtPickupLocation.text = ""
        
        //        self.viewWhenSearchLocation.backgroundColor = UIColor.black
        //        self.viewWhenSearchLocation.layer.opacity = 0.4
        //        self.mainScrollView.setContentOffset(CGPoint(x: 0 , y:CGFloat(cartObj.product.count * 100 ) + self.viewNguoiNhan.frame.height), animated: true)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.viewWhenSearchLocation.backgroundColor = UIColor.clear
        self.viewWhenSearchLocation.layer.opacity = 1
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
                
                let dateBackFromMatching = String(format: "%02d-%02d-%02d %02d:%02d", timeDelivery.year,timeDelivery.month,timeDelivery.day,timeDelivery.hour,timeDelivery.minute).toDateTime(dateFormatStr: "yyyy-MM-dd HH:mm") as Date
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
    
    
    
    
    func getArraySearchString()
    {
        let listLocation = defaults.value(forKey: "locations") as! [String]
        for item in listLocation
        {
            let dict = try!JSONSerialization.jsonObject(with: item.data(using: .utf8)!, options: .allowFragments) as! NSDictionary
            let obj = Address().parseDataFromDictionary(dict)
            listSearchArray.append(obj)
        }
    }
    func closeInputData()
    {
        if cartObj.locations.count >= 1
        {
            txtPickupLocation.text = cartObj.locations[0].address
        }
        
        self.tblSearchLocation.isHidden = true
        viewWhenSearchLocation.isHidden = true
        viewClose.isHidden = true
        self.view.endEditing(true)
    }
    
    
    func textFieldDidChange(_ textField: UITextField) {
        if textField.text?.length == 0
        {
            self.tblSearchLocation.isHidden = true
        }
        else
        {
            self.tblSearchLocation.isHidden = false
        }
        
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        filter.country = "VN"
        let lat = 10.779784
        let long = 106.698995
        let offset = 200.0 / 1000.0;
        let latMax = lat + offset;
        let latMin = lat - offset;
        let lngOffset = offset * cos(lat * Double.pi / 200.0);
        let lngMax = long + lngOffset;
        let lngMin = long - lngOffset;
        let initialLocation = CLLocationCoordinate2D(latitude: latMax, longitude: lngMax)
        let otherLocation = CLLocationCoordinate2D(latitude: latMin, longitude: lngMin)
        let bounds = GMSCoordinateBounds(coordinate: initialLocation, coordinate: otherLocation)
        placeClient.autocompleteQuery(textField.text!, bounds: bounds, filter: filter) { (results) -> Void in
            if results.0 == nil {
                return
            }
            self.resultsArray.removeAll()
            for result in results.0! {
                let objAddress = Address()
                objAddress.name = result.attributedPrimaryText.string
                objAddress.street = result.attributedSecondaryText!.string
                objAddress.fullAddress = result.attributedFullText.string
                objAddress.placeID = result.placeID!
                self.resultsArray.append(objAddress)
                
            }
            for item in self.listSearchArray
            {
                let str = item.name + " " +  item.fullAddress
                if (str.range(of: textField.text!, options: NSString.CompareOptions.caseInsensitive, range: nil, locale: nil) != nil)
                {
                    self.resultsArray.insert(item, at: 0)
                }
                
            }
            self.tblSearchLocation.reloadData()
        }
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
            let paymentInfo = PaymentObject()
            paymentInfo.payment_type = "ONLINE"
            DataConnect.updatePayment(paymentInfo, numberPhone: userPhone_API, country_code: kCountryCode, token: token_API,view: self.view,  onsuccess: { (result) in
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
            
            
            let paymentInfo = PaymentObject()
            paymentInfo.payment_type = "AROUND_PAY"
            DataConnect.updatePayment(paymentInfo, numberPhone: userPhone_API, country_code: kCountryCode, token: token_API,view: self.view,  onsuccess: { (result) in
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
            let paymentInfo = PaymentObject()
            paymentInfo.payment_type = "CASH"
            DataConnect.updatePayment(paymentInfo, numberPhone: userPhone_API, country_code: kCountryCode, token: token_API,view: self.view,  onsuccess: { (result) in
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
    func add(sender: UIButton!)
    {
        let value = sender.tag;
        let pro = cartObj.product[value]
        DataConnect.addItemToCart(token_API, country_code: kCountryCode, phone: userPhone_API, id_product: pro.id!, attributes: "" ,view: self.view,  onsuccess: { (result) in
            self.makeTopNavigationSearchbar(isMenuScreen: false, isCartScreen: true,needShake: true)
            DataConnect.getCart(token_API, country_code: kCountryCode, phone: userPhone_API,view: self.view,  onsuccess: { (result) in
                self.cartObj = (result as! Cart)
                self.inputDataFromServer(cart: self.cartObj)
                self.tblView.reloadData()
            }) { (error) in
                showErrorMessage(error: error as! Int, vc: self)
            }
            
        }, onFailure: { (error) in
            showErrorMessage(error: error as! Int, vc: self)
        })
        
    }
    
    func minus(sender: UIButton!)
    {
        if self.cartObj.product.count == 1
        {
            if cartObj.product.first?.number == 1
            {
                customAlertViewWithCancelButton(self, title: MCLocalization.string(forKey: "THOATGIOHANG"), btnTitleNameNormal: name_confirm_Button_Normal,  btnCancelNameNormal: name_cancel_Button_Normal,titleOrangeButton: MCLocalization.string(forKey: "CONFIRM"), titleGreyButton: MCLocalization.string(forKey: "CANCEL"), isClose: false,  blockCallback: {result in
                    let value = sender.tag;
                    let pro = self.cartObj.product[value]
                    DataConnect.removeProductToCard(token_API, country_code: kCountryCode, phone: userPhone_API, id_product: pro.id!,view: self.view,  onsuccess: { (result) in
                        self.makeTopNavigationSearchbar(isMenuScreen: false, isCartScreen: true,needShake: true)
                        DataConnect.getCart(token_API, country_code: kCountryCode, phone: userPhone_API, view: self.view, onsuccess: { (result) in
                            self.cartObj = (result as! Cart)
                            
                            appDelegate.listSelected.removeAll()
                            for item in self.cartObj.product
                            {
                                appDelegate.listSelected.append(item.id!)
                            }
                            self.inputDataFromServer(cart: self.cartObj)
                            self.tblView.reloadData()
                            if self.cartObj.product.count == 0
                            {
                                self.dismiss()
                            }
                        }) { (error) in
                            showErrorMessage(error: error as! Int, vc: self)
                        }
                        
                    }, onFailure: { (error) in
                        
                        showErrorMessage(error: error as! Int, vc: self)
                    })
                },
                                                blockCallbackCancel: {result in
                                                    
                })
                
                return
            }
            
        }
        let value = sender.tag;
        let pro = cartObj.product[value]
        DataConnect.removeProductToCard(token_API, country_code: kCountryCode, phone: userPhone_API, id_product: pro.id!,view: self.view,  onsuccess: { (result) in
            self.makeTopNavigationSearchbar(isMenuScreen: false, isCartScreen: true,needShake: true)
            DataConnect.getCart(token_API, country_code: kCountryCode, phone: userPhone_API, view: self.view, onsuccess: { (result) in
                self.cartObj = (result as! Cart)
                
                appDelegate.listSelected.removeAll()
                for item in self.cartObj.product
                {
                    appDelegate.listSelected.append(item.id!)
                }
                self.inputDataFromServer(cart: self.cartObj)
                self.tblView.reloadData()
                if self.cartObj.product.count == 0
                {
                    self.dismiss()
                }
            }) { (error) in
                showErrorMessage(error: error as! Int, vc: self)
            }
            
        }, onFailure: { (error) in
            
            showErrorMessage(error: error as! Int, vc: self)
        })
        
    }
    // MARK: IBACTION
    @IBAction func btnGiftProduct(_ sender: UIButton) {
        
        DataConnect.updateDeliveryInfo(token_API, country_code: kCountryCode, phone: userPhone_API, recipent_name: txtRecieptname.text!, recipent_phone: txtRecipentPhone.text!, recipent_note: txtNote.text!, onsuccess: { (result) in
            
            if self.cartObj.product[sender.tag].is_gift == 1
            {
                
                DataConnect.updateGiftProduct(token_API, country_code: kCountryCode, phone: userPhone_API, id_product: self.cartObj.product[sender.tag].id!, status: 0, view: self.view, onsuccess: { (result) in
                    DataConnect.getCart(token_API, country_code: kCountryCode, phone: userPhone_API, view: self.view, onsuccess: { (result) in
                        self.cartObj = (result as! Cart)
                        self.inputDataFromServer(cart: self.cartObj)
                        self.tblView.reloadData()
                    }) { (error) in
                        showErrorMessage(error: error as! Int, vc: self)
                    }
                    
                }, onFailure: { (error) in
                    showErrorMessage(error: error as! Int, vc: self)
                })
            }
            else
            {
                
                DataConnect.updateGiftProduct(token_API, country_code: kCountryCode, phone: userPhone_API, id_product: self.cartObj.product[sender.tag].id!, status: 1, view: self.view, onsuccess: { (result) in
                    DataConnect.getCart(token_API, country_code: kCountryCode, phone: userPhone_API, view: self.view, onsuccess: { (result) in
                        self.cartObj = (result as! Cart)
                        self.inputDataFromServer(cart: self.cartObj)
                        self.tblView.reloadData()
                    }) { (error) in
                        showErrorMessage(error: error as! Int, vc: self)
                    }
                }, onFailure: { (error) in
                    showErrorMessage(error: error as! Int, vc: self)
                })
            }
            
        }) { (error) in
            
        }
        
        
    }
    @IBAction func btnGiftCart(_ sender: UIButton) {
        tracking(actionKey: "C15.3Y")
        DataConnect.updateDeliveryInfo(token_API, country_code: kCountryCode, phone: userPhone_API, recipent_name: txtRecieptname.text!, recipent_phone: txtRecipentPhone.text!, recipent_note: txtNote.text!, onsuccess: { (result) in
            if self.cartObj.is_gift == 1
            {
                
                DataConnect.updateGiftCart(token_API, country_code: kCountryCode, phone: userPhone_API, status: 0, view: self.view, onsuccess: { (result) in
                    DataConnect.getCart(token_API, country_code: kCountryCode, phone: userPhone_API, view: self.view, onsuccess: { (result) in
                        self.cartObj = (result as! Cart)
                        self.inputDataFromServer(cart: self.cartObj)
                        self.tblView.reloadData()
                    }) { (error) in
                        showErrorMessage(error: error as! Int, vc: self)
                    }
                }, onFailure: { (error) in
                    showErrorMessage(error: error as! Int, vc: self)
                })
            }
            else
            {
                
                DataConnect.updateGiftCart(token_API, country_code: kCountryCode, phone: userPhone_API, status: 1, view: self.view, onsuccess: { (result) in
                    DataConnect.getCart(token_API, country_code: kCountryCode, phone: userPhone_API, view: self.view, onsuccess: { (result) in
                        self.cartObj = (result as! Cart)
                        self.inputDataFromServer(cart: self.cartObj)
                        self.tblView.reloadData()
                        
                    }) { (error) in
                        showErrorMessage(error: error as! Int, vc: self)
                    }
                }, onFailure: { (error) in
                    showErrorMessage(error: error as! Int, vc: self)
                })
                
            }
        }) { (error) in
            
        }
        
        
        
        
        
    }
    
    @IBAction func selectRadioButton(_ sender: UIButton) {
        if sender.tag == 1
        {
            // btnCash.isSelected = true
            //  btnOnline.isSelected = false
            
            let paymentInfo = PaymentObject()
            paymentInfo.payment_type = "CASH"
            DataConnect.updatePayment(paymentInfo, numberPhone: userPhone_API, country_code: kCountryCode, token: token_API,view: self.view,  onsuccess: { (result) in
            }, onFailure: { error in
                showErrorMessage(error: error as! Int, vc: self)
                
                
            })
            
        }
        else if sender.tag == 2
        {
            //  btnOnline.isSelected = true
            // btnCash.isSelected = false
            
            let paymentInfo = PaymentObject()
            paymentInfo.payment_type = "ONLINE"
            DataConnect.updatePayment(paymentInfo, numberPhone: userPhone_API, country_code: kCountryCode, token: token_API,view: self.view,  onsuccess: { (result) in
            }, onFailure: { error in
                showErrorMessage(error: error as! Int, vc: self)
                
                
            })
            
        }
    }
    
    @IBAction func btnSetdeliveryTime(_ sender: AnyObject?){
        showCalendar(dateChoose:timeDelivery, blockCallback: { (result) in
            self.timeDelivery = result as! Time
            if self.timeDelivery.day == 0
            {
                let currentTime = Time()
                currentTime.year = Calendar.current.component(.year, from: Date())
                currentTime.month = Calendar.current.component(.month, from: Date())
                currentTime.day = Calendar.current.component(.day, from: Date())
                currentTime.minute = Calendar.current.component(.minute, from: Date())
                currentTime.hour = Calendar.current.component(.hour, from: Date())
                self.lblTime_Date_Delivery.text = self.setCurrentDayString(date: currentTime, needSet60Phut: true)
            }
            else
            {
                self.lblTime_Date_Delivery.text = self.setCurrentDayString(date: self.timeDelivery, needSet60Phut: false)
            }
            
        })
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
            myAlert.imageURL = Config.sharedInstance.imagePrice_ServiceGiftingTA
        }
        else{
            myAlert.imageURL = Config.sharedInstance.imagePrice_ServiceGiftingTV
        }
        myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(myAlert, animated: false, completion: nil)
    }
    @IBAction func btnComfirm(_ sender: UIButton?) {
        tracking(actionKey: "C15.5Y")
        
        if (txtRecipentPhone.text?.length)! > 0
        {
            if txtRecipentPhone.text!.removingWhitespaces().replacingOccurrences(of: "+", with: "").isNumber == false || (txtRecipentPhone.text?.removingWhitespaces().length)! < 10
            {
                
                self.mainScrollView.setContentOffset(CGPoint(x: 0 , y:CGFloat(cartObj.product.count * 100 )), animated: true)
                txtRecipentPhone.insertImageRight(image: UIImage(named: "icon-loi")!, size : CGSize(width: 15, height: 15))
                txtRecipentPhone.shake()
                return
            }
        }
        

        
        if connectedToNetwork() == false{
            customAlertView(self, title: MCLocalization.string(forKey: "FINDINGWHENDIS"), btnTitleNameNormal: name_confirm_Button_Normal,titleButton: MCLocalization.string(forKey: "CONFIRM"),blockCallback: {result in
            })
        }
        else
        {
            if self.txtPickupLocation.text == ""
            {
                self.mainScrollView.setContentOffset(CGPoint(x: 0 , y:CGFloat(cartObj.product.count * 100 )), animated: true)
                self.txtPickupLocation.attributedPlaceholder = NSAttributedString(string: MCLocalization.string(forKey: "INPUTDROPPLACE"),
                                                                                  attributes: [NSForegroundColorAttributeName: UIColor.red])
                self.txtPickupLocation.shake()
                return
            }
            
            if self.timeDelivery.day != 0 &&  self.timeDelivery.month != 0 && self.timeDelivery.year != 0
            {
                let dateDelivery = String(format: "%02d-%02d-%02d %02d:%02d", self.timeDelivery.year,self.timeDelivery.month,self.timeDelivery.day,self.timeDelivery.hour,self.timeDelivery.minute).toDateTime(dateFormatStr: "yyyy-MM-dd HH:mm")
                let now = Date()
                let minuteBetween2Time = dateDelivery.timeIntervalSince(now)
                if minuteBetween2Time/60 < Double(Config.sharedInstance.set_schedule_control_time! - 2)
                {
                    customAlertView(self, title: MCLocalization.string(forKey: "LIMITTIME"), btnTitleNameNormal: name_confirm_Button_Normal,titleButton: MCLocalization.string(forKey: "CONFIRM"),blockCallback: {result in
                        
                    })
                    return
                }
            }
            DataConnect.updateDeliveryInfo(token_API, country_code: kCountryCode, phone: userPhone_API, recipent_name: txtRecieptname.text!, recipent_phone: txtRecipentPhone.text!, recipent_note: txtNote.text!, onsuccess: { (result) in
                DataConnect.getRequestOrderID(token_API, country_code: kCountryCode, phone: userPhone_API, view: self.view, onsuccess: { (result) in
                    self.id_Request = result as? String
                    self.blockCallBackFromSmartFoxGifting(order_ID: 0)
                }, onFailure: { (error) in
                })
            }) { (error) in
                
            }
            

            
            
        }
        
    }
    
    @IBAction func btnBuyMore(_ sender: UIButton) {
        tracking(actionKey: "C15.6Y")
        self.dismiss()
    }
    
    func dismiss()
    {
        if self.cartObj.product.count == 0
        {
            self.dismiss(animated: true, completion: nil)
        }
        else
        {
            DataConnect.updateDeliveryInfo(token_API, country_code: kCountryCode, phone: userPhone_API, recipent_name: txtRecieptname.text!, recipent_phone: txtRecipentPhone.text!, recipent_note: txtNote.text!, onsuccess: { (result) in
                self.dismiss(animated: true, completion: nil)
            }) { (error) in
                
            }
            
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


extension CartViewController:UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        viewClose.isHidden = true
        viewWhenSearchLocation.isHidden = true
        if textField == txtPickupLocation
        {
            textField.text = ""
            self.viewWhenSearchLocation.isHidden = false
            self.viewWhenSearchLocation.backgroundColor = UIColor.black
            self.viewWhenSearchLocation.layer.opacity = 0.4
            self.mainScrollView.setContentOffset(CGPoint(x: 0 , y:CGFloat(cartObj.product.count * 100 ) + self.viewNguoiNhan.frame.height), animated: true)
        }
        else if textField == txtRecieptname || textField == txtRecipentPhone || textField == txtNote
        {
            self.viewClose.isHidden = false
            self.mainScrollView.setContentOffset(CGPoint(x: 0 , y:CGFloat(cartObj.product.count * 100 )), animated: true)
        }
        else{
            self.viewClose.isHidden = false
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblView{
            return cartObj.product.count
        }
        else
        {
            return resultsArray.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblView
        {
            return 100
        }
        else
        {
            return 50
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblView
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartCategoryCell") as! CartCategoryCell
            let pro = cartObj.product[indexPath.row]
            if let url = URL(string: (pro.image!)),let placeholder = UIImage(named: "default_product") {
                cell.imageAvatar.sd_setImageWithURLWithFade(url, placeholderImage: placeholder)
            }
            cell.btnGiftProduct.tag = indexPath.row
            cell.lblNumber.text = String(format: "%d", pro.number!)
            cell.lblProductName.text = pro.name
            cell.lblPrice.text = pro.price!.stringFormattedWithSeparator + "đ"
            cell.lblAddress.text = pro.shop_address
            cell.lblShopName.text = pro.shop_name
            cell.btnAdd.tag = indexPath.row
            cell.btnMinus.tag = indexPath.row
            cell.btnAdd.addTarget(self, action: #selector(self.add(sender:)), for: .touchUpInside)
            cell.btnMinus.addTarget(self, action: #selector(self.minus(sender:)), for: .touchUpInside)
            
            
            if pro.is_gift == 0
            {
                cell.imageGift.image = UIImage(named: "gift_cart_xam")
                cell.lblGift.textColor = UIColor(hex: colorXam)
                cell.lblGift.text = MCLocalization.string(forKey: "GOIQUA")
            }
            else
            {
                cell.imageGift.image = UIImage(named: "gift_cart_cam")
                cell.lblGift.textColor = UIColor(hex: colorCam)
                cell.lblGift.text = MCLocalization.string(forKey: "GOIQUA") + Config.sharedInstance.giftbox_fee!
            }
            return cell
        }
        else
        {
            let cell = self.tblSearchLocation.dequeueReusableCell(withIdentifier: "deliveryCell") as! DeliveryTableViewCell
            cell.lblTitle.text = self.resultsArray[(indexPath as NSIndexPath).row].name
            cell.lbldetail.text = self.resultsArray[(indexPath as NSIndexPath).row].street
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView == tblView
        {
           return true
        }
        else
        {
            return false
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblSearchLocation{
            
            DataConnect.updateDeliveryInfo(token_API, country_code: kCountryCode, phone: userPhone_API, recipent_name: txtRecieptname.text!, recipent_phone: txtRecipentPhone.text!, recipent_note: txtNote.text!, onsuccess: { (result) in
                self.closeInputData()
                showProgressHub()
                self.txtPickupLocation.resignFirstResponder()
                self.txtPickupLocation.text = self.resultsArray[(indexPath as NSIndexPath).row].fullAddress
                self.placeClient.lookUpPlaceID(self.resultsArray[(indexPath as NSIndexPath).row].placeID, callback: { (place, err) -> Void in
                    if let error = err {
                        print("lookup place id query error: \(error.localizedDescription)")
                        return
                    }
                    if let place = place {
                        let placeGifting = GiftingLocation(longitude: place.coordinate.longitude, latitude: place.coordinate.latitude, address: self.resultsArray[(indexPath as NSIndexPath).row].fullAddress , placeid: self.resultsArray[(indexPath as NSIndexPath).row].placeID)
                        if self.cartObj.locations.count == 0
                        {
                            self.cartObj.locations.append(placeGifting)
                        }
                        else
                        {
                            self.cartObj.locations[0] = placeGifting
                        }
                        
                        let json = parseOjbectToListJson(list: self.cartObj.locations)
                        DataConnect.pickGifting(token_API, country_code: kCountryCode, phone: userPhone_API, locations: json,view: self.view,  onsuccess: { (result) in
                            DataConnect.getCart(token_API, country_code: kCountryCode, phone: userPhone_API, view: self.view, onsuccess: { (result) in
                                self.cartObj = (result as! Cart)
                                self.inputDataFromServer(cart: self.cartObj)
                                self.tblView.reloadData()
                                
                            }) { (error) in
                                showErrorMessage(error: error as! Int, vc: self)
                            }
                        }, onFailure: { (error) in
                            showErrorMessage(error: error as! Int, vc: self)
                        })
                        
                        
                    }
                    
                })
            }) { (error) in
                self.closeInputData()
                showProgressHub()
                self.txtPickupLocation.resignFirstResponder()
                self.txtPickupLocation.text = self.resultsArray[(indexPath as NSIndexPath).row].fullAddress
                self.placeClient.lookUpPlaceID(self.resultsArray[(indexPath as NSIndexPath).row].placeID, callback: { (place, err) -> Void in
                    if let error = err {
                        print("lookup place id query error: \(error.localizedDescription)")
                        return
                    }
                    if let place = place {
                        let placeGifting = GiftingLocation(longitude: place.coordinate.longitude, latitude: place.coordinate.latitude, address: self.resultsArray[(indexPath as NSIndexPath).row].fullAddress , placeid: self.resultsArray[(indexPath as NSIndexPath).row].placeID)
                        if self.cartObj.locations.count == 0
                        {
                            self.cartObj.locations.append(placeGifting)
                        }
                        else
                        {
                            self.cartObj.locations[0] = placeGifting
                        }
                        
                        let json = parseOjbectToListJson(list: self.cartObj.locations)
                        DataConnect.pickGifting(token_API, country_code: kCountryCode, phone: userPhone_API, locations: json,view: self.view,  onsuccess: { (result) in
                            DataConnect.getCart(token_API, country_code: kCountryCode, phone: userPhone_API, view: self.view, onsuccess: { (result) in
                                self.cartObj = (result as! Cart)
                                self.inputDataFromServer(cart: self.cartObj)
                                self.tblView.reloadData()
                                
                            }) { (error) in
                                showErrorMessage(error: error as! Int, vc: self)
                            }
                        }, onFailure: { (error) in
                            showErrorMessage(error: error as! Int, vc: self)
                        })
                        
                        
                    }
                    
                })
            }
            
            
        }
        else
        {
            DataConnect.updateDeliveryInfo(token_API, country_code: kCountryCode, phone: userPhone_API, recipent_name: txtRecieptname.text!, recipent_phone: txtRecipentPhone.text!, recipent_note: txtNote.text!, onsuccess: { (result) in
                let vc = giftingStoryBoard.instantiateViewController(withIdentifier: "DetailViewProductViewController") as! DetailViewProductViewController
                vc.product_ID = self.cartObj.product[indexPath.row].id
                vc.kindOfProduct = self.cartObj.product[indexPath.row].name
                self.navigationController?.pushViewController(vc, animated: true)
            }) { (error) in
                let vc = giftingStoryBoard.instantiateViewController(withIdentifier: "DetailViewProductViewController") as! DetailViewProductViewController
                vc.product_ID = self.cartObj.product[indexPath.row].id
                vc.kindOfProduct = self.cartObj.product[indexPath.row].name
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
        }
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return MCLocalization.string(forKey: "DELETE")
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            if self.cartObj.product.count == 1
            {
                customAlertViewWithCancelButton(self, title: MCLocalization.string(forKey: "THOATGIOHANG"), btnTitleNameNormal: name_confirm_Button_Normal,  btnCancelNameNormal: name_cancel_Button_Normal,titleOrangeButton: MCLocalization.string(forKey: "CONFIRM"), titleGreyButton: MCLocalization.string(forKey: "CANCEL"), isClose: false,  blockCallback: {result in
                    let pro = self.cartObj.product[indexPath.row]
                    DataConnect.clearProduct(token_API, country_code: kCountryCode, phone: userPhone_API, id_product: pro.id!,view: self.view,  onsuccess: { (result) in
                        self.makeTopNavigationSearchbar(isMenuScreen: false, isCartScreen: true,needShake: true)
                        self.cartObj.product.remove(at: indexPath.row)
                        if let index = appDelegate.listSelected.index(of:pro.id!) {
                            appDelegate.listSelected.remove(at: index)
                        }
                        DataConnect.getCart(token_API, country_code: kCountryCode, phone: userPhone_API,view: self.view, onsuccess: { (result) in
                            self.cartObj = (result as! Cart)
                            self.inputDataFromServer(cart: self.cartObj)
                            self.tblView.reloadData()
                            if self.cartObj.product.count == 0
                            {
                                self.dismiss()
                            }
                        }) { (error) in
                            showErrorMessage(error: error as! Int, vc: self)
                        }
                        
                    }, onFailure: { (error) in
                        showErrorMessage(error: error as! Int, vc: self)
                    })
                },
                                                
                                                blockCallbackCancel: {result in
                                                    
                })
                
                return
                
                
            }
            
            
            let pro = cartObj.product[indexPath.row]
            DataConnect.clearProduct(token_API, country_code: kCountryCode, phone: userPhone_API, id_product: pro.id!,view: self.view,  onsuccess: { (result) in
                self.makeTopNavigationSearchbar(isMenuScreen: false, isCartScreen: true,needShake: true)
                self.cartObj.product.remove(at: indexPath.row)
                if let index = appDelegate.listSelected.index(of:pro.id!) {
                    appDelegate.listSelected.remove(at: index)
                }
                DataConnect.getCart(token_API, country_code: kCountryCode, phone: userPhone_API,view: self.view, onsuccess: { (result) in
                    self.cartObj = (result as! Cart)
                    self.inputDataFromServer(cart: self.cartObj)
                    self.tblView.reloadData()
                    if self.cartObj.product.count == 0
                    {
                        self.dismiss()
                    }
                }) { (error) in
                    showErrorMessage(error: error as! Int, vc: self)
                }
                
            }, onFailure: { (error) in
                showErrorMessage(error: error as! Int, vc: self)
            })
        }
        
    }
    
}


class CartCategoryCell: UITableViewCell
{
    @IBOutlet weak var lblShopName: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var btnGiftProduct: UIButton!
    @IBOutlet weak var imageGift: UIImageView!
    @IBOutlet weak var lblGift: UILabel!
}


