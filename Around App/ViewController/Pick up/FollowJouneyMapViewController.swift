//
//  ViewController.swift
//  Shipper
//
//  Created by phuc.huynh on 8/18/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import UIKit
import GoogleMaps

class FollowJouneyMapViewController: StatusbarViewController,CLLocationManagerDelegate,ISFSEvents,SWRevealViewControllerDelegate,GMSMapViewDelegate,ARCarMovementDelegate {
    @IBOutlet var googleMapsView:GMSMapView!
    @IBOutlet weak var defNav: DefaultNavigation!
    @IBOutlet weak var viewWhenTapMenu: UIView!
    @IBOutlet weak var messengerBtn: MIBadgeButton!
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var lblNameShipper: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var contrainsTopBar: NSLayoutConstraint!
    @IBOutlet weak var contrainsBottom: NSLayoutConstraint!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var constrainHeight: NSLayoutConstraint!
    @IBOutlet weak var constrainWidth: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var btnNewOrder: UIButton!
    @IBOutlet weak var lblFullOrder: UILabel!
    @IBOutlet weak var lblCallShipper: UILabel!
    @IBOutlet weak var lblChatWithShipper: UILabel!
    @IBOutlet weak var lblDeliveryin: UILabel!
    @IBOutlet weak var navItem: UINavigationItem!
    var locationA = CLLocationCoordinate2D()
    var locationB = CLLocationCoordinate2D()
    var indexCountDrawRouter = 0
    var flagHideNavigationBar = false
    var order_id : Int?
    var listPoint:[PointLocation] = []
    var markerShipper = GMSMarker()
    var senderShipper : ShipperInfoObject!
    var locationManager = CLLocationManager()
    var flagFromSlideMenu = false
    var isFirst = false
    var listDrawBikeCoordinate:[CLLocationCoordinate2D] = []
    var totalNumberChat  = 0
    let moveMent = ARCarMovement()
    var flagChangeView = false
    var flagFirstBikeMove = false
    var flagReconectSocketFromBackground = false
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    func setLocalize()
    {
        lblFullOrder.text = MCLocalization.string(forKey: "FULLORDER")
        lblCallShipper.text = MCLocalization.string(forKey: "CALLSHIPPER")
        lblChatWithShipper.text = MCLocalization.string(forKey: "CHATWITHSHIPPER")
        btnNewOrder.setTitle(MCLocalization.string(forKey: "NEWORDER"), for: .normal)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        moveMent.delegate = self
        if flagFromSlideMenu == true
        {
            self.defNav.topItem?.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back x2"), style: .plain, target: self, action:  #selector(self.backAction))
            self.defNav.topItem?.leftBarButtonItem?.tintColor = UIColor.white
        }
        else
        {
            DataConnect.getOrderNumber(token_API, country_code: kCountryCode, phone: userPhone_API, onsuccess: { (result) in
                let numberLeftMenu = result as? NumberLeftMenu
                let total = (numberLeftMenu?.number_event)! + (numberLeftMenu?.number_order)! + (numberLeftMenu?.number_notification)!
                if total == 0
                {
                    self.defNav.topItem?.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
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
                
            }
            self.revealViewController().delegate = self
            viewWhenTapMenu.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            
        }
        self.blockCallBackFromSmartFox()
        viewWhenTapMenu.isHidden = true
        
        googleMapsView.delegate = self
        
        
        
        loadDataByGCD(url: URL(string: (self.senderShipper.shipper_avatar)!)!, onsuccess: { (result) in
            if result != nil
            {
                appDelegate.imageShipper = UIImage(data: result as! Data)?.circleMasked
                self.imageAvatar.image = UIImage(data: result as! Data)?.circleMasked
                self.imageAvatar.setShadowBorder()
            }
            else
            {
                self.imageAvatar.image = UIImage(named: "avatar_Background")
                appDelegate.imageShipper = UIImage(named: "avatar_Background")
            }
            
        })
        
        
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if DeviceType.IS_IPHONE_6P
        {
            constrainHeight.constant = 120
            constrainWidth.constant = 120
            
        }
        else if DeviceType.IS_IPHONE_6
        {
            constrainHeight.constant = 105
            constrainWidth.constant = 105
            
        }
        else if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS
        {
            constrainHeight.constant = 90
            constrainWidth.constant = 90
            
        }
        self.view.layoutIfNeeded()
        
        containerView.backgroundColor = UIColor.clear
        self.messengerBtn.badgeTextColor = UIColor.white
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS
        {
            self.messengerBtn.badgeEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 15)
        }
        else if DeviceType.IS_IPHONE_6
        {
            self.messengerBtn.badgeEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 25)
        }
        else if DeviceType.IS_IPHONE_6P
        {
            self.messengerBtn.badgeEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 30)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if self.revealViewController() != nil
        {
            self.revealViewController().callbackHistoryOrder = {(historyObj) in
                let hisObj = historyObj as! HistoryObject
                appDelegate.setViewPickupFromChooseService(listPointPreorder: hisObj.locations!)
                
            }
        }
        
        if flagChangeView {
            flagChangeView = false
            if flagFirstBikeMove == true
            {
                self.runBike()
            }
            
        }
        
        NotificationCenter.default.addObserver(self, selector:  #selector(applicationDidEnterBackground),
                                               name: NSNotification.Name.UIApplicationDidEnterBackground,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(applicationDidBecomeActive),
                                               name: NSNotification.Name.UIApplicationDidBecomeActive,
                                               object: nil)
        
        if isFirst == false
        {
            isFirst = true
            self.setMarkerandDateShipper()
        }
        else
        {
            self.blockCallBackFromSmartFox()
        }
        self.setLocalize()
        DataConnect.getOrderStatus(token_API, country_code: kCountryCode, phone: userPhone_API, id_order: self.order_id!, onsuccess: { (result) in
            let obj = result as! CheckOrderStatusObject
            
            if obj.status == 0
            {
                
                var hashNumberChat = defaults.value(forKey: "chatNumber") as! [String:String]
                
                if hashNumberChat[String(describing:self.order_id!)] == nil
                {
                    hashNumberChat[String(describing:self.order_id!)] = "0"
                    defaults.set(hashNumberChat, forKey: "chatNumber")
                    
                }
                else
                {
                    self.totalNumberChat = Int(hashNumberChat[String(describing:self.order_id!)]!)! + self.senderShipper.new_chat_number!
                }
                
                if self.totalNumberChat == 0
                {
                    self.messengerBtn.badgeString = ""
                }
                else
                {
                    self.messengerBtn.badgeString = String(format: "%d", self.totalNumberChat)
                }
            }
            else if obj.status == -1
            {
                customAlertView(self, title:MCLocalization.string(forKey: "SHIPPERCANCEL", withPlaceholders: ["%name%" : String(describing: obj.order_code!)]), btnTitleNameNormal: name_confirm_Button_Normal,titleButton: "OK",blockCallback: {result in
                    appDelegate.setRootView(isShowFollowJouneyStackScreen: false)
                })
            }
            else if obj.status == 1
            {
                customAlertView(self, title: MCLocalization.string(forKey: "SHIPPERFINISH", withPlaceholders: ["%name%" : String(describing: obj.order_code!)]), btnTitleNameNormal: name_confirm_Button_Normal,titleButton: "OK",blockCallback: {
                    result in
                    let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "RateUsViewController") as! RateUsViewController
                    vc.order_id = self.order_id
                    self.present(vc, animated: true, completion: nil)
                    
                })
            }
            
        }) { (error) in
            showErrorMessage(error: error as! Int, vc: self)
        }
        
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        //SmartFoxObject.sharedInstance.blockCallBack = nil
        flagChangeView = true
    }
    deinit {
        googleMapsView.removeFromSuperview()
        googleMapsView = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    func applicationDidEnterBackground()
    {
        flagChangeView = true
    }
    func applicationDidBecomeActive()
    {
        if flagChangeView {
            flagChangeView = false
            if flagFirstBikeMove == true
            {
                self.runBike()
            }
        }
        
        if flagReconectSocketFromBackground{
            flagReconectSocketFromBackground = false
            reConnectedSmartFox()
        }
    }
    
    // MARK: - FUNCTION
    
    func backAction()
    {
        let _ = navigationController?.popViewController(animated: true)
        
    }
    func blockCallBackFromSmartFox()
    {
        if SmartFoxObject.sharedInstance.smartFox.isConnected == false
        {
           reConnectedSmartFox()
        }
        SmartFoxObject.sharedInstance.blockCallBack = {
            (type,result) in
            if type == kPublicChatText || type == kPublicChatImage ||  type == kPublicChatImageURL
            {
                var hashNumberChat = defaults.value(forKey: "chatNumber") as! [String:String]
                if hashNumberChat[String(describing:self.order_id!)] == nil
                {
                    hashNumberChat[String(describing:self.order_id!)] = "0"
                    defaults.set(hashNumberChat, forKey: "chatNumber")
                    
                }
                else
                {
                    self.totalNumberChat = Int(hashNumberChat[String(describing:self.order_id!)]!)! + self.senderShipper.new_chat_number!
                }
                
                if self.totalNumberChat == 0
                {
                    self.messengerBtn.badgeString = ""
                }
                else
                {
                    self.messengerBtn.badgeString = String(format: "%d", self.totalNumberChat)
                }
                
                
            }
            else if type == kCmdConnectedSuccess
            {
                loginToZone()
                
            }
            else if type == kCmdLoginSuccess2ND
            {
                let param = SFSObject.newInstance()
                param?.putUtfString("command", value: kcmdGetFollowJourney)
                param?.putInt("id_order", value: self.order_id!)
                SmartFoxObject.sharedInstance.sendExtendsionRequest(kExtCmd, param: param, isNeedShowLoading: true)
            }
            else if type == kcmdGetFollowJourney
            {
                print("reconnect")
            }
            else if type == kCmdUpdateShipperPosition
            {
                if let item = result as? ShipperPosition
                {
                    self.loadLocationShipper(item)
                }
                else
                {
                    print("error")
                }
                
            }
            else if type == kCmdFinish
            {
                if self.flagFromSlideMenu == true
                {
                    customAlertView(self, title: MCLocalization.string(forKey: "SHIPPERFINISH", withPlaceholders: ["%name%" : String(describing: result as! String)]), btnTitleNameNormal: name_confirm_Button_Normal,titleButton: "OK",blockCallback: {result in
                        let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "RateUsViewController") as! RateUsViewController
                        vc.order_id = self.order_id
                        self.present(vc, animated: true, completion: nil)
                        
                    })
                    
                }
                else
                {
                    if self.revealViewController().frontViewPosition == .right
                    {
                        UIView.animate(withDuration: 0.5, animations: {
                            self.revealViewController().revealToggle(animated: true)
                        }, completion: { (result_) in
                            customAlertView(self, title:  MCLocalization.string(forKey: "SHIPPERFINISH", withPlaceholders: ["%name%" : String(describing: result as! String)]), btnTitleNameNormal: name_confirm_Button_Normal,titleButton: "OK",blockCallback: {
                                result in
                                let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "RateUsViewController") as! RateUsViewController
                                vc.order_id = self.order_id
                                self.present(vc, animated: true, completion: nil)
                                
                            })
                        })
                    }
                    else
                    {
                        customAlertView(self, title:  MCLocalization.string(forKey: "SHIPPERFINISH", withPlaceholders: ["%name%" : String(describing: result as! String)]), btnTitleNameNormal: name_confirm_Button_Normal,titleButton: "OK",blockCallback: {
                            result in
                            let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "RateUsViewController") as! RateUsViewController
                            vc.order_id = self.order_id
                            self.present(vc, animated: true, completion: nil)
                            
                        })
                    }
                }
            }
            else if type == kCmdCancelOrder
            {
                
                if self.flagFromSlideMenu == true
                {
                    customAlertView(self, title:MCLocalization.string(forKey: "SHIPPERCANCEL", withPlaceholders: ["%name%" : String(describing: result as! String)]), btnTitleNameNormal: name_confirm_Button_Normal,titleButton: "OK",blockCallback: {result in
                        appDelegate.setRootView(isShowFollowJouneyStackScreen: false)
                    })
                    
                }
                else
                {
                    if self.revealViewController().frontViewPosition == .right
                    {
                        UIView.animate(withDuration: 0.5, animations: {
                            self.revealViewController().revealToggle(animated: true)
                        }, completion: { (result_) in
                            customAlertView(self, title: MCLocalization.string(forKey: "SHIPPERCANCEL", withPlaceholders: ["%name%" : String(describing: result as! String)]), btnTitleNameNormal: name_confirm_Button_Normal,titleButton: "OK",blockCallback: {result in
                                appDelegate.setRootView(isShowFollowJouneyStackScreen: false)
                            })
                            
                        })
                    }
                    else
                    {
                        customAlertView(self, title: MCLocalization.string(forKey: "SHIPPERCANCEL", withPlaceholders: ["%name%" : String(describing: result as! String)]), btnTitleNameNormal: name_confirm_Button_Normal,titleButton: "OK",blockCallback: {result in
                            appDelegate.setRootView(isShowFollowJouneyStackScreen: false)
                        })
                    }
                    
                }
                
            }
            else if type == kCmdDisconnect
            {
                //phuc
                //                customAlertViewWithCancelButton(self, title: MCLocalization.string(forKey: "DISCONNECT"), btnTitleNameNormal: name_confirm_Button_Normal,  btnCancelNameNormal: name_cancel_Button_Normal,titleOrangeButton: MCLocalization.string(forKey: "TRY"), titleGreyButton: MCLocalization.string(forKey: "EXIT"), isClose: false,  blockCallback: {result in
                //                    self.reConnectedSmartFox()
                //                }, blockCallbackCancel: {result in
                //                    appDelegate.setRootView(isShowFollowJouneyStackScreen: false)
                //                })
                
                if UIApplication.shared.applicationState == .active
                {
                    self.reConnectedSmartFox()
                }
                else
                {
                    self.flagReconectSocketFromBackground = true
                }
                
            }
            else if type == kCmdError
            {
                customAlertView(self, title: getErrorStringConfig(code: String(describing: result as! Int))! , btnTitleNameNormal: name_confirm_Button_Normal,titleButton: "OK",  blockCallback: { (result) in
                })
                
            }
        }
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
    
    func revealController(_ revealController: SWRevealViewController!, animateTo position: FrontViewPosition) {
        if position == .right
        {
            viewWhenTapMenu.isHidden = false
        }
        else
        {
            viewWhenTapMenu.isHidden = true
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        tracking(actionKey: "C8.6Y")
        if flagHideNavigationBar == false
        {
            flagHideNavigationBar = true
            UIView.animate(withDuration: 0.3) {
                self.contrainsTopBar.constant =  -64
                self.contrainsBottom.constant = -self.viewBottom.frame.height
                self.view.layoutIfNeeded()
            }
            
        }else
        {
            flagHideNavigationBar = false
            UIView.animate(withDuration: 0.3) {
                self.contrainsTopBar.constant =  0
                self.contrainsBottom.constant = 0
                self.view.layoutIfNeeded()
            }
        }
        
    }
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        //        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("DetailOrderViewController") as! DetailOrderViewController
        //        vc.point = (marker as! CustomMarker).point
        //        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    
    
    // MARK: - SetMarkerAndLocation
    func setMarkerandDateShipper() {
        self.lblNameShipper.text = senderShipper.shipper_fullname
        var mins = senderShipper.duration/60
        if mins < 60
        {
            self.lblDuration.text = MCLocalization.string(forKey: "DELIVEREDINHOUR", withPlaceholders: ["%name%" : String(format: "%.0f", mins)])
        }
        else
        {
            let hour = Int(mins/60)
            mins = mins - Double(hour*60)
            self.lblDuration.text = MCLocalization.string(forKey: "DELIVEREDINMIN", withPlaceholders: ["%hour%" : String(format: "%d", hour), "%min%" : String(format: "%.0f", mins)])
        }
        
        googleMapsView.clear()
        //set shipper marker first
        let center = CLLocationCoordinate2D(latitude: senderShipper.shipper_latitude! as CLLocationDegrees, longitude: senderShipper.shipper_longitude! as CLLocationDegrees)
        markerShipper.position = center
        locationA.longitude = center.longitude
        locationA.latitude = center.latitude
        markerShipper.title = senderShipper.shipper_name
        markerShipper.icon = UIImage(named: "shipper")
        markerShipper.groundAnchor  = CGPoint(x: 0.5, y: 0.5)
        markerShipper.map = self.googleMapsView
        
        for index in 0...listPoint.count - 1
        {
            
            let pointer = listPoint[index]
            if index != 0
            {
                let previousPointer = listPoint[index - 1]
                if pointer.latitude == nil || pointer.longitude == nil || previousPointer.latitude == nil || previousPointer.longitude == nil
                {
                    listPoint[index].distance = 0.0
                }
                else
                {
                    let aCLLocation = CLLocation(latitude: previousPointer.latitude!, longitude: previousPointer.longitude!)
                    let bCLLocation = CLLocation(latitude: pointer.latitude!, longitude: pointer.longitude!)
                    let aCLLocation2D = CLLocationCoordinate2D(latitude: previousPointer.latitude!, longitude: previousPointer.longitude!)
                    let bCLLocation2D = CLLocationCoordinate2D(latitude: pointer.latitude!, longitude: pointer.longitude!)
                    listPoint[index].distance = aCLLocation.distance(from: bCLLocation)
                    let color = UIColor(hex: colorXamNhat)
                    ShowDirection.sharedInstance.showDirection(aCLLocation2D, end: bCLLocation2D, map: googleMapsView, color: color,point: listPoint[index])
                    
                }
            }
            if pointer.address != ""
            {
                let marker = CustomMarker(_point: pointer)
                marker.snippet = pointer.address
                marker.title = pointer.recipent_name
                marker.map = googleMapsView
                marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0)
                var offsetY = 1.0
                marker.groundAnchor = CGPoint(x: 0.5, y: 1)
                if index > 0
                {
                    for i in 0...index -  1
                    {
                        if pointer.latitude != nil{
                            if pointer.latitude == listPoint[i].latitude
                            {
                                offsetY += 0.5
                                marker.groundAnchor = CGPoint(x: 0.5, y: offsetY)
                            }
                        }
                    }
                }
                if pointer.role == 3
                {
                    let viewIcon = CustomDropLocation.instanceFromNib()
                    viewIcon.prepareView(address: pointer.address)
                    let tempLatitude = pointer.latitude! + 0.000003
                    marker.position = CLLocationCoordinate2D(latitude: tempLatitude, longitude: pointer.longitude!)
                    marker.iconView = viewIcon
                }
                else if pointer.role == 2
                {
                    let viewIcon = CustomMarkerView.instanceFromNib()
                    viewIcon.prepareView(number: "3", address: pointer.address)
                    let tempLatitude = pointer.latitude! + 0.000002
                    marker.position = CLLocationCoordinate2D(latitude: tempLatitude, longitude: pointer.longitude!)
                    marker.iconView = viewIcon
                }
                else if pointer.role == 1
                {
                    let viewIcon = CustomMarkerView.instanceFromNib()
                    viewIcon.prepareView(number: "2", address: pointer.address)
                    let tempLatitude = pointer.latitude! + 0.000001
                    marker.position = CLLocationCoordinate2D(latitude: tempLatitude, longitude: pointer.longitude!)
                    marker.iconView = viewIcon
                }
                else if pointer.role == 0
                {
                    let viewIcon = CustomMarkerView.instanceFromNib()
                    viewIcon.prepareView(number: "1", address: pointer.address)
                    marker.iconView = viewIcon
                    marker.position = CLLocationCoordinate2D(latitude: pointer.latitude!, longitude: pointer.longitude!)
                }
                else
                {
                    marker.icon = UIImage(named: "shop")
                    marker.position = CLLocationCoordinate2D(latitude: pointer.latitude!, longitude: pointer.longitude!)
                }
                
                
                
                
                
                
            }
        }
        // 5 phut
        //        DataConnect.getListShipperPosition(token_API, country_code: kCountryCode, phone: userPhone_API, id_order: self.order_id!, view: self.view, onsuccess: { (result) in
        //
        //            let listShipper = result as! ListShipperPosition
        //            if (listShipper.positions?.count)! >= 2
        //            {
        ////                var danhSachCanVe :[ShipperPosition] = []
        ////                if (listShipper.positions?.count)! <= 23
        ////                {
        ////                    danhSachCanVe = listShipper.positions!
        ////                }
        ////                else
        ////                {
        ////                    // 23 is maximum waypoint
        ////                    let buocnhay = Float((listShipper.positions?.count)!) / 23
        ////                    danhSachCanVe.append((listShipper.positions?.first)!)
        ////                    for i in 0...23
        ////                    {
        ////                        if i > 22
        ////                        {
        ////                            break
        ////                        }
        ////                        let vitri = (Float(i) * buocnhay).roundToInt()
        ////                        danhSachCanVe.append((listShipper.positions?[vitri])!)
        ////                    }
        ////                    danhSachCanVe.append((listShipper.positions?.last)!)
        ////                }
        ////
        ////                if danhSachCanVe.count >= 2
        ////                {
        ////                    let color = UIColor(hex: colorCam)
        ////                    ShowDirection.sharedInstance.getDotsToDrawRoute(positionss: danhSachCanVe, map: self.googleMapsView, color: color, point: nil)
        ////                }
        //
        //                    let color = UIColor(hex: colorCam)
        //                    ShowDirection.sharedInstance.drawPolylineAllPoint(listShipper.positions!, color: color,map: self.googleMapsView)
        //
        //
        //            }
        //
        //        }) { (error) in
        //            showErrorMessage(error: error as! Int, vc: self)
        //        }
        fitAllMarkers()
    }
    
    func fitAllMarkers() {
        var bounds = GMSCoordinateBounds()
        for point in listPoint {
            if point.latitude == nil || point.longitude == nil
            {
                break
            }
            bounds = bounds.includingCoordinate(CLLocationCoordinate2D(latitude: point.latitude!, longitude: point.longitude!))
        }
        CATransaction.begin()
        CATransaction.setValue(NSNumber(value: 1.0), forKey: kCATransactionAnimationDuration)
        
        let insets = UIEdgeInsets(top: 80, left: 100, bottom: self.viewBottom.frame.height + 16, right: 100)
        self.googleMapsView.animate(with: GMSCameraUpdate.fit(bounds, with: insets))
        CATransaction.commit()
        
        
    }
    
    func arCarMovement(_ movedMarker: GMSMarker) {
        if listDrawBikeCoordinate.count > 0
        {
            runBike()
            listDrawBikeCoordinate.removeFirst()
            print(listDrawBikeCoordinate.count)
        }
        else
        {
            flagFirstBikeMove = false
        }
        
        
    }
    
    
    func runBike()
    {
        if flagChangeView == false
        {
            if listDrawBikeCoordinate.count >= 1
            {
                print("ve moto")
                var duration = Float(Config.sharedInstance.shipper_update_postion_time_in_journey!)
                
                if self.listDrawBikeCoordinate.count > 4 && self.listDrawBikeCoordinate.count < 8
                {
                    duration = Float(Config.sharedInstance.shipper_update_postion_time_in_journey!) - 2.0
                }
                else if self.listDrawBikeCoordinate.count >= 8
                {
                    duration = Float(Config.sharedInstance.shipper_update_postion_time_in_journey!) - 4.0
                }
                else if self.listDrawBikeCoordinate.count <= 4
                {
                    if self.listDrawBikeCoordinate.count == 1
                    {
                        duration = Float(Config.sharedInstance.shipper_update_postion_time_in_journey!) + 15
                        
                    }
                    else
                    {
                        duration = Float(Config.sharedInstance.shipper_update_postion_time_in_journey!) + 4.0
                    }
                }
                
                
                let newCorordinate = CLLocationCoordinate2D(latitude: (listDrawBikeCoordinate.first?.latitude)!, longitude: (listDrawBikeCoordinate.first?.longitude)!)
                moveMent.arCarMovement(self.markerShipper, withOldCoordinate: self.markerShipper.position, andNewCoordinate: newCorordinate, inMapview: self.googleMapsView, withBearing: 0, withDuration: duration)
                
                
                //                locationB.longitude = (listDrawBikeCoordinate.first?.longitude)!
                //                locationB.latitude = (listDrawBikeCoordinate.first?.latitude)!
                //                let color = UIColor(hex: colorCam)
                //
                //               // ShowDirection.sharedInstance.showDirection(self.locationA , end: self.locationB , map: self.googleMapsView , color: color,point: nil)
                //
                //                ShowDirection.sharedInstance.drawPolylineTwoPoint(self.locationA, end: self.locationB, color: color, map: self.googleMapsView)
                //                locationA.longitude = (listDrawBikeCoordinate.first?.longitude)!
                //                locationA.latitude = (listDrawBikeCoordinate.first?.latitude)!
                
                
                
                
                
            }
        }
        
    }
    // MARK: Notification
    func loadLocationShipper(_ obj : ShipperPosition)
    {
        //                listDrawBikeCoordinate.append(listTamp[indexCountDrawRouter])
        //
        //                if indexCountDrawRouter == 40{
        //                    indexCountDrawRouter = 0
        //                }
        //
        //                if listDrawBikeCoordinate.count == 1
        //                {
        //                    if flagFirstBikeMove == false
        //                    {
        //                         print("ve lai")
        //                        flagFirstBikeMove = true
        //                        runBike()
        //                    }
        //
        //                }
        //                    indexCountDrawRouter += 1
        
        let coordinate = CLLocationCoordinate2D(latitude: obj.shipper_latitude!, longitude: obj.shipper_longitude!)
        listDrawBikeCoordinate.append(coordinate)
        print (listDrawBikeCoordinate.count)
        senderShipper.shipper_latitude = obj.shipper_latitude
        senderShipper.shipper_longitude = obj.shipper_longitude
        if listDrawBikeCoordinate.count == 1
        {
            if flagFirstBikeMove == false
            {
                print("ve lai")
                flagFirstBikeMove = true
                runBike()
            }
            
        }
        
        
    }
    
    
    
    // MARK: IBACTION
    
    @IBAction func gotoOrder(_ sender: AnyObject)
    {
        tracking(actionKey: "C8.3Y")
        let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "FullOrderSubViewController") as! FullOrderSubViewController
        vc.id_order = order_id
        vc.flagFollowJourney = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getGPS()
    {
        
        self.googleMapsView.isMyLocationEnabled = true
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self;
            locationManager.distanceFilter = kCLDistanceFilterNone;
            locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            locationManager.startUpdatingLocation()
        }
        else{
            customAlertView(self, title: MCLocalization.string(forKey: "TURNONLOCATION"), btnTitleNameNormal: name_confirm_Button_Normal,titleButton: "OK",blockCallback: {
                result in
                UIApplication.shared.openURL(URL(string:UIApplicationOpenSettingsURLString)!)
            })
        }
    }
    
    private func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation = locations.last
        let center = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
        googleMapsView.animate(to: GMSCameraPosition.camera(withTarget: center, zoom: Float(16.5)))
        locationManager.stopUpdatingLocation()
        
    }
    
    @IBAction func newOrder(_ sender: AnyObject) {
        tracking(actionKey: "C8.1Y")
        appDelegate.setRootView(isShowFollowJouneyStackScreen: false)
    }
    @IBAction func btnGPSClick(_ sender: AnyObject) {
        getGPS()
    }
    
    @IBAction func btnGPSShipper(_ sender: AnyObject) {
        googleMapsView.animate(to: GMSCameraPosition.camera(withTarget: markerShipper.position, zoom: Float(16.5)))
    }
    @IBAction func btnCall(_ sender: UIButton) {
        tracking(actionKey: "C8.4Y")
        sender.isEnabled = false
        delayWithSeconds(0.5) {
            sender.isEnabled = true
        }
        callNumber(senderShipper.shipper_phone!) { (result) in
            
        }
    }
    @IBAction func btnMess(_ sender: AnyObject) {
        tracking(actionKey: "C8.5Y")
        
        var hasNumber = defaults.value(forKey: "chatNumber") as! [String:String]
        hasNumber[String(describing:order_id!)] = "0"
        defaults.set(hasNumber, forKey: "chatNumber")
        senderShipper.new_chat_number = 0
        self.messengerBtn.badgeString = ""
        let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "DemoChatViewController") as! DemoChatViewController
        var dataSource: FakeDataSource!
        if dataSource == nil {
            dataSource = FakeDataSource(count: 0   , pageSize: 50)
        }
        vc.dataSource = dataSource
        vc.messageSender = dataSource.messageSender
        vc.listPoint = listPoint
        vc.senderShipper = senderShipper
        vc.order_id_Chat = order_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

class CustomMarker : GMSMarker
{
    var point: PointLocation
    init(_point: PointLocation) {
        point = _point
    }
}

