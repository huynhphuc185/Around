//
//  OrderHistoryViewController.swift
//  Around
//
//  Created by phuc.huynh on 11/23/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import UIKit

class CuatoiViewController: StatusbarViewController {
    
    @IBOutlet weak var tblView  : UITableView!
    @IBOutlet weak var viewClose  : UIView!
    @IBOutlet weak var imageNew  : UIImageView!
    var type : String?
    var listNoti : ListNotificationObject?
    var pageIndex = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.rowHeight = UITableViewAutomaticDimension
        tblView.estimatedRowHeight = 300
        tblView.addInfiniteScrollingWithHandler {
            DispatchQueue.global(qos: .userInitiated).async {
                sleep(3)
                DispatchQueue.main.async { [unowned self] in
                    self.pageIndex = self.pageIndex + 1
                    DataConnect.getNotification(token_API, country_code: kCountryCode, phone: userPhone_API, page: self.pageIndex, view: self.view, onsuccess: { (result) in
                        let templistNoti = result as? ListNotificationObject
                        for item in (templistNoti?.data)!
                        {
                            self.listNoti?.data?.append(item)
                        }
                        self.tblView.reloadData()
                        self.tblView.infiniteScrollingView?.stopAnimating()
                    }) { (error) in
                        showErrorMessage(error: error as! Int, vc: self)
                    }
                    
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.pageIndex = 1
        DataConnect.getNotification(token_API, country_code: kCountryCode, phone: userPhone_API, page: self.pageIndex, view: self.view, onsuccess: { (result) in
            self.listNoti = result as? ListNotificationObject
            self.tblView.reloadData()
        }) { (error) in
            showErrorMessage(error: error as! Int, vc: self)
        }
    }
    
    func dissmissViewController()
    {
        
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
extension CuatoiViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if listNoti == nil
        {
            return 0
        }
        else
        {
            return (listNoti?.data?.count)!
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(hex: "e9e9e9")
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == (listNoti?.data?.count)! - 1
        {
            return 0
        }
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblView.dequeueReusableCell(withIdentifier: "CuatoiCell") as! CuatoiCell
        cell.lblTitle.text = listNoti?.data![indexPath.section].title
        if MCLocalization.sharedInstance().language == "vi"
        {
            cell.lblDescription.text = listNoti?.data![indexPath.section].vn_description
        }
        else
        {
           cell.lblDescription.text = listNoti?.data![indexPath.section].description
        }
        if (listNoti?.data![indexPath.section].is_read)!
        {
            cell.lblDescription.font = UIFont(name: "OpenSans", size: 12)
            cell.imageRead.isHidden = true
        }
        else
        {
            cell.lblDescription.font = UIFont(name: "OpenSans-Semibold", size: 12)
            cell.imageRead.isHidden = false
        }
        let time = changeFormatTime(timeString: (listNoti?.data![indexPath.section].time)!, oldFormat: "yyyy-MM-dd HH:mm:ss", newFormat: "h:mm a | EEE, dd MMMM, yyyy")
        cell.lblDate.text = time
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "WebDetailViewController") as! WebDetailViewController
        vc.id_notification = listNoti?.data?[indexPath.section].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
class CuatoiCell : UITableViewCell
{
    @IBOutlet weak var lblTitle  : UILabel!
    @IBOutlet weak var lblDescription  : UILabel!
    @IBOutlet weak var lblDate  : UILabel!
    @IBOutlet weak var imageRead  : UIImageView!
    @IBOutlet weak var imageNew  : UIImageView!
}
