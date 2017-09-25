//
//  HomeGiftingViewController.swift
//  Around
//
//  Created by phuc.huynh on 12/19/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import UIKit
class ButtonWithShadow: UIButton {
    
    override func draw(_ rect: CGRect) {
        updateLayerProperties()
    }
    
    func updateLayerProperties() {
        self.setTitleColor(UIColor.white, for: .normal)
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 10.0
        self.layer.masksToBounds = false
    }
    
}
class HomeGiftingViewController: StatusBarWithSearchBarViewController,SWRevealViewControllerDelegate {
    @IBOutlet weak var btnLuxury: ButtonWithShadow!
    @IBOutlet weak var btnSaleOff: ButtonWithShadow!
    @IBOutlet weak var btnSpecialDay: ButtonWithShadow!
    @IBOutlet weak var btnComboSale: ButtonWithShadow!
    @IBOutlet weak var btnDailySurprise: ButtonWithShadow!
    @IBOutlet weak var viewWhenSlideMenu: UIView!
    var listButton : [ButtonWithShadow]?
    var listItem : [MainCategory]?
    var isFirst = false
    var listBanner : ListBanner?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataConnect.getListBanner(token_API, country_code: kCountryCode, phone: userPhone_API, position: 2, view: self.view, onsuccess: { (result) in
            self.listBanner = result as? ListBanner
            self.loadBanner()
        }) { (error) in
        }
        searchBar.delegate = self
        self.revealViewController().delegate = self
        viewWhenSlideMenu.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        viewWhenSlideMenu.isHidden = true
        listButton = [btnLuxury,btnSaleOff,btnSpecialDay,btnComboSale,btnDailySurprise]
        DataConnect.getMainCategogy(token_API, country_code: kCountryCode, phone: userPhone_API,view: self.view,  onsuccess: { data in
            if let result = data as? [MainCategory]
            {
                if result.count == 0
                {
                }
                else
                {
                    self.setDataFromServer(listMainCategory: result)
                    self.listItem = result
                }
                
            }
        }) { error in
            showErrorMessage(error: error as! Int, vc: self)
            
        }
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

    override var prefersStatusBarHidden : Bool {
        return false
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation
    {
        return UIStatusBarAnimation.slide
    }
    
    func revealController(_ revealController: SWRevealViewController!, animateTo position: FrontViewPosition) {
        if position == .right
        {
            viewWhenSlideMenu.isHidden = false
        }
        else
        {
            viewWhenSlideMenu.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.revealViewController().callbackHistoryOrder = {(historyObj) in
            let hisObj = historyObj as! HistoryObject
            appDelegate.setViewPickupFromChooseService(listPointPreorder: hisObj.locations!)
            
        }
        if isFirst
        {
             self.setDataFromServer(listMainCategory: self.listItem!)
        }
        else{
            isFirst = true
        }
        makeTopNavigationSearchbar(isMenuScreen: true,isCartScreen: false,needShake: false)
    }
    func setDataFromServer(listMainCategory :[MainCategory])
    {
        for btn in (listButton?.enumerated())!
        {
            btn.element.isExclusiveTouch = true
            for item in (listMainCategory.enumerated())
            {
                if btn.element.tag == item.element.sort_order
                {
                    if MCLocalization.sharedInstance().language == "en"
                    {
                        if let url = URL(string: item.element.image!) {
                            btn.element.sd_setBackgroundImage(with: url, for: .normal, placeholderImage: nil)
                            btn.element.clipsToBounds = true
                        }
                        
                    }
                    else if MCLocalization.sharedInstance().language == "vi"
                    {
                        if let url = URL(string: item.element.vn_image!) {
                            btn.element.sd_setBackgroundImage(with: url, for: .normal, placeholderImage: nil)
                            btn.element.clipsToBounds = true
                        }
                    }
                    
                    
                    
                }
                else
                {
                    //  btn.element.setBackgroundImage(UIImage(named: "defaultavatar"), for: .normal)
                }
            }
        }
        
    }
    func findIDFromListCategory(senderTag : Int,list: [MainCategory])-> MainCategory?
    {
        for item in list.enumerated()
        {
            if item.element.sort_order == senderTag
            {
                return item.element
            }
            
        }
        return nil
    }
    @IBAction func goToCategoryContent(_ sender: AnyObject) {
        
        if sender.tag == 1
        {
            tracking(actionKey: "C11.1Y")
        }
        else if sender.tag == 2
        {
            tracking(actionKey: "C11.2Y")
        }
        else if sender.tag == 3
        {
            tracking(actionKey: "C11.3Y")
        }
        else if sender.tag == 4
        {
            tracking(actionKey: "C11.4Y")
        }
        else if sender.tag == 5
        {
            tracking(actionKey: "C11.5Y")
        }
        
        
        if listItem == nil
        {
            return
        }
        if let item = findIDFromListCategory(senderTag: sender.tag, list: listItem!)
        {
            if item.type == "category"
            {
                let vc = giftingStoryBoard.instantiateViewController(withIdentifier: "MainCategoryViewController") as! MainCategoryViewController
                vc.id_category = item.id
                
                
                if MCLocalization.sharedInstance().language == "en"
                {
                    vc.kindOfProduct = item.name
                    
                }
                else if MCLocalization.sharedInstance().language == "vi"
                {
                    vc.kindOfProduct = item.vn_name
                }
                
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            else if item.type == "product"
            {
                let vc = giftingStoryBoard.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
                vc.id_category = item.id
                if MCLocalization.sharedInstance().language == "en"
                {
                    vc.kindOfProduct = item.name
                    
                }
                else if MCLocalization.sharedInstance().language == "vi"
                {
                    vc.kindOfProduct = item.vn_name
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        
        
    }
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
