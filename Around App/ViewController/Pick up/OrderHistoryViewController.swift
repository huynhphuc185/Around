//
//  OrderHistoryViewController.swift
//  Around
//
//  Created by phuc.huynh on 11/23/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import UIKit

class OrderHistoryViewController: StatusbarViewController{
    var listHistory:ListHistoryObject?
    var blockcallBack : CallBackHistoryOrder!
    @IBOutlet weak var sidebarButton: UIBarButtonItem!
    @IBOutlet weak var tblViewHistory  : UITableView!
    @IBOutlet weak var viewEmpty  : UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sidebarButton.action = #selector(self.dissmissViewController)
        DataConnect.getOrderHistory(token_API, country_code: kCountryCode, phone: userPhone_API, type: "HISTORY",view: self.view,  onsuccess: { data in
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
    func dissmissViewController()
    {
        tracking(actionKey: "C19.2N")
        self.dismiss(animated: true) {
            //self.blockcallBack(self.listHistory)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
extension OrderHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listHistory == nil
        {
            return 0
        }
        else
        {
            return (listHistory?.data?.count)!
            
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblViewHistory.dequeueReusableCell(withIdentifier: "OrderHistoryCell") as! OrderHistoryCell
        cell.selectionStyle = .none
        let obj = listHistory?.data?[indexPath.row]
        cell.lblPickupType.text = obj?.strPickupType?.uppercased()
        // cell.lblPickupType.text = "VẬN CHUYỂN-VẬN CHUYỂN- VẬN CHUYỂN"
        cell.lbltotalMoney.text = (obj?.total?.stringFormattedWithSeparator)! + "đ"
        let dateOrder = obj?.create_date?.toDateTime(dateFormatStr: "yyyy-MM-dd HH:mm:ss")
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: dateOrder!)
        let minutes = calendar.component(.minute, from: dateOrder!)
        let day = calendar.component(.day, from: dateOrder!)
        let month = calendar.component(.month, from: dateOrder!)
        let year = calendar.component(.year, from: dateOrder!)
        cell.lblDate.text = formatDate(day: day, month: month, year: year)
        cell.lblTime.text = formatTime(min: minutes, hour: hour)
        cell.btnDatlai.tag = indexPath.row
        cell.lblOrderID.text = obj?.order_code

        if obj?.status == -1
        {
            cell.btnStatus.setTitle( MCLocalization.string(forKey: "CANCELLED"), for: .normal)
            
            cell.btnStatus.setTitleColor(UIColor.red, for: .normal)
        }
        else
        {
            cell.btnStatus.setTitle( MCLocalization.string(forKey: "FINISHED"), for: .normal)
            cell.btnStatus.setTitleColor(UIColor(hex: "#3ea00d"), for: .normal)
        }
        if obj?.type == "GIFTING"{
            cell.constrainsspaceBtnDatlai.constant = 0
            cell.constrainsWidthBtnDatlai.constant = 0
            cell.constrainsWidthCenter.constant = 100
            cell.viewTypeService.backgroundColor = UIColor(hex: "f7bd00")
            cell.imageService.image = UIImage(named: "qua-tang")
        }
        else
        {
            cell.constrainsspaceBtnDatlai.constant = 20
            cell.constrainsWidthBtnDatlai.constant = 90
            cell.constrainsWidthCenter.constant = 200
            cell.viewTypeService.backgroundColor = UIColor(hex: colorCam)
            cell.imageService.image = UIImage(named: "xe")
        }
        cell.contentView.layoutIfNeeded()
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tracking(actionKey: "C19.1Y")
        let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "FullOrderSubViewController") as! FullOrderSubViewController
        vc.id_order = listHistory?.data?[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)

    }
    @IBAction func btnDatlai(_ sender: UIButton){
        self.dismiss(animated: true) {
            if self.blockcallBack != nil
            {
                self.blockcallBack(self.listHistory?.data?[sender.tag])
            }
        }
        
    }
}
