//
//  MainCategoryViewController.swift
//  Around
//
//  Created by phuc.huynh on 12/20/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import UIKit

class MainCategoryViewController: StatusBarWithSearchBarViewController , UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var mainCollectionView: UICollectionView!
    var id_category: Int?
    var listCategory : [AnyObject] = []
    var listSectionCategory : [AnyObject] = []
    var kindOfProduct: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        DataConnect.getCategoryContent(token_API, country_code: kCountryCode, phone: userPhone_API, id_category: id_category!, page: 1,tab:"", view: self.view, onsuccess: { data in
            if let result = data as? CategoryContent
            {
               if result.type == "category"
               {
                self.listCategory = result.listCategory
                self.listSectionCategory = self.listCategory.chunk(2) as [AnyObject]
                self.mainCollectionView.reloadData()
                }
            }
        }) { error in
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
    
 
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0
        {
           if indexPath.row == 0
           {
            tracking(actionKey: "C12.1Y")
            }
            else if indexPath.row == 1
           {
            tracking(actionKey: "C12.2Y")
            }
        }
        else if indexPath.section == 1
        {
            if indexPath.row == 0
            {
                tracking(actionKey: "C12.3Y")
            }
            else if indexPath.row == 1
            {
                tracking(actionKey: "C12.4Y")
            }
        }
        else if indexPath.section == 2
        {
            if indexPath.row == 0
            {
                tracking(actionKey: "C12.5Y")
            }
            else if indexPath.row == 1
            {
                tracking(actionKey: "C12.6Y")
            }
        }
        
        let twoIteminSection  = self.listSectionCategory[(indexPath as NSIndexPath).section] as! [CategoryItem]
        let cellObj = twoIteminSection[(indexPath as NSIndexPath).row]
        

        if cellObj.type == "category"
        {
            let vc = giftingStoryBoard.instantiateViewController(withIdentifier: "MainCategoryViewController") as! MainCategoryViewController
            vc.id_category = cellObj.id
            
            
            if MCLocalization.sharedInstance().language == "en"
            {
                vc.kindOfProduct = cellObj.name
                
            }
            else if MCLocalization.sharedInstance().language == "vi"
            {
                vc.kindOfProduct = cellObj.vn_name
            }
             self.navigationController?.pushViewController(vc, animated: true)

            
        }
        else if cellObj.type == "product"
        {
            let vc = giftingStoryBoard.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            vc.id_category = cellObj.id
            if MCLocalization.sharedInstance().language == "en"
            {
                vc.kindOfProduct = cellObj.name
                
            }
            else if MCLocalization.sharedInstance().language == "vi"
            {
                vc.kindOfProduct = cellObj.vn_name
            }
             self.navigationController?.pushViewController(vc, animated: true)
        }
        

       
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return listSectionCategory.count
    }

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return listSectionCategory[section].count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        if listCategory.count == 2 || listCategory.count == 3
        {
            cell.csWidth.constant =  collectionView.frame.width*3/5
            cell.csHeight.constant =  collectionView.frame.width*3/5
            cell.txtName.layer.borderColor = UIColor(hex: colorXamNhat).cgColor
            cell.txtName.textColor = UIColor(hex: colorXamNhat)
            self.view.layoutIfNeeded()
        }
        else
        {
            cell.csWidth.constant =  collectionView.frame.width/2
            cell.csHeight.constant =  collectionView.frame.height/3
            self.view.layoutIfNeeded()
            if indexPath.section % 2 == 0
            {
                if indexPath.row % 2 == 0
                {
                    cell.background.backgroundColor =  UIColor(hex: "#d7d7d7")
                    cell.txtName.layer.masksToBounds = true
                    cell.txtName.layer.borderColor = UIColor.white.cgColor
                    cell.txtName.textColor = UIColor.white
                }
                else
                {
                    cell.background.backgroundColor = UIColor.clear
                    cell.txtName.layer.masksToBounds = true
                    cell.txtName.layer.borderColor = UIColor(hex: colorXamNhat).cgColor
                    cell.txtName.textColor = UIColor(hex: colorXamNhat)
                }
            }
            else
            {
                if indexPath.row % 2 == 0
                {
                    cell.background.backgroundColor = UIColor.clear
                    cell.txtName.layer.masksToBounds = true
                    cell.txtName.layer.borderColor = UIColor(hex: colorXamNhat).cgColor
                    cell.txtName.textColor = UIColor(hex: colorXamNhat)
                }
                else
                {
                    cell.background.backgroundColor =  UIColor(hex: "#d7d7d7")
                    cell.txtName.layer.masksToBounds = true
                    cell.txtName.layer.borderColor = UIColor.white.cgColor
                    cell.txtName.textColor = UIColor.white
                }
            }

        }
        
        
        let item  = self.listSectionCategory[(indexPath as NSIndexPath).section] as! [CategoryItem]
        if MCLocalization.sharedInstance().language == "en"
        {
            let urlString = item[(indexPath as NSIndexPath).row].image
            if let url = URL(string: urlString!),let placeholder = UIImage(named: "default_product") {
                cell.imageView.alpha = 1
                cell.imageView.sd_setImageWithURLWithFade(url, placeholderImage: placeholder);
            }
            cell.txtName.text = item[indexPath.row].name?.uppercased()
            
        }
        else if MCLocalization.sharedInstance().language == "vi"
        {
            let urlString = item[(indexPath as NSIndexPath).row].vn_image
            if let url = URL(string: urlString!),let placeholder = UIImage(named: "default_product") {
                cell.imageView.alpha = 1
                cell.imageView.sd_setImageWithURLWithFade(url, placeholderImage: placeholder);
            }
            cell.txtName.text = item[indexPath.row].vn_name?.uppercased()
        }
        
        
        cell.txtName.layer.borderWidth = 1

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if listCategory.count == 2
        {
            
            let itemWidth = collectionView.frame.width
            let itemHeight = collectionView.frame.height/2
            return CGSize(width: itemWidth, height: itemHeight)
        }
        else if listCategory.count == 3
        {
            let itemWidth = collectionView.frame.width
            let itemHeight = collectionView.frame.height * 0.4
            return CGSize(width: itemWidth, height: itemHeight)

        }
        else{
            let numberOfItemsInLine: CGFloat = 2
            let inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            let minimumInteritemSpacing = self.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: indexPath.section)
            let itemWidth = (collectionView.frame.width - inset.left - inset.right - minimumInteritemSpacing * (numberOfItemsInLine - 1)) / numberOfItemsInLine
            let itemHeight = collectionView.frame.height/3
            
            return CGSize(width: itemWidth, height: itemHeight)
        }
       

    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }

    
}
class CategoryCell : UICollectionViewCell
{
     @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var background: UIView!
   // @IBOutlet weak var txtLikeNumber: CustomTextFieldWithImage!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var csHeight: NSLayoutConstraint!
    @IBOutlet weak var csWidth: NSLayoutConstraint!
}

class HeaderCategory : UICollectionViewCell
{
    @IBOutlet weak var btnLow: UIButton!
    @IBOutlet weak var btnMedium: UIButton!
    @IBOutlet weak var btnHeight: UIButton!
}
