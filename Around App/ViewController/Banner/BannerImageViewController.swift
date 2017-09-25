//
//  BannerImageViewController.swift
//  Around
//
//  Created by Phuc Huynh on 8/30/17.
//  Copyright © 2017 phuc.huynh. All rights reserved.
//

import UIKit

class BannerImageViewController: StatusbarViewController,ASHHorizontalDelegate {
    @IBOutlet weak var listImageView : UIView!
    var horizontalScrollViewProduct:ASHorizontalScrollView?
    @IBOutlet weak var pageControl : UIPageControl!
    var bannerObj : BannerObject?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.horizontalScrollViewProduct = ASHorizontalScrollView(frame:CGRect(x: 0, y: 0, width: self.listImageView.frame.size.width, height: self.listImageView.frame.size.height))
        self.horizontalScrollViewProduct?.uniformItemSize = CGSize(width: self.listImageView.frame.size.width, height: self.listImageView.frame.size.height)
        self.horizontalScrollViewProduct?.setItemsMarginOnce()
        self.listImageView.addSubview(self.horizontalScrollViewProduct!)
        self.setTypeViewDataRelateProductt()
        self.horizontalScrollViewProduct?.delegateHorizon = self
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnCloseClick(_ sender: AnyObject?) {
        
        self.dismiss(animated: false) {
        }
    }

    func bannerClick(sender: UIButton)
    {
        
        let productID = bannerObj?.contents?[sender.tag].product?.id
        DataConnect.addItemToCart(token_API, country_code: kCountryCode, phone: userPhone_API, id_product: productID! ,attributes: "" , view: self.view,  onsuccess: { (result) in
            let vc = giftingStoryBoard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: false, completion: nil)
            self.btnCloseClick(nil)
            
        }, onFailure: { (error) in
            showErrorMessage(error: error as! Int, vc: self)
        })
        
        
    }
    func setTypeViewDataRelateProductt()
    {
        if let pageControlNumber = self.bannerObj?.contents?.count{
        if pageControlNumber == 1
        {
            self.pageControl?.isHidden = true
        }
        else
        {
            self.pageControl?.numberOfPages = pageControlNumber
        }
        
        }
        
        
        if self.bannerObj?.type == 0
        {
            for obj in (self.bannerObj?.contents?.enumerated())!
            {
                if MCLocalization.sharedInstance().language == "en"
                {
                    let imageView = UIImageView()
                    imageView.frame = CGRect(x: 0, y: 0, width: listImageView.frame.width, height: listImageView.frame.height)
                    imageView.sd_setImage(with: URL(string: obj.element.image!), placeholderImage: nil)
                    horizontalScrollViewProduct?.addItem(imageView)
                }
                else
                {
                    let imageView = UIImageView()
                    imageView.frame = CGRect(x: 0, y: 0, width: listImageView.frame.width, height: listImageView.frame.height)
                    imageView.sd_setImage(with: URL(string: obj.element.vn_image!), placeholderImage: nil)
                    horizontalScrollViewProduct?.addItem(imageView)
                }
            }

        }
        else
        {
            for obj in (self.bannerObj?.contents?.enumerated())!
            {
                if MCLocalization.sharedInstance().language == "en"
                {
                    let btnBanner = UIButton()
                    btnBanner.frame = CGRect(x: 0, y: 0, width: listImageView.frame.width, height: listImageView.frame.height)
                    
                    btnBanner.tag = obj.offset
                    btnBanner.addTarget(self, action:#selector(self.bannerClick(sender:)) , for: .touchUpInside)
                    
                    loadDataByGCD(url: URL(string: obj.element.image!)!, onsuccess: { (result) in
                        if result != nil
                        {
                            btnBanner.setBackgroundImage(UIImage(data: result as! Data), for: .normal)
                        }
                        
                    })
                    horizontalScrollViewProduct?.addItem(btnBanner)
                }
                else
                {
                    let btnBanner = UIButton()
                    btnBanner.frame = CGRect(x: 0, y: 0, width: listImageView.frame.width, height: listImageView.frame.height)
                    btnBanner.tag = obj.offset
                    btnBanner.addTarget(self, action:#selector(self.bannerClick(sender:)) , for: .touchUpInside)

                    loadDataByGCD(url: URL(string: obj.element.vn_image!)!, onsuccess: { (result) in
                        if result != nil
                        {
                            btnBanner.setBackgroundImage(UIImage(data: result as! Data), for: .normal)
                        }
                        
                    })
                    horizontalScrollViewProduct?.addItem(btnBanner)
                }
            }

        }
        
    }
    func callBackIndexPage(indexPage: Int) {
         self.pageControl.currentPage = indexPage
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
