//
//  SearchProductViewController.swift
//  Around
//
//  Created by phuc.huynh on 12/26/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//


import UIKit

class SearchProductViewController: StatusBarWithSearchBarViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewClose: UIView!
    var id_category: Int?
    var listProduct : [Product] = []
    var cellSelected:[Product]?
    var keyword: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.register(UINib(nibName: "SubCategoryCell", bundle: nil), forCellReuseIdentifier: "searchCell")
        searchBar.delegate = self
        DataConnect.searchProduct(token_API, country_code: kCountryCode, phone: userPhone_API, keyword: keyword!, page: 1,view: self.view,  onsuccess: { (data) in
            if let result = data as? [Product]
            {
                if result.count == 0
                {
                    self.viewClose.isHidden = false
                    self.tblView.isHidden = true
                    return
                }
                self.viewClose.isHidden = true
                self.tblView.isHidden = false
                self.listProduct = result
                self.cellSelected = result
                self.tblView.reloadData()
            }
            
        }) { (error) in
            showErrorMessage(error: error as! Int, vc: self)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        makeTopNavigationSearchbar(isMenuScreen: false,isCartScreen: false,needShake: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listProduct.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell") as! SubCategoryCell
        let pro = listProduct[indexPath.row]
        if let url = URL(string: pro.image!),let placeholder = UIImage(named: "default_product") {
            cell.imageAvatar.sd_setImageWithURLWithFade(url, placeholderImage: placeholder)
        }
        cell.lblAddress.text = pro.shop_address
        cell.lblShopName.text = pro.shop_name
        cell.viewStar.rating = Float(pro.rating!)
        cell.viewStar.isUserInteractionEnabled = false
        cell.lblPrice.text = (pro.price?.stringFormattedWithSeparator)! + "đ"
        cell.lblProductName.text = pro.name
        cell.btnCart.tag = indexPath.row
        cell.btnCart.addTarget(self, action: #selector(self.tickClicked(sender:)), for: .touchUpInside)
        
        if cellSelected?[indexPath.row].in_cart == 1
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
        let value = sender.tag;
        let pro = listProduct[value]
        if cellSelected?[value].in_cart == 1
        {
            
            DataConnect.clearProduct(token_API, country_code: kCountryCode, phone: userPhone_API, id_product: pro.id!,view: self.view,  onsuccess: { (result) in
                self.makeTopNavigationSearchbar(isMenuScreen: false,isCartScreen: false,needShake: true)
                self.cellSelected?[value].in_cart = 0
                self.tblView.reloadData()
            }, onFailure: { (error) in
                
                showErrorMessage(error: error as! Int, vc: self)
            })
        }
        else
        {
            
            
            DataConnect.addItemToCart(token_API, country_code: kCountryCode, phone: userPhone_API, id_product: pro.id!,attributes: "" , view: self.view,  onsuccess: { (result) in
                self.makeTopNavigationSearchbar(isMenuScreen: false,isCartScreen: false,needShake: true)
                self.cellSelected?[value].in_cart = 1
                self.tblView.reloadData()
            }, onFailure: { (error) in
                
                showErrorMessage(error: error as! Int, vc: self)
            })
            
        }
        if  countOfNumberCart == 0 {
            rightSearchBarButtonItem?[0].isEnabled = false
        }
        else
        {
            rightSearchBarButtonItem?[0].isEnabled = true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = giftingStoryBoard.instantiateViewController(withIdentifier: "DetailViewProductViewController") as! DetailViewProductViewController
        vc.product_ID = listProduct[indexPath.row].id
        vc.kindOfProduct = listProduct[indexPath.row].name
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
