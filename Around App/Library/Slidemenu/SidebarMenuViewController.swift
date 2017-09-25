//
//  SidebarMenuViewController.swift
//  Around
//
//  Created by phuc.huynh on 12/20/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import UIKit
import ObjectMapper
class SidebarMenuViewController: StatusbarViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var imageNav: UIImageView!
    @IBOutlet weak var tblView: UITableView!
    var numberLeftMenu: NumberLeftMenu?
    var menuItems: [String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        menuItems = ["thongtinhcanhan", "viaround","theodoihanhtrinh", "lichsudonhang","thongbao", "mauudai", "trothanhshipper","trothanhdoitac"]
//        let bg = UIImageView(image: UIImage(named: "bg_slidemenu"))
//        tblView.backgroundView = bg

        
       // defaultNav.topItem?.title = appDelegate.titleMenu
      //  defaultNav.setBackgroundImage(UIImage(named: "btnchoose2tiengviet"), for: .default)
        
        
       tblView.isScrollEnabled = false
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS
        {
            tblView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)
            if DeviceType.IS_IPHONE_4_OR_LESS
            {
                tblView.isScrollEnabled = true
            }
        }
        else{
            tblView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DataConnect.getOrderNumber(token_API, country_code: kCountryCode, phone: userPhone_API, onsuccess: { (result) in
            self.numberLeftMenu = result as? NumberLeftMenu
            self.tblView.reloadData()
            
        }) { (error) in
            self.tblView.reloadData()
        }
        
        if let isPickup = appDelegate.isPickup
        {
            if isPickup
            {
                imageNav.image = UIImage(named: MCLocalization.string(forKey: "IMAGESLIDEMENU2"))
            }
            else
            {
                imageNav.image = UIImage(named: MCLocalization.string(forKey: "IMAGESLIDEMENU1"))
            }
        }
        else
        {
             imageNav.image = UIImage(named: "slide_choose")
        }
       

    }
    
    @IBAction func btnLogout (_ sender: UIButton)
    {
        tracking(actionKey: "C16.7N")
        customAlertViewWithCancelButton(self, title: MCLocalization.string(forKey: "AREYOUSURE"), btnTitleNameNormal: name_confirm_Button_Normal, btnCancelNameNormal: name_cancel_Button_Normal, titleOrangeButton: "OK", titleGreyButton: MCLocalization.string(forKey: "CANCEL"), isClose: false,blockCallback: {result in
            DataConnect.logoutAPI(kCountryCode,view: self.view,  onsuccess: { (result) in
                defaults.set("", forKey: "token")
                defaults.set("", forKey: "userphone")
                
                let listPoint = [Address().toJSON(),Address().toJSON(),Address().toJSON()]
                defaults.setValue(listPoint, forKey: "locations")
                let hashNumberChat : [String:String] = [:]
                defaults.set(hashNumberChat, forKey: "chatNumber")
                appDelegate.listSelected = []
                appDelegate.setRootViewWhenInvalidToken()
            }, onFailure: { (error) in
                customAlertView(self, title: getErrorStringConfig(code: String(describing: error))! , btnTitleNameNormal: name_confirm_Button_Normal,titleButton: "OK", blockCallback: { (result) in
                })
            })
        }, blockCallbackCancel: {result in
            
            
        })
        
    }
    deinit {
        //print ("sds")
    }
    @IBAction func btnBack (_ sender: UIButton)
    {
        tracking(actionKey: "C16.8N")
        if appDelegate.isPickup == nil
        {
            self.revealViewController().revealToggle(animated: true)
        }
        else
        {
            ((self.revealViewController().frontViewController as! UINavigationController).viewControllers[0] as? MapDirectorViewController)?.googleMapsView?.removeFromSuperview()
            ((self.revealViewController().frontViewController as! UINavigationController).viewControllers[0] as? MapDirectorViewController)?.googleMapsView = nil
            appDelegate.setRootView(isShowFollowJouneyStackScreen: false)
        }

    }
    @IBAction func btnHelp (_ sender: UIButton)
    {
        tracking(actionKey: "C16.7N")
        if Config.sharedInstance.phoneNumberCallCenter != nil
        {
            sender.isEnabled = false
            delayWithSeconds(0.5) {
                sender.isEnabled = true
            }

            callNumber(Config.sharedInstance.phoneNumberCallCenter!) { (result) in
                
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (menuItems?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = menuItems?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier!, for: indexPath) as! slideMenuCell
        cell.selectionStyle = .none
        
//        if indexPath.row != menuItems!.count - 1
//        {
//            let imageSeparator = UIImageView(image: UIImage(named: "otp_line"))
//            imageSeparator.frame = CGRect(x: 0, y: cell.frame.height, width: cell.frame.width, height: 1)
//            cell.contentView.addSubview(imageSeparator)
//        }
        if indexPath.row == 0
        {
            cell.lblTitle.text = MCLocalization.string(forKey: "PROFILE")
        }
        else if indexPath.row == 1
        {
            cell.lblTitle.text = MCLocalization.string(forKey: "AROUNDPAY")
        }
        else if indexPath.row == 2
        {
            if self.numberLeftMenu == nil
            {
                cell.imageCausion.isHidden = true
            }
            else
            {
            if self.numberLeftMenu?.number_order == 0
            {
                cell.imageCausion.isHidden = true
            }
            else
            {
                cell.imageCausion.isHidden = false
            }
            }
            cell.lblTitle.text = MCLocalization.string(forKey: "FOLLOWJOURNEY")
        }
        else if indexPath.row == 3
        {
            cell.lblTitle.text = MCLocalization.string(forKey: "HISTORYORDERS")
        }
        else if indexPath.row == 4
        {
            if self.numberLeftMenu == nil
            {
                cell.imageCausion.isHidden = true
            }
            else
            {
            if (self.numberLeftMenu?.number_event)! + (self.numberLeftMenu?.number_notification)!  == 0
            {
                cell.imageCausion.isHidden = true
            }
            else
            {
                cell.imageCausion.isHidden = false
            }
            }
            cell.lblTitle.text = MCLocalization.string(forKey: "THONGBAO")
        }
        else if indexPath.row == 5
        {
            cell.lblTitle.text = MCLocalization.string(forKey: "PROMOTIONCODE")
        }
        else if indexPath.row == 6
        {
            cell.lblTitle.text = MCLocalization.string(forKey: "TOBECOMESHIPPER")
        }
        else if indexPath.row == 7
        {
            cell.lblTitle.text = MCLocalization.string(forKey: "TOBECOMESUPLIER")
        }
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS
        {
            return 45
        }
        else{
            return 55
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5, animations: {
            self.revealViewController().revealToggle(animated: true)
        }) { (result) in
            if indexPath.row == 0
            {
                tracking(actionKey: "C16.1Y")
                let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
               
                self.present(vc, animated: true, completion: nil)
            }
            else if indexPath.row == 1
            {
                tracking(actionKey: "C16.2Y")
                DataConnect.getAroundPay_(token_API, country_code: kCountryCode, phone: userPhone_API,view: self.view,  onsuccess: { (result) in
                    let cash = result as? Double
                    let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "ViAroundViewController") as! ViAroundViewController
                    vc.money = cash
                    self.present(vc, animated: true, completion: nil)

                    
                }) { (error) in
                    showErrorMessage(error: error as! Int, vc: self)
                }
            }
            else if indexPath.row == 2
            {
                tracking(actionKey: "C16.3Y")
                let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "FollowJourneyStackViewController") as! FollowJourneyStackViewController
                let nav = UINavigationController(rootViewController: vc)
                self.present(nav, animated: true, completion: nil)
            }
            else if indexPath.row == 3
            {
                tracking(actionKey: "C16.4Y")
                let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "OrderHistoryViewController") as! OrderHistoryViewController
                vc.blockcallBack = self.revealViewController().callbackHistoryOrder
                let nav = UINavigationController(rootViewController: vc)
                self.present(nav, animated: true, completion: nil)
            }
            else if indexPath.row == 4
            {
                tracking(actionKey: "C16.5Y")
                let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "SubNotificationViewController") as! SubNotificationViewController
                 let nav = UINavigationController(rootViewController: vc)
                
                self.present(nav, animated: true, completion: nil)
            }
            else if indexPath.row == 5
            {
                tracking(actionKey: "C16.5Y")
                let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "PromotionViewController") as! PromotionViewController
                let nav = UINavigationController(rootViewController: vc)
                self.present(nav, animated: true, completion: nil)
            }
            else if indexPath.row == 6
            {
                tracking(actionKey: "C16.6Y")
                let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "SignUpToShipViewController") as! SignUpToShipViewController
                self.present(vc, animated: true, completion: nil)
            }
            else if indexPath.row == 7
            {
                let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "ToBeSupplierViewController") as! ToBeSupplierViewController
                self.present(vc, animated: true, completion: nil)
            }

        }
    }
}

class slideMenuCell : UITableViewCell
{
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imageCausion: UIImageView!
}
