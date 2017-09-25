//
//  FullOrderViewController.swift
//  Shipper
//
//  Created by phuc.huynh on 3/7/17.
//  Copyright © 2017 phuc.huynh. All rights reserved.
//

import UIKit

class FullOrderSubViewController: StatusbarViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var constrainsHeightTableview: NSLayoutConstraint!
    
    @IBOutlet weak var constrainsNote: NSLayoutConstraint!
    @IBOutlet weak var constrainstopNote: NSLayoutConstraint!
    @IBOutlet weak var constrainsBottomNote: NSLayoutConstraint!
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var viewNote: UIView!
    @IBOutlet weak var sidebarButton: UIBarButtonItem!
    @IBOutlet weak var lblTenCuahangLayout: UILabel!
    @IBOutlet weak var lblTenCuahangContent: UILabel!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnLocation1: UIButton!
    @IBOutlet weak var btnLocation2: UIButton!
    @IBOutlet weak var btnLocation3: UIButton!
    @IBOutlet weak var lblNote: UILabel!
    
    //viewNhanHang
    @IBOutlet weak var lblNoteDrop: UILabel!
    @IBOutlet weak var lblNguoinhan: UILabel!
    @IBOutlet weak var btnNguoinhan: UIButton!
    //@IBOutlet weak var constrainsnguoinhan: NSLayoutConstraint!
    @IBOutlet weak var constrainsNoteNguoinhan: NSLayoutConstraint!
   // @IBOutlet weak var constrainstopNotenguoinhan: NSLayoutConstraint!
  //  @IBOutlet weak var constrainsBottomNotenguoinhan: NSLayoutConstraint!
    //////////
     @IBOutlet weak var viewNoteNguoiNhan: UIView!
    @IBOutlet weak var contrainstopNotenguoinhan: NSLayoutConstraint!

    @IBOutlet weak var constrainBottomNotenguoinhan: NSLayoutConstraint!
    @IBOutlet weak var lblAddressNhanHang: UILabel!
    @IBOutlet weak var lblAddressLayHang: UILabel!
    @IBOutlet weak var lblOrderID: UILabel!
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imageViewPayment: UIButton!
    @IBOutlet weak var lblPayment: UILabel!
    @IBOutlet weak var lblItemCost: UILabel!
    @IBOutlet weak var lblServiceFee: UILabel!
    @IBOutlet weak var lblShippingFee: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblItemCostLayout: UILabel!
    @IBOutlet weak var constrainsItemCostHeight: NSLayoutConstraint!
    //@IBOutlet weak var constrainsheightRecieptName: NSLayoutConstraint!
    @IBOutlet weak var constrainsItemCostTop: NSLayoutConstraint!
    @IBOutlet weak var imageLocation: UIImageView!
    var phoneNumberNguoiLienHe:String?
     var phoneNumberNguoiNhan:String?
    var listTableViewData :[LocationItem] = []
    var listLocation: [FullOrderLocation] = []
    var results : FullOrder?
    var flagFollowJourney : Bool?
    var id_order: Int?
    var indexSelectChoose = 0
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    var flagReconectSocketFromBackground = false
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewWhiteFirst = UIView(frame: CGRect(x: 0, y: 64, width: ScreenSize.SCREEN_WIDTH, height: ScreenSize.SCREEN_HEIGHT - 64))
        viewWhiteFirst.backgroundColor = UIColor.white
        self.view.addSubview(viewWhiteFirst)
        self.sidebarButton.action = #selector(self.back)
        if flagFollowJourney == true
        {
            blockCallBackFromSmartFox()
        }
        DataConnect.getFullOrder(token_API, country_code: kCountryCode, phone: userPhone_API, id_order: id_order! ,view: viewWhiteFirst, onsuccess: { (result) in
            self.results = result as? FullOrder
            self.btnTab(self.btnLocation1)
            if (self.results?.show_gift)!
            {
                self.lblItemCostLayout.text = MCLocalization.string(forKey: "ITEMCOST")
                self.constrainsItemCostHeight.constant = 17
                self.constrainsItemCostTop.constant = 8
            }
            else{
                for item in (self.results?.locations)!
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
            }
            
        }) { (error) in
            showErrorMessage(error: error as! Int, vc: self)
        }
        
        
    }

    override func viewDidLayoutSubviews() {
        
        btnLocation1.roundCorners([.topLeft,.bottomLeft], radius: 3.0)
        btnLocation3.roundCorners([.topRight,.bottomRight], radius: 3.0)
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector:  #selector(applicationDidBecomeActive),
                                               name: NSNotification.Name.UIApplicationDidBecomeActive,
                                               object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    func applicationDidBecomeActive()
    {
        if flagReconectSocketFromBackground{
            flagReconectSocketFromBackground = false
            reConnectedSmartFox()
        }
    }
    func blockCallBackFromSmartFox()
    {
        SmartFoxObject.sharedInstance.blockCallBack = {
            (type,result) in
            if type == kCmdDisconnect
            {
                if UIApplication.shared.applicationState == .active
                {
                    self.reConnectedSmartFox()
                }
                else
                {
                    self.flagReconectSocketFromBackground = true
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
                param?.putInt("id_order", value: self.id_order!)
                SmartFoxObject.sharedInstance.sendExtendsionRequest(kExtCmd, param: param, isNeedShowLoading: true)
            }
            else if type == kcmdGetFollowJourney
            {
                print("reconnect")
            }
            else if type == kCmdFinish
            {
                customAlertView(self, title: MCLocalization.string(forKey: "SHIPPERFINISH", withPlaceholders: ["%name%" : String(describing: result as! String)]), btnTitleNameNormal: name_confirm_Button_Normal,titleButton: "OK",blockCallback: {
                    result in
                    let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "RateUsViewController") as! RateUsViewController
                    vc.order_id = self.id_order
                    self.present(vc, animated: true, completion: nil)
                    
                })
            }
            else if type == kCmdCancelOrder
            {
                customAlertView(self, title:MCLocalization.string(forKey: "SHIPPERCANCEL", withPlaceholders: ["%name%" : String(describing: result as! String)]), btnTitleNameNormal: name_confirm_Button_Normal,titleButton: "OK",blockCallback: {result in
                    appDelegate.setRootView(isShowFollowJouneyStackScreen: false)
                })
                
            }
            else if type == kCmdError
            {
                customAlertView(self, title: getErrorStringConfig(code: String(describing: result as! Int))! , btnTitleNameNormal: name_confirm_Button_Normal, titleButton: "OK", blockCallback: { (result) in
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
    
    func back()
    {
        self.navigationController?.popViewController(animated: true)
    }
    func prepareData(results: FullOrder, index : Int)
    {
        let day =  formatDateWithFormat(day: results.delivery_day!, month: results.delivery_month!, year: results.delivery_year!, formatString: "dd MMMM, yyyy")
        let time = formatTimeWithFormat(min: results.delivery_minute!, hour: results.delivery_hour!, formatString: "h:mm a")
        self.lblTime.text = time + " " +  day
        self.lblOrderID.text = MCLocalization.string(forKey: "ORDERID", withPlaceholders: ["%name%" : results.order_code!])
        self.listTableViewData.removeAll()
        self.listLocation.removeAll()
        self.listLocation = results.locations
        self.lblAddressLayHang.text = results.locations[index].address
        phoneNumberNguoiLienHe = results.locations[index].phone
       
        self.lblTenCuahangContent.text = results.locations[index].recipent_name
        if phoneNumberNguoiLienHe == ""
        {
           // ic_call-now_Off
            self.btnCall.setImage(UIImage(named:"ic_call-now_Off"), for: .normal)
        }
        else
        {
            self.btnCall.setImage(UIImage(named:"ic_call-now"), for: .normal)
            self.btnCall.addTarget(self, action: #selector(self.btnCallClick), for: .touchUpInside)
        }
        
        
        if results.locations[index].note == "" ||  results.locations[index].note == nil
        {
            self.constrainsNote.constant = 0
            self.constrainstopNote.constant = 0
            self.constrainsBottomNote.constant = 0
            self.viewNote.isHidden = true
        }
        else
        {
            self.constrainsNote.constant = 18
            self.constrainstopNote.constant = 8
            self.constrainsBottomNote.constant = 10
            self.viewNote.isHidden = false
        }
        
        self.lblNote.text = results.locations[index].note
        self.lblAddressNhanHang.text = results.locations.last?.address
        
        self.lblNguoinhan.text = results.locations.last?.recipent_name
        phoneNumberNguoiNhan = results.locations.last?.phone
        self.lblNoteDrop.text = results.locations.last?.note
        if phoneNumberNguoiNhan == ""
        {
            // ic_call-now_Off
            self.btnNguoinhan.setImage(UIImage(named:"ic_call-now_Off"), for: .normal)
        }
        else
        {
            self.btnNguoinhan.setImage(UIImage(named:"ic_call-now"), for: .normal)
            self.btnNguoinhan.addTarget(self, action: #selector(self.btnCallNGUOINHANClick), for: .touchUpInside)
        }
        
        if results.locations.last?.note == "" ||  results.locations.last?.note == nil
        {
            self.constrainsNoteNguoinhan.constant = 0
            self.contrainstopNotenguoinhan.constant = 0
            self.constrainBottomNotenguoinhan.constant = 0
            self.viewNoteNguoiNhan.isHidden = true
        }
        else
        {
            self.constrainsNoteNguoinhan.constant = 18
            self.contrainstopNotenguoinhan.constant = 8
            self.constrainBottomNotenguoinhan.constant = 10
           self.viewNoteNguoiNhan.isHidden = false
        }
        
        self.lblShippingFee.text = NSString(format: "%@đ",setCommaforNumber(results.shipping_fee!)) as String
        self.lblItemCost.text = NSString(format: "%@đ",setCommaforNumber(results.item_cost!)) as String
        self.lblServiceFee.text = NSString(format: "%@đ",setCommaforNumber(results.service_fee!)) as String
        self.lblTotal.text = NSString(format: "%@đ", setCommaforNumber(results.total!)) as String
        self.lblCode.text = results.verify_code
        
        if results.payment_type == "ONLINE"
        {
            self.imageViewPayment.setImage(UIImage(named:"Thanh-toan-online-1"), for: .normal)
            self.lblPayment.text = MCLocalization.string(forKey: "ONLINEPAYMENT")
        }
        else  if results.payment_type == "CASH"
        {
            self.imageViewPayment.setImage(UIImage(named:"tienmat-1"), for: .normal)
            self.lblPayment.text = MCLocalization.string(forKey: "CASH")
        }
        else  if results.payment_type == "AROUND_PAY"
        {
            self.imageViewPayment.setImage(UIImage(named:"Vi-around-1"), for: .normal)
            self.lblPayment.text = MCLocalization.string(forKey: "AROUNDPAY")
        }
        
        for item in (results.locations[index].location_items?.enumerated())!
        {
            item.element.indexItemname = item.offset + 1
            self.listTableViewData.append(item.element)
        }
        if self.results?.locations.count == 3
        {
            btnLocation3.isEnabled = false
            btnLocation3.alpha = 0.5
        }
        else if self.results?.locations.count == 2
        {
            btnLocation2.isEnabled = false
            btnLocation3.isEnabled = false
            btnLocation2.alpha = 0.5
            btnLocation3.alpha = 0.5
        }
        
        if results.show_gift! {
            navItem.title = MCLocalization.string(forKey: "FULLORDERGIFTING")
            constrainsHeightTableview.constant = CGFloat((listTableViewData.count - 1) * 71 + 95)
            lblTenCuahangLayout.text = MCLocalization.string(forKey: "TENSHOP")
            self.view.layoutIfNeeded()
            tblView.reloadData()
        }else
        {
            navItem.title = MCLocalization.string(forKey: "FULLORDERPICKUP")
            
            lblTenCuahangLayout.text = MCLocalization.string(forKey:"RECIPENTNAME")
            tblView.rowHeight = UITableViewAutomaticDimension
            tblView.estimatedRowHeight = 300
            self.tblView.reloadData()
        }
        self.view.layoutIfNeeded()
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
        
        if (self.results?.show_gift)!
        {
            if MCLocalization.sharedInstance().language == "en" {
                myAlert.imageURL = Config.sharedInstance.imagePrice_ServiceGiftingTA
            }
            else{
                myAlert.imageURL = Config.sharedInstance.imagePrice_ServiceGiftingTV
            }
        }
        else
        {
            if MCLocalization.sharedInstance().language == "en" {
                myAlert.imageURL = Config.sharedInstance.imagePrice_ServicePickupTA
            }
            else{
                myAlert.imageURL = Config.sharedInstance.imagePrice_ServicePickupTV
            }
        }

        myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(myAlert, animated: false, completion: nil)
    }

    func dissmissViewController()
    {
        
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnTab (_ sender: UIButton?)
    {
        if sender == btnLocation1
        {
            indexSelectChoose = 0
            btnLocation1.setTitleColor(UIColor.white, for: .normal)
            btnLocation2.setTitleColor(UIColor(hex:colorXam), for: .normal)
            btnLocation3.setTitleColor(UIColor(hex:colorXam), for: .normal)
            btnLocation1.backgroundColor = UIColor(hex: colorCam)
            btnLocation2.backgroundColor = .clear
            btnLocation3.backgroundColor =  .clear
            imageLocation.image = UIImage(named:"location1")
            self.prepareData(results: self.results!, index: 0)
            
        }
        else if sender == btnLocation2
        {
            indexSelectChoose = 1
            btnLocation2.setTitleColor(UIColor.white, for: .normal)
            btnLocation1.setTitleColor(UIColor(hex:colorXam), for: .normal)
            btnLocation3.setTitleColor(UIColor(hex:colorXam), for: .normal)
            btnLocation2.backgroundColor = UIColor(hex: colorCam)
            btnLocation1.backgroundColor = .clear
            btnLocation3.backgroundColor =  .clear
            imageLocation.image = UIImage(named:"location2")
            self.prepareData(results: self.results!, index: 1)
        }
        else if sender == btnLocation3
        {
            indexSelectChoose = 2
            btnLocation3.setTitleColor(UIColor.white, for: .normal)
            btnLocation1.setTitleColor(UIColor(hex:colorXam), for: .normal)
            btnLocation2.setTitleColor(UIColor(hex:colorXam), for: .normal)
            btnLocation3.backgroundColor = UIColor(hex: colorCam)
            btnLocation1.backgroundColor = .clear
            btnLocation2.backgroundColor =  .clear
            imageLocation.image = UIImage(named:"location3")
            self.prepareData(results: self.results!, index: 2)
        }
    }
    
    func showPopUpPaymentType(fullOrder : FullOrder,id_order:Int,blockCallback: @escaping callBack)
    {
        let myAlert = pickUpStoryBoard.instantiateViewController(withIdentifier: "UpdatePaymentTypeViewController") as! UpdatePaymentTypeViewController
        myAlert.blockCallBack = blockCallback
        myAlert.fullOrder = fullOrder
        myAlert.id_order = id_order
        myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(myAlert, animated: false, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listTableViewData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (self.results?.show_gift)!{
            if indexPath.row == 0
            {
                return 95
            }
            else
            {
                return 71
            }
        }
        else
        {
            return UITableViewAutomaticDimension
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (results?.show_gift)!
        {
            let cell = self.tblView.dequeueReusableCell(withIdentifier: "FullOrderItem") as! FullOrderItem
            let obj = listTableViewData[indexPath.row]
            if obj.is_gift == true{
                cell.imageGift.image = UIImage(named: "gift_cart_cam")
                cell.lblGift.textColor = UIColor(hex: colorCam)
                cell.lblGift.text = MCLocalization.string(forKey: "GOIQUA") + Config.sharedInstance.giftbox_fee!
            }
            else
            {
                cell.imageGift.image = UIImage(named: "gift_cart_xam")
                cell.lblGift.textColor = UIColor(hex: colorXam)
                cell.lblGift.text = MCLocalization.string(forKey: "GOIQUA")
            }
            cell.lblSoLuong.text = MCLocalization.string(forKey: "SOLUONG") + String(format: " %d", obj.item_quantity!)
            if let url = URL(string: (obj.item_image!)),let placeholder = UIImage(named: "default_product") {
                cell.imageProduct.sd_setImageWithURLWithFade(url, placeholderImage: placeholder)
            }
            cell.lblItemnameContent.text = obj.item_name
            if indexPath.row != 0
            {
                cell.lblItemName.isHidden = true
                cell.constrainlblItemName.constant = 0
                cell.constrainlblItemNameTop.constant = 0
                self.view.layoutIfNeeded()
            }
            else{
                cell.lblItemName.isHidden = false
                cell.constrainlblItemName.constant = 18
                cell.constrainlblItemNameTop.constant = 6
                self.view.layoutIfNeeded()
            }
            return cell
            
        }
        else
        {
            let cell = self.tblView.dequeueReusableCell(withIdentifier: "FullOrderItemPickUp") as! FullOrderItemPickUp
            let obj = listTableViewData[indexPath.row]
            cell.lblTenMonHanContent.text = obj.item_name
            
            cell.lblMoney.text = String(format: "%@đ",setCommaforNumber(obj.item_cost!))
            if results?.locations[indexSelectChoose].pickup_type == 1
            {
                cell.lblMuaHo.text = MCLocalization.string(forKey: "VANCHUYEN").uppercased()
            }
            else if results?.locations[indexSelectChoose].pickup_type == 2
            {
                cell.lblMuaHo.text = MCLocalization.string(forKey: "MUAHO").uppercased()
            }
            else if results?.locations[indexSelectChoose].pickup_type == 3
            {
                cell.lblMuaHo.text = MCLocalization.string(forKey: "THUHO").uppercased()
            }
            
            return cell
            
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (tableView.indexPathsForVisibleRows!.last! as NSIndexPath).row {
            // End of loading
            self.constrainsHeightTableview.constant = self.tblView.contentSize.height
            self.view.layoutIfNeeded()
            
        }
    }
    
    
    func btnCallClick() {
        btnCall.isEnabled = false
        delayWithSeconds(0.5) {
            self.btnCall.isEnabled = true
        }
        callNumber(self.phoneNumberNguoiLienHe!) { (result) in
        }
        
    }
    func btnCallNGUOINHANClick() {
        btnNguoinhan.isEnabled = false
        delayWithSeconds(0.5) {
            self.btnNguoinhan.isEnabled = true
        }
        callNumber(self.phoneNumberNguoiNhan!) { (result) in
        }
        
    }
}

class FullOrderContentCell : UITableViewCell
{
    static let identifier = "FullOrderCellContent"
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblHour: UILabel!
    @IBOutlet weak var lblPaymentType: UILabel!
    @IBOutlet weak var imageCardOnline: UIImageView!
    @IBOutlet weak var imageGift: UIImageView!
    @IBOutlet weak var txtDateHour: UITextField!
    @IBOutlet weak var viewDateHour: UIView!
    @IBOutlet weak var imageCalendar: UIImageView!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var lblOrderID: UILabel!
}


class FullOrderItem : UITableViewCell
{
    static let identifier = "FullOrderItem"
    @IBOutlet weak var lblItemnameContent: UILabel!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var constrainlblItemName: NSLayoutConstraint!
    @IBOutlet weak var constrainlblItemNameTop: NSLayoutConstraint!
    @IBOutlet weak var imageGift: UIImageView!
    @IBOutlet weak var lblGift: UILabel!
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var lblSoLuong: UILabel!
}
class FullOrderItemPickUp : UITableViewCell
{
    static let identifier = "FullOrderItemPickUp"
    @IBOutlet weak var lblTenMonHangLayout: UILabel!
    @IBOutlet weak var lblTenMonHanContent: UILabel!
    @IBOutlet weak var lblMuaHo: UILabel!
    @IBOutlet weak var lblMoney: UILabel!
}
class FullOrderRecieptName : UITableViewCell
{
    static let identifier = "FullOrderRecieptName"
    @IBOutlet weak var lblRecieptNameContent: UILabel!
    @IBOutlet weak var lblRecieptName: UILabel!
    @IBOutlet weak var btnCall: UIButton!
}
class FullOrderNote : UITableViewCell
{
    static let identifier = "FullOrderNote"
    @IBOutlet weak var lblNote: UILabel!
}
class FullOrderLocationCell : UITableViewCell
{
    static let identifier = "suggestionCell"
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    @IBOutlet weak var viewIcon: UIView!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var txtPickup: BottomLineTextfield!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var viewDrop: UIView!
    @IBOutlet weak var imageViewIcon: UIImageView!
    
    func prepareCell(role: Int, index: Int, address: String,list : [AnyObject],indexSelectChoose: Int)
    {
        viewIcon.backgroundColor = UIColor.clear
        viewDrop.backgroundColor = UIColor.clear
        imageViewIcon.isHidden = false
        lblNumber.text = String(format: "%d", index+1)
        
        if index == 0
        {
            topLine.isHidden = true
        }else
        {
            topLine.isHidden = false
        }
        if index == indexSelectChoose
        {
            self.lblNumber.font = UIFont(name: "OpenSans-Bold", size: 8)
            self.txtPickup.font = UIFont(name: "OpenSans-Bold", size: 14)
        }
        else
        {
            self.lblNumber.font = UIFont(name: "OpenSans", size: 8)
            self.txtPickup.font = UIFont(name: "OpenSans", size: 14)
        }
        if role == 0
        {
            txtPickup.useUnderlineWithColor(color: UIColor(hex: colorCam))
            txtPickup.settextColor(color: UIColor(hex: colorCam))
            if  address == ""
            {
                txtPickup.attributedPlaceholder = NSAttributedString(string: MCLocalization.string(forKey: "PICKUPWHERE"),
                                                                     attributes: [NSForegroundColorAttributeName: UIColor(hex: colorXam)])
                txtPickup.text = ""
            }
            else
            {
                txtPickup.text = address
            }
            bottomLine.isHidden = false
            if (list[index+1] as! FullOrderLocation).role == 3
            {
                bottomLine.backgroundColor = UIColor(hex: colorXam)
            }
            else
            {
                bottomLine.backgroundColor = UIColor(hex: colorCam)
            }
            
        }
        else if role == 3
        {
            imageViewIcon.isHidden = true
            viewDrop.backgroundColor = UIColor.gray
            lblNumber.text = ""
            txtPickup.useUnderlineWithColor(color: UIColor(hex: colorXam))
            txtPickup.settextColor(color: UIColor(hex: colorXam))
            if  address == ""
            {
                txtPickup.attributedPlaceholder = NSAttributedString(string: MCLocalization.string(forKey: "NHAPDIADIEMNHAN"),
                                                                     attributes: [NSForegroundColorAttributeName: UIColor(hex: colorXam)])
                
                txtPickup.text = ""
            }
            else
            {
                txtPickup.text = address
            }
            
            topLine.backgroundColor = UIColor(hex: colorXam)
            bottomLine.isHidden = true
            
            
        }
        else{
            txtPickup.useUnderlineWithColor(color: UIColor(hex: colorCam))
            txtPickup.settextColor(color: UIColor(hex: colorCam))
            if  address == ""
            {
                txtPickup.attributedPlaceholder = NSAttributedString(string: MCLocalization.string(forKey: "PICKUPMORE"),
                                                                     attributes: [NSForegroundColorAttributeName: UIColor(hex: colorXam)])
                txtPickup.text = ""
            }
            else
            {
                txtPickup.text = address
            }
            bottomLine.isHidden = false
            if (list[index+1] as! FullOrderLocation).role == 3
            {
                topLine.backgroundColor = UIColor(hex: colorCam)
                bottomLine.backgroundColor = UIColor(hex: colorXam)
            }
            else
            {
                topLine.backgroundColor = UIColor(hex: colorCam)
                bottomLine.backgroundColor = UIColor(hex: colorCam)
            }
            
        }
        
        
        
    }
    
}
class RecieptNameObject : NSObject
{
    var recieptName: String?
    var phone : String?
}
class RecieptNoteObject : NSObject
{
    var note: String?
    var phone : String?
}
