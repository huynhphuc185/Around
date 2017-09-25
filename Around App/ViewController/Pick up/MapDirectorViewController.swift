//
//  ViewController.swift
//  Shipper
//
//  Created by phuc.huynh on 8/18/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CircularSpinner
import JTMaterialSpinner
import ObjectMapper
typealias onHandler = (_ result : AnyObject)->()

class Address : NSObject,JSONSerializable {
    var name = ""
    var street = ""
    var fullAddress = ""
    var placeID = ""
    func parseDataFromDictionary(_ jsonDic : NSDictionary )->Address
    {
        let obj = Address()
        obj.name = (jsonDic["name"] as? String)!
        obj.street = (jsonDic["street"] as? String)!
        obj.fullAddress = (jsonDic["fullAddress"] as? String)!
        obj.placeID = (jsonDic["placeID"] as? String)!
        return obj
        
    }
}
class DeliveryTableViewCell : UITableViewCell
{
    static let identifier = "deliveryCell"
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lbldetail: UILabel!
}
class MapDirectorViewController: StatusbarViewController,CLLocationManagerDelegate,ISFSEvents,SWRevealViewControllerDelegate {
    @IBOutlet weak var constrainBottom: NSLayoutConstraint!
    @IBOutlet weak var googleMapsView:GMSMapView!
    @IBOutlet weak var tblViewSuggestion: UITableView!
    @IBOutlet weak var tblViewLocation: UITableView!
    @IBOutlet weak var defNav: DefaultNavigation!
    @IBOutlet weak var btnGotoOrder: UIButton!
    @IBOutlet weak var btnGPS: UIButton!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var viewCloseKeyboardwhenTap: UIView!
    @IBOutlet weak var viewCloseSlideMenu: UIView!
    private var lastContentOffset: CGFloat = 0
    var placeClient = GMSPlacesClient()
    var flagGpSClick: Bool = false
    var resultsArray = [Address]()
    var listPoint:[PointLocation] = []
    var locationManager = CLLocationManager()
    let gpsMarker = GMSMarker()
    var indexChooseTableViewCell: Int?
    var indexLastCellPoint: Int?
    var senderData = DataSender()
    var listSearchArray: [Address] = []
    var flagTurnOffKeyboard = false
    var flagGetLocationOneTime = false
    var listBanner : ListBanner?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if defaults.object(forKey: "firsttime") == nil{
            defaults.setValue("first", forKey: "firsttime")
            if DeviceType.IS_IPHONE_5
            {
                showTutorial(self, imageName: MCLocalization.string(forKey: "IMAGEDEMO1_IP5"))
            }
            else if DeviceType.IS_IPHONE_6
            {
                showTutorial(self, imageName: MCLocalization.string(forKey: "IMAGEDEMO1_IP6"))
            }
            else if DeviceType.IS_IPHONE_6P
            {
                showTutorial(self, imageName: MCLocalization.string(forKey: "IMAGEDEMO1"))
            }
        }
        
        DataConnect.getListBanner(token_API, country_code: kCountryCode, phone: userPhone_API, position: 1, view: self.view, onsuccess: { (result) in
            self.listBanner = result as? ListBanner
            self.loadBanner()
        }) { (error) in
        }
        
        
        self.revealViewController().delegate = self
        viewCloseSlideMenu.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        viewCloseSlideMenu.isHidden = true
        btnGotoOrder.isEnabled = false
        btnGotoOrder.setBackgroundImage(UIImage(named:"next_off"), for: .normal)
        loadDataPointinMap()
        tblViewLocation.isHidden = true
        viewCloseKeyboardwhenTap.isHidden = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(MapDirectorViewController.closeInputData))
        self.viewCloseKeyboardwhenTap.addGestureRecognizer(gesture)
        googleMapsView.delegate  = self
        setMarker()
        
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

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewWillAppear(_ animated: Bool) {
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

        
        self.revealViewController().callbackHistoryOrder = {(historyObj) in
            self.listPoint.removeAll()
            let hisObj = historyObj as! HistoryObject
            self.listPoint = hisObj.locations!
            self.setMarker()
            self.closeInputData()
            self.fitAllMarkers(location : self.listPoint[1] )
        }
        getArraySearchString()
        self.tblViewSuggestion.reloadData()
        
    }
    func loadDataPointinMap()
    {
        if listPoint.count == 0
        {
            getGPS()
            let mapa = Map(mappingType: .fromJSON, JSON: ["role":0,"ispay":true,"ispickup":false])
            let mapb = Map(mappingType: .fromJSON, JSON: ["role":3,"ispay":false,"ispickup":true])
            let aPoint = PointLocation(map: mapa)
            let bPoint = PointLocation(map: mapb)
            if appDelegate.nameUser != nil
            {
                 bPoint?.recipent_name = appDelegate.nameUser!
            }
            bPoint?.phone = userPhone_API
            listPoint.append(aPoint!)
            listPoint.append(bPoint!)
        }
        else
        {
            self.fitAllMarkers(location : self.listPoint[1])
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
        self.tblViewSuggestion.reloadData()
        self.tblViewLocation.isHidden = true
        viewCloseKeyboardwhenTap.isHidden = true
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.3) {
            self.btnGPS.isHidden = false
            self.constrainBottom.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    func getGPS()
    {
        self.googleMapsView.isMyLocationEnabled = true
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined :
                locationManager.requestWhenInUseAuthorization()
            case .restricted :
                print("restricted")
            case  .denied:
                customAlertView(self, title: MCLocalization.string(forKey: "TURNONLOCATION"), btnTitleNameNormal: name_confirm_Button_Normal,titleButton: MCLocalization.string(forKey: "GOTOSETTING"), blockCallback: {result in
                    UIApplication.shared.openURL(URL(string:UIApplicationOpenSettingsURLString)!)
                })
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                locationManager.delegate = self;
                locationManager.distanceFilter = kCLDistanceFilterNone;
                locationManager.desiredAccuracy = kCLLocationAccuracyBest;
                locationManager.startUpdatingLocation()
            }
            
        }
        else {
            customAlertView(self, title: MCLocalization.string(forKey: "TURNONLOCATION"), btnTitleNameNormal: name_confirm_Button_Normal,titleButton: MCLocalization.string(forKey: "GOTOSETTING"), blockCallback: {result in
                if #available(iOS 10.0, *)
                {
                    UIApplication.shared.openURL(URL(string:"App-Prefs:root=LOCATION_SERVICES")!)
                }
                else
                {
                    UIApplication.shared.openURL(URL(string:"prefs:root=LOCATION_SERVICES")!)
                }
                
            })
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
    
    
    private func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if flagGetLocationOneTime == false
        {
            flagGetLocationOneTime = true
            if flagGpSClick == false
            {
                let userLocation = locations.last
                if userLocation == nil
                {
                    return
                }
                let center = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
                googleMapsView.animate(to: GMSCameraPosition.camera(withTarget: center, zoom: Float(16.5)))
                let url = String(format: "http://maps.googleapis.com/maps/api/geocode/json?latlng=\(center.latitude),\(center.longitude)&sensor=false")
                DataConnect.convertCoordinatesToAddress(url, onsuccess: { (result) in
                    if result == nil{
                        return
                    }
                    if (result!["results"] as! NSArray).count == 0
                    {
                        return
                    }
                    self.listPoint[0].address = (((result!["results"] as! NSArray)[0] as! NSDictionary)["formatted_address"]! as? String)!
                    self.listPoint[0].placeid = (((result!["results"] as! NSArray)[0] as! NSDictionary)["place_id"]! as? String)!
                    self.listPoint[0].longitude = center.longitude
                    self.listPoint[0].latitude = center.latitude
                    self.tblViewSuggestion.reloadData()
                }) { (error) in
                }
            }
            else
            {
                let userLocation = locations.last
                let center = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
                googleMapsView.animate(to: GMSCameraPosition.camera(withTarget: center, zoom: Float(16.5)))
            }
            locationManager.stopUpdatingLocation()
            
        }
    }
    
    
    func fitAllMarkers(location: PointLocation) {
        var bounds = GMSCoordinateBounds()
        var flagCountListPoint = 0
        for point in listPoint {
            if point.latitude == nil || point.longitude == nil
            {
                
            }
            else
            {
                flagCountListPoint += 1
                bounds = bounds.includingCoordinate(CLLocationCoordinate2D(latitude: point.latitude!, longitude: point.longitude!))
            }
        }
        if flagCountListPoint == 1
        {
            let center = CLLocationCoordinate2D(latitude: location.latitude!, longitude: location.longitude!)
            googleMapsView.animate(to: GMSCameraPosition.camera(withTarget: center, zoom: Float(16.5)))
        }
        else
        {
            CATransaction.begin()
            CATransaction.setValue(NSNumber(value: 1.0), forKey: kCATransactionAnimationDuration)
            let insets = UIEdgeInsets(top: 80, left: 100, bottom: self.viewBottom.frame.height + 16, right: 100)
            self.googleMapsView.animate(with: GMSCameraUpdate.fit(bounds, with: insets))
            CATransaction.commit()
        }
        
    }
    // MARK: IBACTION
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
    @IBAction func btnGotoOrder(_ sender: AnyObject?)
    {
        tracking(actionKey: "C5.5Y")
        for item in listPoint.enumerated()
        {
            if item.offset != listPoint.count - 1
            {
                if item.element.item_name.trimmingCharacters(in: .whitespaces).isEmpty
                {
                    self.tblViewLocation.reloadData {
                        let indexpath = NSIndexPath(row: item.offset, section: 0)
                        
                        UIView.animate(withDuration: 0, animations: {
                            self.tblViewSuggestion.scrollToRow(at: indexpath as IndexPath, at: .top, animated: false)
                        }, completion: { (result) in
                            let currentCell = self.tblViewSuggestion.cellForRow(at: indexpath as IndexPath)! as! SuggestLocation
                            currentCell.imageEmpty.bounce(nil)
                            currentCell.btnEdit.bounce(nil)
                        })
                    }
                    return
                    
                }
            }
            else
            {
                if item.element.recipent_name.trimmingCharacters(in: .whitespaces).isEmpty
                {
                    self.tblViewLocation.reloadData {
                        let indexpath = NSIndexPath(row: item.offset, section: 0)
                        
                        UIView.animate(withDuration: 0, animations: {
                            self.tblViewSuggestion.scrollToRow(at: indexpath as IndexPath, at: .top, animated: false)
                        }, completion: { (result) in
                            let currentCell = self.tblViewSuggestion.cellForRow(at: indexpath as IndexPath)! as! SuggestLocation
                            currentCell.imageEmpty.bounce(nil)
                            currentCell.btnEdit.bounce(nil)
                        })
                    }
                    return
                    
                }
            }
            
        }
        senderData.listLocationSender = listPoint
        let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "OrderViewController") as! OrderViewController
        vc.sender = self.senderData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnGPSClick(_ sender: AnyObject) {
        flagGpSClick = true
        flagGetLocationOneTime = false
        getGPS()
    }
    
    
    
    func setMarker() {
        googleMapsView.clear()
        listPoint =  listPoint.sorted(by: { $0.role! < $1.role! })
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
                   // listPoint[index].distance = aCLLocation.distance(from: bCLLocation)
                    let color = UIColor(hex: colorCam)
                    ShowDirection.sharedInstance.showDirection(aCLLocation2D, end: bCLLocation2D, map: googleMapsView, color: color,point: listPoint[index])
                    
                }
            }
            if pointer.address != ""
            {
                
                let marker = GMSMarker()
                
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
                    if pointer.latitude != nil && pointer.longitude != nil
                    {
                        btnGotoOrder.isEnabled = true
                        btnGotoOrder.setBackgroundImage(UIImage(named:"next_on"), for: .normal)
                        
                    }
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
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


extension MapDirectorViewController: UITableViewDelegate, UITableViewDataSource,GMSMapViewDelegate,UITextFieldDelegate {
    
    //    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
    //        <#code#>
    //    }
    
    @IBAction func btnEditClick(_ sender: AnyObject) {
        
        if listPoint[sender.tag].role == 3
        {
            if listPoint[sender.tag].address != ""
            {
                showPopupBackToPickupInfomation(point: listPoint[sender.tag],flagEdit: true, blockCallback: { (result) in
                
                  self.dismiss(animated: false, completion: {
                     self.closeInputData()
                     self.setMarker()
                     self.fitAllMarkers(location : self.listPoint[sender.tag])
//                      self.btnGotoOrder(nil)
                   })
                
                
                  })
            }
            else
            {
                
                let indexpath = NSIndexPath(row: sender.tag, section: 0)
                let currentCell = tblViewSuggestion.cellForRow(at: indexpath as IndexPath)! as! SuggestLocation
                currentCell.txtPickup.becomeFirstResponder()

            }
        }
            
        else
        {
            if listPoint[sender.tag].address != ""
            {
                
                showPopupInfomation(point: listPoint[sender.tag] ,flagEdit: true,blockCallback: { (result) in
                    self.dismiss(animated: false, completion: {
                        self.setMarker()
                        self.closeInputData()
                        self.fitAllMarkers(location : self.listPoint[sender.tag] )
                        for item in self.listPoint.enumerated()
                        {
                            if item.element.address == ""
                            {
                                
                                let indexpath = NSIndexPath(row: item.offset, section: 0)
                                UIView.animate(withDuration: 0, animations: {
                                    self.tblViewSuggestion.scrollToRow(at: indexpath as IndexPath, at: .top, animated: false)
                                }, completion: { (result) in
                                    let currentCell = self.tblViewSuggestion.cellForRow(at: indexpath as IndexPath)! as! SuggestLocation
                                    currentCell.txtPickup.becomeFirstResponder()
                                })
                                break
                                
                            }
                        }
                    })
                    
                })
            }
            else
            {
                let indexpath = NSIndexPath(row: sender.tag, section: 0)
                let currentCell = tblViewSuggestion.cellForRow(at: indexpath as IndexPath)! as! SuggestLocation
               // currentCell.txtPickup.shake()
                currentCell.txtPickup.becomeFirstResponder()
                
            }
        }
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        
        indexChooseTableViewCell = textField.tag
        if textField.text?.length == 0
        {
            tblViewLocation.isHidden = true
        }
        else
        {
            tblViewLocation.isHidden = false
        }
        
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        filter.country = "VN"
        let visibleRegion = googleMapsView.projection.visibleRegion()
        let bounds = GMSCoordinateBounds(coordinate: visibleRegion.farLeft, coordinate: visibleRegion.nearRight)
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
            self.tblViewLocation.reloadData()
            
        }
        
        
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        viewCloseKeyboardwhenTap.isHidden = false
        UIView.animate(withDuration: 0.3) {
//            if self.flagTurnOffKeyboard == false
//            {
//                let point = self.listPoint[textField.tag]
//                if point.role == 3
//                {
//                    textField.attributedPlaceholder = NSAttributedString(string: MCLocalization.string(forKey: "NHAPDIADIEMNHAN"),
//                                                                         attributes: [NSForegroundColorAttributeName: UIColor(hex: colorXam)])
//                    textField.text = ""
//                    
//                    
//                }
//                else{
//                    textField.attributedPlaceholder = NSAttributedString(string: MCLocalization.string(forKey: "PICKUPWHERE"),
//                                                                         attributes: [NSForegroundColorAttributeName: UIColor(hex: colorXam)])
//                    textField.text = ""
//                   
//                }
//                
//                
//            }
//            else{
//                self.flagTurnOffKeyboard = false
//            }
            
            let point = self.listPoint[textField.tag]
            if point.role == 3
            {
                textField.attributedPlaceholder = NSAttributedString(string: MCLocalization.string(forKey: "NHAPDIADIEMNHAN"),
                                                                     attributes: [NSForegroundColorAttributeName: UIColor(hex: colorXam)])
                textField.text = ""
                
                
            }
            else{
                textField.attributedPlaceholder = NSAttributedString(string: MCLocalization.string(forKey: "PICKUPWHERE"),
                                                                     attributes: [NSForegroundColorAttributeName: UIColor(hex: colorXam)])
                textField.text = ""
                
            }
            self.btnGPS.isHidden = true
            self.indexLastCellPoint = textField.tag
            self.constrainBottom.constant = ScreenSize.SCREEN_HEIGHT - 64 - self.viewBottom.frame.height
            self.view.layoutIfNeeded()
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblViewSuggestion
        {
            return viewBottom.frame.height/2 + 2
        }
        else
        {
            return 56
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblViewSuggestion
        {
            return listPoint.count
        }
        else
        {
            return resultsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblViewSuggestion
        {
            
            let cell = self.tblViewSuggestion.dequeueReusableCell(withIdentifier: "suggestionCell") as! SuggestLocation
            cell.selectionStyle = .none
            cell.txtPickup.addTarget(self, action: #selector(MapDirectorViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
            cell.txtPickup.tag = indexPath.row
            cell.btnEdit.tag = indexPath.row
            cell.prepareCell(listPoint[indexPath.row], index: indexPath.row, list: listPoint)
            if listPoint[indexPath.row].role == 1 || listPoint[indexPath.row].role == 2
            {
                cell.txtPickup.insertRightButtonWithImage(image: UIImage(named:"delete")!, size: CGSize(width: 30, height: 30), _callback: { (result) in
                    tracking(actionKey: "C5.4N")
                    if self.listPoint[indexPath.row].role == 1 && self.listPoint[indexPath.row + 1].role == 2
                    {
                        self.listPoint[indexPath.row + 1].role = 1
                    }
                    self.listPoint.remove(at: indexPath.row)
                    self.closeInputData()
                    self.setMarker()
                })
                if self.listPoint[indexPath.row].item_name == ""
                {
                    cell.imageEmpty.isHidden = false
                }
                else
                {
                    cell.imageEmpty.isHidden = true
                }
            }
            else if listPoint[indexPath.row].role == 0
            {
                if self.listPoint[indexPath.row].item_name == ""
                {
                    cell.imageEmpty.isHidden = false
                }
                else
                {
                    cell.imageEmpty.isHidden = true
                }
                cell.txtPickup.insertRightButtonWithImage(image: UIImage(named:"plus_icon")!, size: CGSize(width: 30, height: 30), _callback: { [weak self](result) in
                    tracking(actionKey: "C5.1Y")
                    if (self?.listPoint.count)! < 4
                    {
                        
                        if self?.listPoint.count == 2
                        {
                            let map = Map(mappingType: .fromJSON, JSON: ["role":1,"ispay":false,"ispickup":false])
                            let aPoint = PointLocation(map: map)
                            self?.listPoint.insert(aPoint!, at: (self?.listPoint.count)! - 1)
                        }
                        else{
                            
                            let map = Map(mappingType: .fromJSON, JSON: ["role":2,"ispay":false,"ispickup":false])
                            let aPoint = PointLocation(map:map)
                            self?.listPoint.insert(aPoint!, at: (self?.listPoint.count)! - 1)
                        }
                        
                        self?.tblViewSuggestion.reloadData {
                            let indexPath = NSIndexPath(row: (self?.listPoint.count)! - 1, section: 0)
                            self?.tblViewSuggestion.scrollToRow(at: indexPath as IndexPath , at: .top, animated: true)
                        }
                        
                    }
                })
                
            }
            else if listPoint[indexPath.row].role == 3
            {
                cell.txtPickup.insertImageRight(image: UIImage(), size: CGSize(width: 30, height: 30))
                //phuc
                if self.listPoint[indexPath.row].recipent_name == ""
                {
                    cell.imageEmpty.isHidden = false
                }
                else
                {
                    cell.imageEmpty.isHidden = true
                }
                
            }
            
            
            if indexPath.row == listPoint.count - 1
            {
                cell.line.backgroundColor = UIColor.white
                //cell.btnEdit.isHidden = true
            }
            else
            {
                // cell.btnEdit.isHidden = false
                cell.line.backgroundColor = UIColor(hex: colorCam)
            }
            return cell
        }
        else
        {
            let cell = self.tblViewLocation.dequeueReusableCell(withIdentifier: "deliveryCell") as! DeliveryTableViewCell
            cell.lblTitle.text = self.resultsArray[(indexPath as NSIndexPath).row].name
            cell.lbldetail.text = self.resultsArray[(indexPath as NSIndexPath).row].fullAddress
            return cell
        }
    }

    
    
    
    
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        flagTurnOffKeyboard = true
        self.dismissKeyboard()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblViewSuggestion
        {
            
        }
        else
        {
            tableView.isHidden = true
            listPoint[indexChooseTableViewCell!].address = self.resultsArray[indexPath.row].fullAddress
            listPoint[indexChooseTableViewCell!].placeid = self.resultsArray[indexPath.row].placeID
            tblViewSuggestion.reloadData()
            googleMapsView.clear()
            
            if indexLastCellPoint == listPoint.count - 1
            {
                showProgressHub()
                let point = listPoint[indexChooseTableViewCell!]
                placeClient.lookUpPlaceID(point.placeid!, callback: { (place, err) -> Void in
                    if let error = err {
                        print("lookup place id query error: \(error.localizedDescription)")
                        return
                    }
                    
                    if let place = place {
                        self.listPoint[self.indexChooseTableViewCell!].placeid = place.placeID
                        self.listPoint[self.indexChooseTableViewCell!].latitude = place.coordinate.latitude
                        self.listPoint[self.indexChooseTableViewCell!].longitude = place.coordinate.longitude
                    } else {
                        print("No place details for")
                    }
                    hideProgressHub()
                    
                    self.showPopupBackToPickupInfomation(point: self.listPoint[self.indexChooseTableViewCell!],flagEdit: true, blockCallback: { (result) in
                        
                        self.dismiss(animated: false, completion: {
                            self.closeInputData()
                            self.setMarker()
                            self.fitAllMarkers(location : self.listPoint[self.indexChooseTableViewCell!] )
                            
                            
                            ShowDirection.sharedInstance.callbackWhenDraw = { result in
                                self.btnGotoOrder(nil)
                            }
                            
                          
                        })
                        
                        
                    })
                    
                   
                })
            }
            else{
                showProgressHub()
                placeClient.lookUpPlaceID(listPoint[indexChooseTableViewCell!].placeid!, callback: { (place, err) -> Void in
                    if let error = err {
                        print("lookup place id query error: \(error.localizedDescription)")
                        return
                    }
                    if let place = place {
                        self.listPoint[self.indexChooseTableViewCell!].placeid = place.placeID
                        self.listPoint[self.indexChooseTableViewCell!].latitude = place.coordinate.latitude
                        self.listPoint[self.indexChooseTableViewCell!].longitude = place.coordinate.longitude
                    } else {
                        print("No place details for")
                    }
                    hideProgressHub()
                    UIView.animate(withDuration: 0.3) {
                        self.btnGPS.isHidden = false
                        self.constrainBottom.constant = 0
                        self.view.layoutIfNeeded()
                    }
                    self.showPopupInfomation(point: self.listPoint[self.indexChooseTableViewCell!] ,flagEdit: false, blockCallback: { (result) in
                        self.dismiss(animated: false, completion: {
                            self.setMarker()
                            self.closeInputData()
                            self.fitAllMarkers(location : self.listPoint[self.indexChooseTableViewCell!] )
                            for item in self.listPoint.enumerated()
                            {
                                if item.element.address == ""
                                {
                                    
                                    let indexpath = NSIndexPath(row: item.offset, section: 0)
                                    UIView.animate(withDuration: 0, animations: {
                                        self.tblViewSuggestion.scrollToRow(at: indexpath as IndexPath, at: .top, animated: false)
                                    }, completion: { (result) in
                                        let currentCell = self.tblViewSuggestion.cellForRow(at: indexpath as IndexPath)! as! SuggestLocation
                                        currentCell.txtPickup.becomeFirstResponder()
                                    })
                                    break
                                    
                                }
                            }
                        })
                    })
                })
                
                
                
            }
        }
    }
    
    func showPopupInfomation(point : PointLocation,flagEdit: Bool ,blockCallback: @escaping callBack)
    {
        let myAlert = pickUpStoryBoard.instantiateViewController(withIdentifier: "InformationPickUpViewController") as! InformationPickUpViewController
        myAlert.blockCallBack = blockCallback
        myAlert.point = point
        myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(myAlert, animated: false, completion: nil)
    }
    func showPopupBackToPickupInfomation(point : PointLocation,flagEdit: Bool,blockCallback: @escaping callBack)
    {
        let myAlert = pickUpStoryBoard.instantiateViewController(withIdentifier: "DropInformationViewController") as! DropInformationViewController
        myAlert.blockCallBack = blockCallback
        myAlert.point = point
        myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(myAlert, animated: false, completion: nil)
    }
    
}


class DataSender : NSObject
{
    var listLocationSender :[PointLocation]?
    var timeSender = Time()
    var returnToPickupSender = false
}



