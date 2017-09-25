
//
//  SubCategoryViewController.swift
//  Around
//
//  Created by phuc.huynh on 12/20/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import UIKit

class SubCategoryViewController: StatusBarWithSearchBarViewController {
    @IBOutlet weak var viewALL: UIView!
    @IBOutlet weak var viewInterest: UIView!
    @IBOutlet weak var viewPrice: UIView!
    @IBOutlet weak var btnALL: UIButton!
    @IBOutlet weak var btnInterest: UIButton!
    @IBOutlet weak var lblHot: UILabel!
    @IBOutlet weak var lblIntersted: UILabel!
    
    @IBOutlet weak var btnPrice: UIButton!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imageViewDownUp: UIImageView!
    var id_category: Int?
    var kindOfProduct: String?
    
    weak var pageVC: SubCatePageViewController? {
        didSet {
            pageVC?.subCateDelegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        selectButtonTab(sender: btnALL)
        imageViewDownUp.image = UIImage(named : "down")
        
        if defaults.object(forKey: "second") == nil{
            defaults.setValue("second", forKey: "second")
            if DeviceType.IS_IPHONE_5
            {
                showTutorial(self, imageName: MCLocalization.string(forKey: "IMAGEDEMO2_IP5"))
            }
            else if DeviceType.IS_IPHONE_6
            {
                showTutorial(self, imageName: MCLocalization.string(forKey: "IMAGEDEMO2_IP6"))
            }
            else if DeviceType.IS_IPHONE_6P
            {
                showTutorial(self, imageName: MCLocalization.string(forKey: "IMAGEDEMO2"))
            }

        }

        
    }

    override func viewWillAppear(_ animated: Bool) {
        makeTopNavigationSearchbar(isMenuScreen: false,isCartScreen: false,needShake: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.∫
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SubCatePageViewController {
            vc.parentVC = self
            vc.category_id = id_category
            vc.kind_of_Product = kindOfProduct
            pageVC = vc
            
        }

    }
     @IBAction func btnHotClick (_ sender: UIButton?)
     {
       //self.selectButtonTab(sender: sender!)
        pageVC?.scrollToViewController(index: 0)
    }
     @IBAction func btnInterestClick (_ sender: UIButton)
     {
        //self.selectButtonTab(sender: sender)
        pageVC?.scrollToViewController(index: 1)
    }
    
    @IBAction func btnPriceClick (_ sender: UIButton?)
    {
        
       // self.selectButtonTab(sender: sender!)
        pageVC?.scrollToViewController(index: 2)
    }
    
    
    func selectButtonTab(sender: UIButton)
    {
        if sender == btnALL
        {
            if btnALL.isSelected == true
            {
                return
            }
            btnALL.isSelected = true
            btnInterest.isSelected = false
           
            
            lblHot.textColor = UIColor(hex: "616161")
            lblIntersted.textColor = UIColor(hex: "b4b4b4")
            lblPrice.textColor = UIColor(hex: "b4b4b4")
            
            viewALL.backgroundColor = UIColor(hex: colorCam)
            viewInterest.backgroundColor = UIColor.clear
            viewPrice.backgroundColor = UIColor.clear
           
            
        }
        else if sender == btnInterest
        {
            
            if btnInterest.isSelected == true
            {
                return
            }
            btnALL.isSelected = false
            btnInterest.isSelected = true

            
            
            lblHot.textColor = UIColor(hex: "b4b4b4")
            lblIntersted.textColor = UIColor(hex: "616161")
            lblPrice.textColor = UIColor(hex: "b4b4b4")
            
            viewALL.backgroundColor = UIColor.clear
            viewInterest.backgroundColor = UIColor(hex: colorCam)
            viewPrice.backgroundColor = UIColor.clear
            
          

            
            
        }
        else if sender == btnPrice
        {
            btnALL.isSelected = false
            btnInterest.isSelected = false
            
            lblHot.textColor = UIColor(hex: "b4b4b4")
            lblIntersted.textColor = UIColor(hex: "b4b4b4")
            lblPrice.textColor = UIColor(hex: "616161")
            
            viewALL.backgroundColor = UIColor.clear
            viewInterest.backgroundColor = UIColor.clear
            viewPrice.backgroundColor = UIColor(hex: colorCam)
            if btnPrice.isSelected == true
            {
                NotificationCenter.default.post(name: Notification.Name("updatePage"), object: true)
                btnPrice.isSelected = false
                imageViewDownUp.image = UIImage(named : "upden")
            }
            else
            {
                 NotificationCenter.default.post(name: Notification.Name("updatePage"), object:false)
                 btnPrice.isSelected = true
                imageViewDownUp.image = UIImage(named : "downden")
            }
          

            

        }
    }

}
extension SubCategoryViewController: SubCatePageViewControllerDelegate {
    
    func tutorialPageViewController(_ tutorialPageViewController: SubCatePageViewController,
                                    didUpdatePageCount count: Int) {
    }
    
    func tutorialPageViewController(_ tutorialPageViewController: SubCatePageViewController,
                                    didUpdatePageIndex index: Int) {
        if index == 0
        {
            self.selectButtonTab(sender: btnALL)
            
        }
        else if index == 1
        {
            self.selectButtonTab(sender: btnInterest)
        }
        else if index == 2
        {
            self.selectButtonTab(sender: btnPrice)
        }
    }
    
    
}
class SubCategoryCell: UITableViewCell
{
    @IBOutlet weak var lblShopName: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var viewStar: FloatRatingView!
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblOldPrice: UILabel!
    @IBOutlet weak var lblSaleOff: UILabel!
    @IBOutlet weak var imageViewSafeOff: UIImageView!
    @IBOutlet weak var imageViewNew: UIImageView!
}
