//
//  OrderHistoryViewController.swift
//  Around
//
//  Created by phuc.huynh on 11/23/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import UIKit

class FollowJourneyStackViewController: StatusbarViewController{
    var listHistory:ListHistoryObject?
    var order_id : Int?
    @IBOutlet weak var sidebarButton: UIBarButtonItem!
    @IBOutlet weak var tblViewHistory  : UITableView!
    @IBOutlet weak var viewEmpty  : UIView!
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sidebarButton.action = #selector(self.dismissViewControllerWithDisconnectSmartFox)
        DataConnect.getOrderHistory(token_API, country_code: kCountryCode, phone: userPhone_API, type: "PROCESS", view: self.view, onsuccess: { data in
            if let result = data as? ListHistoryObject
            {
                if result.data?.count == 0
                {
                    self.tblViewHistory.isHidden = true
                    self.viewEmpty.isHidden = false
                }
                else
                {
                    self.tblViewHistory.isHidden = false
                    self.viewEmpty.isHidden = true
                    self.listHistory = result
                    
                    for obj in (self.listHistory?.data)!
                    {
                        var typeString = ""
                        for item in (obj.order_type)!
                        {
                            
                            if item == 0
                            {
                                typeString = MCLocalization.string(forKey: "FULLORDERGIFTING")
                            }
                            else
                            {
                                if item == 1
                                {
                                    if typeString == ""
                                    {
                                        typeString = typeString.appending(MCLocalization.string(forKey: "VANCHUYEN"))
                                    }
                                    else
                                    {
                                        typeString = typeString.appending( " - " + MCLocalization.string(forKey: "VANCHUYEN"))
                                    }

                                }
                                else if item == 2
                                {
                                    if typeString == ""
                                    {
                                        typeString = typeString.appending(MCLocalization.string(forKey: "MUAHO"))
                                    }
                                    else
                                    {
                                        typeString = typeString.appending( " - " + MCLocalization.string(forKey: "MUAHO"))
                                    }
                                    
                                }
                                else if item == 3
                                {
                                    if typeString == ""
                                    {
                                        typeString = typeString.appending(MCLocalization.string(forKey: "THUHO"))
                                    }
                                    else
                                    {
                                        typeString = typeString.appending( " - " + MCLocalization.string(forKey: "THUHO"))
                                    }
                                    
                                }
                            }
                        }
                        obj.strPickupType = typeString
                    }
                    self.tblViewHistory.reloadData()
                }
                
            }
        }) { error in
            showErrorMessage(error: error as! Int, vc: self)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        blockCallBackFromSmartFox()
    }
    
    func blockCallBackFromSmartFox()
    {
        SmartFoxObject.sharedInstance.blockCallBack = {
            (type,result) in
            if type == kCmdConnectedSuccess
            {
                self.backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: {
                    UIApplication.shared.endBackgroundTask(self.backgroundTaskIdentifier!)
                })
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
                if appDelegate.order_id_following == self.order_id
                {
                    self.dismiss(animated: true, completion: nil)
                }
                else
                {
                    let objFollowJourney = result as! FollowJourneyObject
                    let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "FollowJouneyMapViewController") as! FollowJouneyMapViewController
                    vc.listPoint = objFollowJourney.locations
                    vc.senderShipper = objFollowJourney.shipper
                    vc.flagFromSlideMenu = true
                    vc.order_id = self.order_id
                    self.navigationController?.pushViewController(vc, animated: true)

                }
            }
            else if type == kCmdError
            {
                customAlertView(self, title: getErrorStringConfig(code: String(describing: result as! Int))! , btnTitleNameNormal: name_confirm_Button_Normal,titleButton: "OK",  blockCallback: { (result) in
                })
                
            }
            else if type == kCmdCancelOrder
            {
                self.tblViewHistory.reloadData()
            }
            else if type == kCmdFinish
            {
                self.tblViewHistory.reloadData()
            }
        }
    }
    
    func dismissViewControllerWithDisconnectSmartFox()
    {
        self.dismiss(animated: true) {
           // SmartFoxObject.sharedInstance.disConnected()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
extension FollowJourneyStackViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listHistory == nil
        {
            return 0
        }
        else
        {
             return listHistory!.data!.count
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblViewHistory.dequeueReusableCell(withIdentifier: "OrderHistoryCell") as! OrderHistoryCell
        cell.selectionStyle = .none
        let obj = listHistory?.data?[indexPath.row]
       // cell.lblDistance.text = String(format: "%.2f km", (obj?.distance!)!)
        
        cell.lblPickupType.text = obj?.strPickupType?.uppercased()
        cell.lbltotalMoney.text = (obj?.total?.stringFormattedWithSeparator)! + "đ"
        cell.btnStatus.tag = indexPath.row
        
        let dateOrder = obj?.create_date?.toDateTime(dateFormatStr: "yyyy-MM-dd HH:mm:ss")
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: dateOrder!)
        let minutes = calendar.component(.minute, from: dateOrder!)
        let day = calendar.component(.day, from: dateOrder!)
        let month = calendar.component(.month, from: dateOrder!)
        let year = calendar.component(.year, from: dateOrder!)
        cell.lblDate.text = formatDate(day: day, month: month, year: year)
        cell.lblTime.text = formatTime(min: minutes, hour: hour)
        cell.lblOrderID.text = obj?.order_code
        if obj?.status == -1
        {
            cell.btnStatus.setTitle( MCLocalization.string(forKey: "CANCELLED"), for: .normal)
            cell.btnStatus.setTitleColor(UIColor.red, for: .normal)
        }
        else if obj?.status == -2
        {
            cell.btnStatus.setTitle( MCLocalization.string(forKey: "SCHEDULED"), for: .normal)
            cell.btnStatus.setTitleColor( UIColor(hex: "FF9800"), for: .normal)
        }
            
        else if obj?.status == 1
        {
            cell.btnStatus.setTitle( MCLocalization.string(forKey: "FINISHED"), for: .normal)

             cell.btnStatus.setTitleColor( UIColor(hex: "3ea00d"), for: .normal)
        }
        else if obj?.status == 0
        {
            cell.btnStatus.setTitle( MCLocalization.string(forKey: "INPROGRESSING"), for: .normal)
             cell.btnStatus.setTitleColor( UIColor(hex: "f6dc00"), for: .normal)
        }
        if obj?.type == "GIFTING"{
            cell.viewTypeService.backgroundColor = UIColor(hex: "f7bd00")
            cell.imageService.image = UIImage(named: "qua-tang")
        }
        else
        {
            cell.viewTypeService.backgroundColor = UIColor(hex: colorCam)
            cell.imageService.image = UIImage(named: "xe")
        }

        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if listHistory?.data?[indexPath.row].status == 0
        {
            self.order_id = listHistory?.data?[indexPath.row].id
            if appDelegate.order_id_following == self.order_id
            {
                if  SmartFoxObject.sharedInstance.smartFox != nil && SmartFoxObject.sharedInstance.smartFox.isConnected != true
                {
                    SmartFoxObject.sharedInstance.connectedToSmartfox()
                }
                else
                {
                    let param = SFSObject.newInstance()
                    param?.putUtfString("command", value: kcmdGetFollowJourney)
                    param?.putInt("id_order", value: self.order_id!)
                    SmartFoxObject.sharedInstance.sendExtendsionRequest(kExtCmd, param: param, isNeedShowLoading: true)
                    
                }
            }
            else
            {
                if  SmartFoxObject.sharedInstance.smartFox != nil && SmartFoxObject.sharedInstance.smartFox.isConnected != true
                {
                    SmartFoxObject.sharedInstance.connectedToSmartfox()
                }
                else
                {
                    let param = SFSObject.newInstance()
                    param?.putUtfString("command", value: kcmdGetFollowJourney)
                    param?.putInt("id_order", value: self.order_id!)
                    SmartFoxObject.sharedInstance.sendExtendsionRequest(kExtCmd, param: param, isNeedShowLoading: true)
                    
                }
            }
        }
        else if listHistory?.data?[indexPath.row].status == -2
        {
            let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "FullOrderSubViewController") as! FullOrderSubViewController
            vc.id_order = listHistory?.data?[indexPath.row].id
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
