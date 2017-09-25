
//  BannerProductViewController.swift
//  Around
//
//  Created by phuc.huynh on 8/30/17.
//  Copyright © 2017 phuc.huynh. All rights reserved.
//

import UIKit

class BannerProductViewController: StatusbarViewController,ASHHorizontalDelegate {
    var horizontalScrollViewProduct:ASHorizontalScrollView?
    @IBOutlet weak var pageControl : UIPageControl!
    var listBanner: [ContentObject]?
    @IBOutlet weak var viewlistProduct : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        definesPresentationContext = true
        self.horizontalScrollViewProduct = ASHorizontalScrollView(frame:CGRect(x: 0, y: 0, width: self.viewlistProduct.frame.size.width, height: self.viewlistProduct.frame.size.height))
        self.horizontalScrollViewProduct?.uniformItemSize = CGSize(width: self.viewlistProduct.frame.size.width, height: self.viewlistProduct.frame.size.height)
        self.horizontalScrollViewProduct?.setItemsMarginOnce()
        self.viewlistProduct.addSubview(self.horizontalScrollViewProduct!)
        self.setTypeViewDataRelateProductt(list: self.listBanner!)
        self.horizontalScrollViewProduct?.delegateHorizon = self
    }
    override func viewWillAppear(_ animated: Bool) {
       
    }

    override func viewDidLayoutSubviews() {

    }
    func setTypeViewDataRelateProductt(list: [ContentObject])
    {
        if let pageControlNumber = listBanner?.count{
            if pageControlNumber == 1
            {
                self.pageControl?.isHidden = true
            }
            else
            {
                self.pageControl?.numberOfPages = pageControlNumber
            }
            
        }
        
        
        
        for obj in (list.enumerated())
        {
            let view = BannerProduct.instanceFromNib() as! BannerProduct
        
            let italicWordAttribute = [ NSFontAttributeName: UIFont(name: "OpenSans-Italic", size: 13)! ]
            let regularWordAttribute = [ NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 13)! ]
            let fromString = NSMutableAttributedString(string: MCLocalization.string(forKey: "FROM") , attributes: italicWordAttribute )
            let toString = NSMutableAttributedString(string: " " + MCLocalization.string(forKey: "TO") , attributes: italicWordAttribute )
            
            let startDate = NSMutableAttributedString(string: " " + changeFormatTime(timeString: obj.element.start_date!, oldFormat: "yyyy-MM-dd HH:mm:ss", newFormat: "dd/MM")  , attributes: regularWordAttribute )
            let endDate = NSMutableAttributedString(string: " " + changeFormatTime(timeString: obj.element.end_date!, oldFormat: "yyyy-MM-dd HH:mm:ss", newFormat: "dd/MM") , attributes: regularWordAttribute )
            
            let finalText = NSMutableAttributedString()
            
            finalText.append(fromString)
            finalText.append(startDate)
            finalText.append(toString)
            finalText.append(endDate)
            view.lbldate.attributedText = finalText
            
            view.imageProduct.sd_setImage(with: URL(string: (obj.element.product?.image!)!), placeholderImage: nil)
            view.lblNameProduct.text = obj.element.product?.name
            view.lblPrice.text =  (obj.element.product?.price?.stringFormattedWithSeparator)! + "đ"
            
            if obj.element.product?.save_percent == 0 || obj.element.product?.save_percent == nil
            {
                view.viewSaleOff.isHidden = true
                view.lblgiamgia.isHidden = true
                view.lblSafeOff.isHidden = true
            }
            else
            {
                view.viewSaleOff.isHidden = false
                view.lblgiamgia.isHidden = false
                view.lblSafeOff.isHidden = false
                view.lblSafeOff.text = String(format: "%d", (obj.element.product?.save_percent)!) + "%"
            }
            let attributedString = NSMutableAttributedString(string: (obj.element.product?.old_price?.stringFormattedWithSeparator)! + "đ")
            attributedString.addAttribute(NSStrikethroughStyleAttributeName, value: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue), range: NSMakeRange(0, attributedString.length))
            attributedString.addAttribute(NSStrikethroughColorAttributeName, value: UIColor(hex: "0b7cc2"), range: NSMakeRange(0, attributedString.length))
            view.lblPriceSale.attributedText = attributedString
            view.btnMuaNgay.tag = obj.offset
            view.btnMuaNgay.addTarget(self, action:#selector(self.muangay(sender:)) , for: .touchUpInside)
            if obj.element.product?.save_percent == 0 || obj.element.product?.save_percent == nil
            {
                view.viewSaleOff.isHidden = true
                view.lblgiamgia.isHidden = true
                view.lblSafeOff.isHidden = true
                view.contrainsHeightTietKiem?.constant = 0
            }
            else
            {
                view.viewSaleOff.isHidden = false
                view.lblgiamgia.isHidden = false
                view.lblSafeOff.isHidden = false
                view.lblSafeOff.text = String(format: "%d", (obj.element.product?.save_percent)!) + "%"
                view.contrainsHeightTietKiem?.constant = 15
            }
            self.view.layoutIfNeeded()
            if MCLocalization.sharedInstance().language == "en"
            {
                view.lblDetail.text = obj.element.description
                view.lblTitle.text = obj.element.title
            }
            else
            {
                view.lblDetail.text = obj.element.vn_description
                view.lblTitle.text = obj.element.vn_title
            }
            horizontalScrollViewProduct?.addItem(view)
        
        }
        
    }
    func muangay(sender: UIButton)
    {
    
        DataConnect.addItemToCart(token_API, country_code: kCountryCode, phone: userPhone_API, id_product: (self.listBanner?[sender.tag].product?.id)!,attributes: "" , view: self.view,  onsuccess: { (result) in
            weak var pvc = self.presentingViewController
            
            self.dismiss(animated: false, completion: {
                
                let vc = giftingStoryBoard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
                let nav = UINavigationController(rootViewController: vc)
                pvc?.present(nav, animated: false, completion: nil)
                
                
            })
        }, onFailure: { (error) in
            showErrorMessage(error: error as! Int, vc: self)
        })
        

    }
    func callBackIndexPage(indexPage: Int) {
        self.pageControl.currentPage = indexPage
    }
    
    @IBAction func btnCloseClick(_ sender: AnyObject?) {
        
        self.dismiss(animated: false) {
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
