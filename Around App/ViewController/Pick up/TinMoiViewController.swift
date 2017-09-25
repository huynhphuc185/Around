//
//  OrderHistoryViewController.swift
//  Around
//
//  Created by phuc.huynh on 11/23/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import UIKit

class TinMoiViewController: StatusbarViewController {
    
    @IBOutlet weak var tblView  : UITableView!
    @IBOutlet weak var viewClose  : UIView!
    
    var type : String?
    var listEvent : ListEventObject?
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
                    DataConnect.getEvent(token_API, country_code: kCountryCode, phone: userPhone_API, page: self.pageIndex, view: self.view, onsuccess: { (result) in
                        let templistNoti = result as? ListEventObject
                        for item in (templistNoti?.data)!
                        {
                            self.listEvent?.data?.append(item)
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
        DataConnect.getEvent(token_API, country_code: kCountryCode, phone: userPhone_API, page: 1, view: self.view, onsuccess: { (result) in
            self.listEvent = result as? ListEventObject
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
extension TinMoiViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listEvent == nil
        {
            return 0
        }
        else
        {
            return (listEvent?.data?.count)!
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblView.dequeueReusableCell(withIdentifier: "TinMoiCell") as! TinMoiCell
        let time = changeFormatTime(timeString: (listEvent?.data![indexPath.row].time)!, oldFormat: "yyyy-MM-dd HH:mm:ss", newFormat: "h:mm a | EEE, dd MMMM, yyyy")
        cell.lblDate.text = time
        
        cell.mainImageView.sd_setImageWithURLWithFade(URL(string: (listEvent?.data?[indexPath.row].image)!), placeholderImage: UIImage(named: "default_product"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        0 : không cho nhấn vào
//        1:  get notification detail ( id_content)
//        2 : get product_detail ( id_content )
//        3:  đang update cái banner

        let obj = listEvent?.data?[indexPath.row]
        if obj?.type == 0
        {
            return
        }
        else if obj?.type == 1
        {
            let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "WebDetailViewController") as! WebDetailViewController
            vc.id_notification = obj?.id_content
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if obj?.type == 2
        {
            let vc = giftingStoryBoard.instantiateViewController(withIdentifier: "DetailViewProductViewController") as! DetailViewProductViewController
            vc.product_ID = obj?.id_content
            //vc.kindOfProduct = cartObj.product[indexPath.row].name
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if obj?.type == 3
        {
            DataConnect.getBannerDetail(token_API, country_code: kCountryCode, phone: userPhone_API, id: (obj?.id_content)!, view: self.view, onsuccess: { (result) in
                let bannerObj = result as! BannerDetail
                self.loadBanner(bannerObj: bannerObj)
            }, onFailure: { (error) in
                showErrorMessage(error: error as! Int, vc: self)
            })
        }


    }
    func loadBanner(bannerObj : BannerDetail)
    {

            if bannerObj.data?.type == 0
            {
                
                let myAlert = bannerStoryBoard.instantiateViewController(withIdentifier: "BannerImageViewController") as! BannerImageViewController
                myAlert.bannerObj = bannerObj.data
                myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                self.present(myAlert, animated: false, completion: {
                  
                })
                
                
            }
            else if bannerObj.data?.type == 1
            {
                
                let myAlert = bannerStoryBoard.instantiateViewController(withIdentifier: "BannerImageViewController") as! BannerImageViewController
                myAlert.bannerObj = bannerObj.data
                myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            
                
                self.present(myAlert, animated: false, completion: {
              
                })
               
                
                
            }
            else if bannerObj.data?.type == 2
            {
                if bannerObj.data?.show_number == 1
                {
                    let myAlert = bannerStoryBoard.instantiateViewController(withIdentifier: "BannerProductViewController") as! BannerProductViewController
                    myAlert.listBanner = bannerObj.data?.contents
                    myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                   
                    
                    self.present(myAlert, animated: false, completion: {
                       
                    })
                
                }
                else if bannerObj.data?.show_number == 4
                {
                    let myAlert = bannerStoryBoard.instantiateViewController(withIdentifier: "BannerFourProductViewController") as! BannerFourProductViewController
                    myAlert.listBanner = bannerObj.data
                    myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                    
                    self.present(myAlert, animated: false, completion: {
                        
                    })
              
                }
            }
        
            else if bannerObj.data?.type == 3
            {
                let myAlert = pickUpStoryBoard.instantiateViewController(withIdentifier: "PopUpEventTextViewController") as! PopUpEventTextViewController
                myAlert.listBanner = bannerObj.data
                myAlert.isSelectButtonConfirm = false
                myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                self.present(myAlert, animated: false, completion: {
                    
                })
                
                
            }
            else if bannerObj.data?.type == 4
            {
                let myAlert = pickUpStoryBoard.instantiateViewController(withIdentifier: "PopUpEventTextViewController") as! PopUpEventTextViewController
                myAlert.listBanner = bannerObj.data
                myAlert.isSelectButtonConfirm = true
                myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve

                self.present(myAlert, animated: false, completion: {
                    
                })
                
        }

        }
    }
    



class TinMoiCell : UITableViewCell
{
    @IBOutlet weak var mainImageView  : UIImageView!
    @IBOutlet weak var lblDate  : UILabel!
    @IBOutlet weak var imageNew  : UIImageView!
}
