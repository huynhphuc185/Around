
//
//  SubCategoryViewController.swift
//  Around
//
//  Created by phuc.huynh on 12/20/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import UIKit

class PriceCategoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tblView: UITableView!
    var id_category: Int?
    var listProduct : [Product] = []
    var pageIndex : Int?
    var kindOfProduct: String?
    weak var parentVC : SubCategoryViewController?
    var flagChangetabTitle = false
    var tangHayGiam = false
    override func viewDidLoad() {
        super.viewDidLoad()
        pageIndex = 1
        self.tblView.register(UINib(nibName: "SubCategoryCell", bundle: nil), forCellReuseIdentifier: "pricecell")
        tblView.addInfiniteScrollingWithHandler {
            DispatchQueue.global(qos: .userInitiated).async {
                sleep(3)
                DispatchQueue.main.async { [unowned self] in
                    self.pageIndex = self.pageIndex! + 1
                    var strTangGiam = ""
                    if self.tangHayGiam
                    {
                        strTangGiam = "PRICE_DECREASE"
                    }
                    else
                    {
                        strTangGiam = "PRICE_INCREASE"
                    }
                    DataConnect.getCategoryContent(token_API, country_code: kCountryCode, phone: userPhone_API, id_category: self.id_category!, page: self.pageIndex! ,tab:strTangGiam,view: self.view,  onsuccess: { data in
                        if let result = data as? CategoryContent
                        {
                            if result.type == "product"
                            {
                                
                                for item in result.listProduct
                                {
                                    self.listProduct.append(item)
                                    if item.in_cart == 1
                                    {
                                        appDelegate.listSelected.append(item.id!)
                                    }
                                }
                                appDelegate.listSelected =  appDelegate.listSelected.removeDuplicates()
                                self.tblView.reloadData()
                                self.tblView.infiniteScrollingView?.stopAnimating()
                            }
                        }
                    }) { error in
                        showErrorMessage(error: error as! Int, vc: self)
                    }
                    
                    
                }
            }
        }
        DataConnect.getCategoryContent(token_API, country_code: kCountryCode, phone: userPhone_API, id_category: id_category!, page: self.pageIndex!,tab:"PRICE_INCREASE",view: self.view,  onsuccess: { data in
            if let result = data as? CategoryContent
            {
                if result.type == "product"
                {
                    self.listProduct = result.listProduct
                    for item in self.listProduct
                    {
                        if item.in_cart == 1
                        {
                            appDelegate.listSelected.append(item.id!)
                        }
                    }
                    appDelegate.listSelected = appDelegate.listSelected.removeDuplicates()
                    self.tblView.reloadData()
                }
            }
        }) { error in
            showErrorMessage(error: error as! Int, vc: self)
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tblView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updatePage(notification:)), name: Notification.Name("updatePage"), object: nil)

    }
    override func viewWillDisappear(_ animated: Bool) {
           }
    override func viewDidDisappear(_ animated: Bool) {
        if flagChangetabTitle == false
        {
            parentVC?.btnPrice.isSelected = !((parentVC?.btnPrice.isSelected)!)
            if parentVC?.btnPrice.isSelected == true
            {
                self.parentVC?.imageViewDownUp.image = UIImage(named : "up")
                
            }
            else
            {
                self.parentVC?.imageViewDownUp.image = UIImage(named : "down")
            }
        }
        else
        {
            flagChangetabTitle = false
        }
        NotificationCenter.default.removeObserver(self)

    }
    func updatePage(notification: Notification)
    {
        pageIndex = 1
        if let result = notification.object as? Bool
        {
            self.tangHayGiam = result
            if result {
                DataConnect.getCategoryContent(token_API, country_code: kCountryCode, phone: userPhone_API, id_category: id_category!, page: self.pageIndex!,tab:"PRICE_DECREASE",view: self.view,  onsuccess: { data in
                    if let result = data as? CategoryContent
                    {
                        if result.type == "product"
                        {
                            self.listProduct = result.listProduct
                            for item in self.listProduct
                            {
                                if item.in_cart == 1
                                {
                                    appDelegate.listSelected.append(item.id!)
                                }
                            }
                            appDelegate.listSelected = appDelegate.listSelected.removeDuplicates()
                            self.tblView.reloadData()
                        }
                    }
                }) { error in
                    showErrorMessage(error: error as! Int, vc: self)
                }

            }
            else
            {
                DataConnect.getCategoryContent(token_API, country_code: kCountryCode, phone: userPhone_API, id_category: id_category!, page: self.pageIndex!,tab:"PRICE_INCREASE",view: self.view,  onsuccess: { data in
                    if let result = data as? CategoryContent
                    {
                        if result.type == "product"
                        {
                            self.listProduct = result.listProduct
                            for item in self.listProduct
                            {
                                if item.in_cart == 1
                                {
                                    appDelegate.listSelected.append(item.id!)
                                }
                            }
                            appDelegate.listSelected = appDelegate.listSelected.removeDuplicates()
                            self.tblView.reloadData()
                        }
                    }
                }) { error in
                    showErrorMessage(error: error as! Int, vc: self)
                }

            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.∫
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listProduct.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "pricecell") as! SubCategoryCell
        let pro = listProduct[indexPath.row]
        if let url = URL(string: pro.image!),let placeholder = UIImage(named: "default_product") {
            cell.imageAvatar.sd_setImageWithURLWithFade(url, placeholderImage: placeholder)
        }
        cell.lblAddress.text = pro.shop_address
        cell.lblShopName.text = pro.shop_name
        cell.viewStar.rating = Float(pro.rating!)
        cell.viewStar.isUserInteractionEnabled = false
        cell.lblPrice.text = String(format: "%@đ", (pro.price?.stringFormattedWithSeparator)!)
        cell.lblProductName.text = pro.name
        cell.btnCart.tag = indexPath.row
        cell.btnCart.addTarget(self, action: #selector(self.tickClicked(sender:)), for: .touchUpInside)
        
        if appDelegate.listSelected.contains(listProduct[indexPath.row].id!)
        {
            cell.btnCart.isSelected = true
        }
        else
        {
            cell.btnCart.isSelected = false
        }
        if pro.old_price == 0 || pro.old_price == nil
        {
            cell.lblOldPrice.isHidden = true
        }
        else
        {
            cell.lblOldPrice.isHidden = false
            let attributedString = NSMutableAttributedString(string: (pro.old_price?.stringFormattedWithSeparator)! + "đ")
            attributedString.addAttribute(NSStrikethroughStyleAttributeName, value: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue), range: NSMakeRange(0, attributedString.length))
            attributedString.addAttribute(NSStrikethroughColorAttributeName, value: UIColor(hex: "0b7cc2"), range: NSMakeRange(0, attributedString.length))
            cell.lblOldPrice.attributedText = attributedString
            
        }
        if pro.save_percent == 0 || pro.save_percent == nil
        {
            cell.imageViewSafeOff.isHidden = true
            cell.lblSaleOff.isHidden = true
        }
        else
        {
            cell.imageViewSafeOff.isHidden = false
            cell.lblSaleOff.isHidden = false
            cell.lblSaleOff.text = "-" + String(format: "%d", pro.save_percent!) + "%"
        }
        if pro.is_new == false{
            cell.imageViewNew.isHidden = true
        }
        else
        {
            cell.imageViewNew.isHidden = false
            if MCLocalization.sharedInstance().language == "en"
            {
                cell.imageViewNew.image = UIImage(named: "new")
            }
            else
            {
                cell.imageViewNew.image = UIImage(named: "newVN")
            }
        }

        return cell
    }
    func tickClicked(sender: UIButton!)
    {
        tracking(actionKey: "C13.6.1Y")
        let value = sender.tag;
        let pro = listProduct[value]
        if appDelegate.listSelected.contains(pro.id!)
        {
            DataConnect.clearProduct(token_API, country_code: kCountryCode, phone: userPhone_API, id_product: pro.id!, view: self.view, onsuccess: { (result) in
                self.parentVC?.makeTopNavigationSearchbar(isMenuScreen: false,isCartScreen: false,needShake: true)
                if let index = appDelegate.listSelected.index(of:pro.id!) {
                    appDelegate.listSelected.remove(at: index)
                    self.listProduct[value].in_cart = 0
                }
                self.tblView.reloadData()
            }, onFailure: { (error) in
                showErrorMessage(error: error as! Int, vc: self)
            })
        }
        else
        {
            
            DataConnect.addItemToCart(token_API, country_code: kCountryCode, phone: userPhone_API, id_product: pro.id!,attributes: "",view: self.view,  onsuccess: { (result) in
                self.parentVC?.makeTopNavigationSearchbar(isMenuScreen: false,isCartScreen: false,needShake: true)
                appDelegate.listSelected.append(self.listProduct[value].id!)
                self.listProduct[value].in_cart = 1
                appDelegate.listSelected = appDelegate.listSelected.removeDuplicates()
                self.tblView.reloadData()
            }, onFailure: { (error) in
                showErrorMessage(error: error as! Int, vc: self)
            })
            
        }
        
        if  parentVC?.countOfNumberCart == 0 {
            parentVC?.rightSearchBarButtonItem?[1].isEnabled = false
        }
        else
        {
            parentVC?.rightSearchBarButtonItem?[1].isEnabled = true
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        flagChangetabTitle = true
        tracking(actionKey: "C13.7.1Y")
        let vc = giftingStoryBoard.instantiateViewController(withIdentifier: "DetailViewProductViewController") as! DetailViewProductViewController
        vc.product_ID = listProduct[indexPath.row].id
        vc.kindOfProduct = kindOfProduct
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
    }
}

