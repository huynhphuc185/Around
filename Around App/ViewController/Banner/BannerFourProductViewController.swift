//
//  BannerFourProductViewController.swift
//  Around
//
//  Created by Phuc Huynh on 8/30/17.
//  Copyright © 2017 phuc.huynh. All rights reserved.
//

import UIKit

class BannerFourProductViewController: StatusbarViewController,ASHHorizontalDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var horizontalScrollViewProduct:ASHorizontalScrollView?
    var listBanner: BannerObject?
    var listChunkBanner : [AnyObject] = []
    
    @IBOutlet weak var viewlistProduct : UIView!
    @IBOutlet weak var pageControl : UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        listChunkBanner = (self.listBanner?.contents?.chunk(4))! as [AnyObject]
        self.view.layoutIfNeeded()
        self.horizontalScrollViewProduct = ASHorizontalScrollView(frame:CGRect(x: 0, y: 0, width: self.viewlistProduct.frame.size.width, height: self.viewlistProduct.frame.size.height))
        self.horizontalScrollViewProduct?.uniformItemSize = CGSize(width: self.viewlistProduct.frame.size.width, height: self.viewlistProduct.frame.size.height)
        self.horizontalScrollViewProduct?.setItemsMarginOnce()
        self.viewlistProduct.addSubview(self.horizontalScrollViewProduct!)
        
        self.setTypeViewDataRelateProductt()
        self.horizontalScrollViewProduct?.delegateHorizon = self
       
    }

    
    func setTypeViewDataRelateProductt()
    {

            if listChunkBanner.count == 1
            {
                self.pageControl?.isHidden = true
            }
            else
            {
                self.pageControl?.numberOfPages = listChunkBanner.count
            }
     
        
        for obj in (listChunkBanner.enumerated())
        {
           // let bannerObj = obj.element as
            let view = BannerFourProductCollectionView.instanceFromNib() as! BannerFourProductCollectionView
            view.mainColectionView.delegate = self
            view.mainColectionView.dataSource = self
            view.mainColectionView.tag = obj.offset
            view.mainColectionView.register(UINib(nibName: "BannerFourProductCell", bundle: nil), forCellWithReuseIdentifier: "BannerFourProductCell")
            let italicWordAttribute = [ NSFontAttributeName: UIFont(name: "OpenSans-Italic", size: 13)! ]
            let regularWordAttribute = [ NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 13)! ]
            
            let fromString = NSMutableAttributedString(string: MCLocalization.string(forKey: "FROM") , attributes: italicWordAttribute )
            let toString = NSMutableAttributedString(string: " " + MCLocalization.string(forKey: "TO") , attributes: italicWordAttribute )
            
            let startDate = NSMutableAttributedString(string: " " + changeFormatTime(timeString: (listBanner?.start_date!)!, oldFormat: "yyyy-MM-dd HH:mm:ss", newFormat: "dd/MM")  , attributes: regularWordAttribute )
            let endDate = NSMutableAttributedString(string: " " + changeFormatTime(timeString: (listBanner?.end_date!)!, oldFormat: "yyyy-MM-dd HH:mm:ss", newFormat: "dd/MM") , attributes: regularWordAttribute )
            
            let finalText = NSMutableAttributedString()
            
            finalText.append(fromString)
            finalText.append(startDate)
            finalText.append(toString)
            finalText.append(endDate)
            view.lbldate.attributedText = finalText
            if MCLocalization.sharedInstance().language == "en"
            {
                view.lblTitle.text = listBanner?.title
            }
            else
            {
                view.lblTitle.text = listBanner?.vn_title
            }
            horizontalScrollViewProduct?.addItem(view)
            
            
        }
        
    }
    func muangay(sender: UIButton)
    {
        
        let productID = listBanner?.contents?[sender.tag + pageControl.currentPage * 4].product?.id
        DataConnect.addItemToCart(token_API, country_code: kCountryCode, phone: userPhone_API, id_product: productID! ,attributes: "" , view: self.view,  onsuccess: { (result) in
            
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
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listChunkBanner[collectionView.tag].count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerFourProductCell", for: indexPath) as! BannerFourProductCell
        
        let item  = listChunkBanner[collectionView.tag] as! [ContentObject]
        if let url = URL(string: (item[indexPath.row].product?.image!)!),let placeholder = UIImage(named: "default_product") {
            cell.imageProduct.sd_setImageWithURLWithFade(url, placeholderImage: placeholder)
        }
        cell.lblNameProduct.text = item[indexPath.row].product?.name
        cell.lblPrice.text =  (item[indexPath.row].product?.price?.stringFormattedWithSeparator)! + "đ"
        
        if item[indexPath.row].product?.save_percent == 0 || item[indexPath.row].product?.save_percent == nil
        {
            cell.viewSaleOff.isHidden = true
            cell.lblgiamgia.isHidden = true
            cell.lblSafeOff.isHidden = true
            cell.contrainsHeightTietKiem?.constant = 0
        }
        else
        {
            cell.viewSaleOff.isHidden = false
            cell.lblgiamgia.isHidden = false
            cell.lblSafeOff.isHidden = false
            cell.lblSafeOff.text = String(format: "%d", (item[indexPath.row].product?.save_percent)!) + "%"
            cell.contrainsHeightTietKiem?.constant = 15
        }
        cell.contentView.layoutIfNeeded()
        let attributedString = NSMutableAttributedString(string: (item[indexPath.row].product?.old_price?.stringFormattedWithSeparator)! + "đ")
        attributedString.addAttribute(NSStrikethroughStyleAttributeName, value: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue), range: NSMakeRange(0, attributedString.length))
        attributedString.addAttribute(NSStrikethroughColorAttributeName, value: UIColor(hex: "0b7cc2"), range: NSMakeRange(0, attributedString.length))
        cell.lblPriceSale.attributedText = attributedString
        cell.btnMuaNgay.tag = indexPath.row
        cell.btnMuaNgay.addTarget(self, action:#selector(self.muangay(sender:)) , for: .touchUpInside)
        
        
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsInLine: CGFloat = 2
        
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let minimumInteritemSpacing = self.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: indexPath.section)
        
        let itemWidth = (collectionView.frame.width - inset.left - inset.right - minimumInteritemSpacing * (numberOfItemsInLine - 1)) / numberOfItemsInLine - 6
        let itemHeight = collectionView.frame.height/2 - 6
        
        return CGSize(width: itemWidth, height: itemHeight)
        
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 6
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }

   
}
