//
//  DetailViewProductViewController.swift
//  Around
//
//  Created by phuc.huynh on 1/22/17.
//  Copyright © 2017 phuc.huynh. All rights reserved.
//

import UIKit

class DetailViewProductViewController: StatusBarWithSearchBarViewController,UITableViewDelegate,UITableViewDataSource,ASHHorizontalDelegate {
    
    
    @IBOutlet weak var star_viewProduct: FloatRatingView!
    @IBOutlet weak var lblNameProduct: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPriceSaleOff: UILabel!
    @IBOutlet weak var lblAboutThisItem: UILabel!
    @IBOutlet weak var tblViewThuocTinh: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint?
    @IBOutlet weak var viewImageProduct: UIView!
    @IBOutlet weak var viewRelate: UIView!
    @IBOutlet weak var bgTopProductGradian: UIImageView!
    @IBOutlet weak var lblalsoLike: UILabel!
    @IBOutlet weak var constraintHeightlblThuocTinh : NSLayoutConstraint?
    @IBOutlet weak var contrainsHeightTietKiem : NSLayoutConstraint?
    @IBOutlet weak var constraintHeightRelateView: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightbtnSeeMore : NSLayoutConstraint!
    @IBOutlet weak var constraintHeightlineThuocTinh : NSLayoutConstraint!
    @IBOutlet weak var constraintTopAboutThisItem : NSLayoutConstraint!
    @IBOutlet weak var btnSeeMore_ : UIButton!
    @IBOutlet weak var lblTietKiem : UILabel!
    @IBOutlet weak var imageViewlike : UIImageView!
    @IBOutlet weak var lblNumberLike : UILabel!
    @IBOutlet weak var lblTietKiemLayout : UILabel!
    @IBOutlet weak var lblTotalRate : UILabel!
    @IBOutlet weak var lblShopName : UILabel!
    @IBOutlet weak var lblDetailShop : UILabel!
    @IBOutlet weak var viewShopPolicy : UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnLikeLayout: UIButton!
    var list_Attribute_choose : [Attributes] = []
    var horizontalScrollViewImageProduct:ASHorizontalScrollView?
    var horizontalScrollViewRelateProduct:ASHorizontalScrollView?
    var horizontalScrollViewShop:ASHorizontalScrollView?
    var detailProductObj: DetailProduct?
    var product_ID : Int?
    var indexImageProduct: Int = 0
    var pageIndex = 1
    var listRelateProduct : [Product] = []
    var kindOfProduct : String?
    var indexRelateProductChoose = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewWhiteFirst = UIView(frame: CGRect(x: 0, y: 64, width: ScreenSize.SCREEN_WIDTH, height: ScreenSize.SCREEN_HEIGHT - 64))
        viewWhiteFirst.backgroundColor = UIColor.white
        self.view.addSubview(viewWhiteFirst)
        self.star_viewProduct.isHidden = true
        searchBar.delegate = self
        let colors =  [UIColor(hex: "#ffffff").cgColor, UIColor(hex: "#ffffff").cgColor]
        let image = setGradian(bounds: bgTopProductGradian.bounds , colors: colors, startPoint: nil, endPoint: nil)
        bgTopProductGradian.image = image
        DataConnect.getDetailProduct(token_API, country_code: kCountryCode, phone: userPhone_API, id_product: product_ID!, view: viewWhiteFirst, onsuccess: { (result) in
            self.star_viewProduct.isHidden = false
            self.detailProductObj = result as? DetailProduct
            self.star_viewProduct.rating = Float((self.detailProductObj?.rating!)!)
            if self.detailProductObj?.is_like == true
            {
                self.imageViewlike.image = UIImage(named:"likecam")
                self.btnLikeLayout.isEnabled = false
                
            }
            else
            {
                self.imageViewlike.image = UIImage(named:"liketrang")
                self.btnLikeLayout.isEnabled = true
                
            }
            self.lblNumberLike.text = String(format: "%.0lf", ((self.detailProductObj?.total_like!)!))
            
            if let price = self.detailProductObj?.save_price, let percent = self.detailProductObj?.save_percent
            {
                if price == 0 && percent == 0
                {
                    self.contrainsHeightTietKiem?.constant = 0
                    self.lblTietKiem.isHidden = true
                    self.lblTietKiemLayout.isHidden = true
                }
                else
                {
                    self.lblTietKiem.text = String(format: "%@ (%d", price.stringFormattedWithSeparator, percent) + "%)"
                }
                
            }
            if let totalRate = self.detailProductObj?.total_rating
            {
                if totalRate == 0
                {
                    self.lblTotalRate.isHidden = true
                }
                else
                {
                    self.lblTotalRate.text = String(format: "(%d)", totalRate)
                }
            }
            self.lblNameProduct.text = self.detailProductObj?.name
            self.lblPrice.text = (self.detailProductObj?.price?.stringFormattedWithSeparator)! + "đ"
            if self.detailProductObj?.old_price == 0 || self.detailProductObj?.old_price == nil
            {
                self.lblPriceSaleOff.text = ""
            }
            else{
                let attributedString = NSMutableAttributedString(string: (self.detailProductObj?.old_price?.stringFormattedWithSeparator)! + "đ")
                attributedString.addAttribute(NSStrikethroughStyleAttributeName, value: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue), range: NSMakeRange(0, attributedString.length))
                attributedString.addAttribute(NSStrikethroughColorAttributeName, value: UIColor(hex: "0b7cc2"), range: NSMakeRange(0, attributedString.length))
                self.lblPriceSaleOff.attributedText = attributedString
            }
            
            
            
            self.lblAboutThisItem.text = self.detailProductObj?.description_
            if self.lblAboutThisItem.isTruncated()
            {
                self.constraintHeightbtnSeeMore.constant = 29
                self.btnSeeMore_.isHidden = false
            }
            else
            {
                self.constraintHeightbtnSeeMore.constant = 0
                self.btnSeeMore_.isHidden = true
            }

            self.horizontalScrollViewImageProduct = ASHorizontalScrollView(frame:CGRect(x: 0, y: 0, width: self.viewImageProduct.frame.size.width, height: self.viewImageProduct.frame.size.height))
            self.horizontalScrollViewImageProduct?.uniformItemSize = CGSize(width: self.viewImageProduct.frame.size.width, height: self.viewImageProduct.frame.size.height)
            self.horizontalScrollViewImageProduct?.setItemsMarginOnce()
            self.viewImageProduct.addSubview(self.horizontalScrollViewImageProduct!)
            self.setTypeViewDataImageProduct(list: (self.detailProductObj?.images)!)
            if let pageControlNumber = self.detailProductObj?.images?.count{
                if pageControlNumber == 1
                {
                    self.pageControl.isHidden = true
                }
                else
                {
                    self.pageControl.numberOfPages = pageControlNumber
                }
                
            }
            self.horizontalScrollViewImageProduct?.delegateHorizon = self
            
            self.lblShopName.text = self.detailProductObj?.shop_name
            
            if MCLocalization.sharedInstance().language == "en"
            {
                self.lblDetailShop.text = self.detailProductObj?.text_policy?.title
            }
            else
            {
                self.lblDetailShop.text = self.detailProductObj?.text_policy?.vn_title
            }
            
            
            
            
            
            if (self.detailProductObj?.attributes?.count)! > 0
            {
                self.tableViewHeightConstraint?.constant = CGFloat((self.detailProductObj?.attributes?.count)! * 80)
                self.tblViewThuocTinh.reloadData {
                }
                
            }
            else
            {
                self.constraintHeightlblThuocTinh?.constant = 0
                self.tableViewHeightConstraint?.constant = 0
                self.constraintHeightlineThuocTinh.constant = 0
                self.constraintTopAboutThisItem.constant = -10
            }
            
            self.horizontalScrollViewShop = ASHorizontalScrollView(frame:CGRect(x: 0, y: 0, width: self.viewShopPolicy.frame.size.width, height: self.viewShopPolicy.frame.size.height))
            self.horizontalScrollViewShop?.uniformItemSize = CGSize(width: self.viewShopPolicy.frame.size.width/2 - 5 , height: self.viewShopPolicy.frame.size.height)
            self.horizontalScrollViewShop?.setItemsMarginOnce()
            self.viewShopPolicy.addSubview(self.horizontalScrollViewShop!)
            self.setTypeViewDataImageShop(list: (self.detailProductObj?.image_policy)!)
            self.view.layoutIfNeeded()
        }) { (error) in
            self.star_viewProduct.isHidden = false
            showErrorMessage(error: error as! Int, vc: self)
        }
        DataConnect.getRelateProduct(token_API, country_code: kCountryCode, phone: userPhone_API, id_product: product_ID!, page: self.pageIndex, view: self.view, onsuccess: { (result) in
            if (result as? [Product])!.count == 0
            {
                self.lblalsoLike.isHidden = true
                self.constraintHeightRelateView.constant = 0
                self.view.layoutIfNeeded()
                return
            }
            self.horizontalScrollViewRelateProduct = ASHorizontalScrollView(frame:CGRect(x: 0, y: 0, width: self.viewRelate.frame.size.width, height: self.viewRelate.frame.size.height))
            self.horizontalScrollViewRelateProduct?.uniformItemSize = CGSize(width: 112, height: 153)
            self.horizontalScrollViewRelateProduct?.setItemsMarginOnce()
            self.viewRelate.addSubview(self.horizontalScrollViewRelateProduct!)
            self.setTypeViewDataRelateProductt(list: (result as? [Product])!)
            
            
        }) { (error) in
            showErrorMessage(error: error as! Int, vc: self)
        }
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        makeTopNavigationSearchbar(isMenuScreen: false,isCartScreen: false,needShake: false)
        
    }

    // MARK: IBACTION
    
    @IBAction func btnSeeMoreDetail (_ sender: UIButton){
        self.lblAboutThisItem.numberOfLines = 0
        self.btnSeeMore_.isHidden = true
        self.constraintHeightbtnSeeMore.constant = 0
        self.view.layoutIfNeeded()
    }
    
    @IBAction func btnLike (_ sender: UIButton)
    {
        DataConnect.likeProduct(token_API, country_code: kCountryCode, phone: userPhone_API, id_product: product_ID!, view: self.view, onsuccess: { (result) in
            self.imageViewlike.image = UIImage(named:"likecam")
            self.lblNumberLike.text = String(format: "%.0lf", ((self.detailProductObj?.total_like!)! + 1))
            self.btnLikeLayout.isEnabled = false
        }) { (error) in
            showErrorMessage(error: error as! Int, vc: self)
        }
    }
    
    @IBAction func btnComment (_ sender: UIButton)
    {
        let vc = giftingStoryBoard.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
        vc.id_product = product_ID
        vc.enableRate = detailProductObj?.is_rate
        let nvc = UINavigationController(rootViewController: vc)
        self.present(nvc, animated: true, completion: nil)
        
    }
    @IBAction func btnSeeMore (_ sender: UIButton)
    {
        let vc = giftingStoryBoard.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
        vc.id_product = product_ID
        vc.enableRate = detailProductObj?.is_rate
        let nvc = UINavigationController(rootViewController: vc)
        self.present(nvc, animated: true, completion: nil)
        
        
    }
    @IBAction func btnRelate (_ sender: UIButton)
    {
        let vc = giftingStoryBoard.instantiateViewController(withIdentifier: "RelateProductViewController") as! RelateProductViewController
        vc.id_product = product_ID
        let nvc = UINavigationController(rootViewController: vc)
        self.present(nvc, animated: false, completion: nil)
    }
    @IBAction func btnBuyNow (_ sender: UIButton)
    {
        tracking(actionKey: "C14.3Y")
        let listJsonArray = NSMutableArray()
        for item in (list_Attribute_choose.enumerated())
        {
            if let json = item.element.toJSON() {
                listJsonArray.add(convertStringToDictionary(json)!)
            }
        }
        
        
        let myJson = arrayDictToJSON(dictionaryOrArray: listJsonArray)
        
        DataConnect.addItemToCart(token_API, country_code: kCountryCode, phone: userPhone_API, id_product: product_ID!,attributes: myJson! , view: self.view,  onsuccess: { (result) in
            let vc = giftingStoryBoard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
            //self.navigationController?.pushViewController(vc, animated: true)
        }, onFailure: { (error) in
            showErrorMessage(error: error as! Int, vc: self)
        })
        
    }
    
    @IBAction func btnAddtocart (_ sender: UIButton)
    {
        tracking(actionKey: "C14.4Y")
        let listJsonArray = NSMutableArray()
        for item in (list_Attribute_choose.enumerated())
        {
            if let json = item.element.toJSON() {
                listJsonArray.add(convertStringToDictionary(json)!)
            }
        }
        
        let myJson = arrayDictToJSON(dictionaryOrArray: listJsonArray)
        
        DataConnect.addItemToCart(token_API, country_code: kCountryCode, phone: userPhone_API, id_product: product_ID!,attributes: myJson! , view: self.view,  onsuccess: { (result) in
            appDelegate.listSelected.append(self.product_ID!)
            appDelegate.listSelected = appDelegate.listSelected.removeDuplicates()
            self.makeTopNavigationSearchbar(isMenuScreen: false,isCartScreen: false,needShake: true)
            
        }, onFailure: { (error) in
            showErrorMessage(error: error as! Int, vc: self)
        })
        
        
        
    }
    // MARK: FUNCTION
    func callBackIndexPage(indexPage: Int) {
        self.pageControl.currentPage = indexPage
    }
    func setTypeViewDataImageProduct(list: [ImageProduct])
    {
        
        for item in (list.enumerated()){
            let imageView = UIImageView(frame: CGRect.zero)
            imageView.contentMode = .scaleAspectFit
            imageView.sd_setImage(with: URL(string: item.element.url!), placeholderImage: nil)
            horizontalScrollViewImageProduct?.addItem(imageView)
        }
        
        
        
    }
    
    func setTypeViewDataImageShop(list: [ImagePolicy])
    {
        
        for item in (list.enumerated()){
            
            
            //            let view = UIView(frame: CGRect.zero)
            //            view.layer.borderColor = UIColor.red.cgColor
            //            view.layer.borderWidth = 1
            
            let imageView = UIImageView(frame: CGRect.zero)
            imageView.contentMode = .scaleAspectFit
            if MCLocalization.sharedInstance().language == "en"
            {
                imageView.sd_setImage(with: URL(string: item.element.image!), placeholderImage: nil)
            }
            else
            {
                imageView.sd_setImage(with: URL(string: item.element.vn_image!), placeholderImage: nil)
            }
            
            
            horizontalScrollViewShop?.addItem(imageView)
        }
        
        
        
    }
    
    
    func setTypeViewDataRelateProductt(list: [Product])
    {
        for item in (list.enumerated()){
            listRelateProduct.append(item.element)
            let view = RelateImageCell.instanceFromNib() as! RelateImageCell
            view.bg.backgroundColor = UIColor.white
            view.imageProduct.sd_setImage(with: URL(string: item.element.image!), placeholderImage: nil)
            view.lblName.text = item.element.name
            view.lblPrice.text =  (item.element.price?.stringFormattedWithSeparator)! + "đ"
            view.btnChoose.tag = indexRelateProductChoose
            indexRelateProductChoose += 1
            view.btnChoose.addTarget(self, action:#selector(self.selectProductRelate(sender:)) , for: .touchUpInside)
            horizontalScrollViewRelateProduct?.addItem(view)
        }
        
        let button = UIButton(frame: CGRect.zero)
        button.setTitleColor(UIColor(hex:colorXam), for: .normal)
        button.setTitle(MCLocalization.string(forKey: "MORE"), for: .normal)
        button.titleLabel!.font =  UIFont(name: "Arial", size: 18)
        button.addTarget(self, action:#selector(self.addMoreRelateProduct) , for: .touchUpInside)
        horizontalScrollViewRelateProduct?.addItem(button)
    }
    
    func addMoreRelateProduct()
    {
        pageIndex += 1
        horizontalScrollViewRelateProduct?.removeItem((horizontalScrollViewRelateProduct?.items.last)!)
        DataConnect.getRelateProduct(token_API, country_code: kCountryCode, phone: userPhone_API, id_product: product_ID!, page: pageIndex, view: self.view, onsuccess: { (result) in
            if let arr = result as? [Product]
            {
                if arr.count == 0
                {
                    return
                }
                
                self.setTypeViewDataRelateProductt(list: arr)
            }
        }) { (error) in
            showErrorMessage(error: error as! Int, vc: self)
        }
        
        
    }
    func selectProductRelate(sender: UIButton)
    {
        let vc = giftingStoryBoard.instantiateViewController(withIdentifier: "DetailViewProductViewController") as! DetailViewProductViewController
        vc.product_ID = listRelateProduct[sender.tag].id
        vc.kindOfProduct = kindOfProduct
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.detailProductObj != nil
        {
            return  (self.detailProductObj?.attributes?.count)!
            
        }
        else
        {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let objThuocTinh = self.detailProductObj?.attributes?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThuocTinhCell") as! ThuocTinhCell
        cell.mainView.layer.borderColor = UIColor(hex:colorXam).cgColor
        cell.mainView.layer.borderWidth = 1.0
        cell.mainView.layer.cornerRadius = 3.0
        cell.btnNext.tag = indexPath.row
        cell.btnPrevious.tag = indexPath.row
        if MCLocalization.sharedInstance().language == "en"
        {
            cell.lblThuoctinh.text = objThuocTinh?.name_attribute
        }
        else
        {
            cell.lblThuoctinh.text = objThuocTinh?.vn_name_attribute
        }
        cell.setTypeViewData(list: (objThuocTinh?.data)!)
        cell.blockCallBack =  { [weak self]
            (result) in
            let index = result as? Int
            let obj = Attributes()
            obj.id_attribute = objThuocTinh?.id_attribute
            obj.id_data = objThuocTinh?.data?[index!].id_data
            for item in (self?.list_Attribute_choose.enumerated())!
            {
                if item.element.id_attribute == obj.id_attribute
                {
                    self?.list_Attribute_choose.remove(at: item.offset)
                }
            }
            self?.list_Attribute_choose.append(obj)
            
        }
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}



class ThuocTinhCell : UITableViewCell,ASHHorizontalDelegate
{
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var lblThuoctinh: UILabel!
    @IBOutlet weak var mainView: UIView!
    var blockCallBack : callBack?
    let horizontalScrollView = ASHorizontalScrollView()
    var indexScroll = 3
    func setTypeViewData(list: [DataAtribute])
    {
        
        viewContent.addSubview(horizontalScrollView)
        let top = NSLayoutConstraint(item: horizontalScrollView, attribute: .top, relatedBy: .equal, toItem: viewContent, attribute: .top, multiplier: 1, constant: 0)
        let lead = NSLayoutConstraint(item: horizontalScrollView, attribute: .leading, relatedBy: .equal, toItem: viewContent, attribute: .leading, multiplier: 1, constant: 0)
        let trail = NSLayoutConstraint(item: horizontalScrollView, attribute: .trailing, relatedBy: .equal, toItem: viewContent, attribute: .trailing, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: horizontalScrollView, attribute: .bottom, relatedBy: .equal, toItem: viewContent, attribute: .bottom, multiplier: 1, constant: 0)
        horizontalScrollView.autoresizesSubviews = false
        horizontalScrollView.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addConstraints([top,lead,trail,bottom])
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        if  DeviceType.IS_IPHONE_6P {
            horizontalScrollView.uniformItemSize = CGSize(width: 50, height: viewContent.frame.size.height)
        }
        else
        {
            horizontalScrollView.uniformItemSize = CGSize(width: 40, height: viewContent.frame.size.height)
        }
        
        horizontalScrollView.setItemsMarginOnce()
        horizontalScrollView.delegateHorizon = self
        for item in (list.enumerated()){
            let firstCharIndex = item.element.name_data?.index((item.element.name_data?.startIndex)!, offsetBy: 1)
            let firstChar = item.element.name_data?.substring(to: firstCharIndex!)
            if firstChar == "#"
            {
                let button = UIButton(frame: CGRect.zero)
                button.backgroundColor = UIColor(hex: item.element.name_data!)
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.clear.cgColor
                button.layer.cornerRadius = 2
                button.tag = item.offset
                button.addTarget(self, action:#selector(self.selectedType(sender:)) , for: .touchUpInside)
                horizontalScrollView.addItem(button)
            }
            else
            {
                let button = UIButton(frame: CGRect.zero)
                button.setTitleColor(UIColor(hex:colorXam), for: .normal)
                button.setTitle(item.element.name_data, for: .normal)
                button.titleLabel!.font =  UIFont(name: "Arial", size: 13)
                button.backgroundColor = UIColor.white
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor(hex: colorXam).cgColor
                button.layer.cornerRadius = 2
                button.tag = item.offset
                button.addTarget(self, action:#selector(self.selectedType(sender:)) , for: .touchUpInside)
                horizontalScrollView.addItem(button)
            }
            
        }
        var widthViewContent : CGFloat = 240
        if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5
        {
            widthViewContent = 146
            indexScroll = 3
        }
        else if DeviceType.IS_IPHONE_6  {
            widthViewContent = 201
            indexScroll = 4
        }
        else if DeviceType.IS_IPHONE_6P {
            widthViewContent = 240
            indexScroll = 4
        }
        if widthViewContent >= horizontalScrollView.contentSize.width - horizontalScrollView.marginSettings.leftMargin
        {
            btnPrevious.isEnabled = false
            btnNext.isEnabled = false
            horizontalScrollView.isScrollEnabled = false
        }
        else
        {
            btnPrevious.isEnabled = false
            btnNext.isEnabled = true
        }
        
    }
    
    func selectedType(sender: UIButton)
    {
        
        let firstCharIndex = sender.title(for: .normal)?.index((sender.title(for: .normal)!.startIndex), offsetBy: 1)
        let firstChar = sender.title(for: .normal)?.substring(to: firstCharIndex!)
        if firstChar == nil
        {
            for item in (horizontalScrollView.items.enumerated())
            {
                let button = item.element as? UIButton
                button?.layer.borderColor = UIColor.clear.cgColor
                button?.layer.borderWidth = 1
                button?.layer.cornerRadius = 2
            }
            sender.layer.borderColor = UIColor(hex: "0b7cc2").cgColor
            sender.layer.borderWidth = 2.5
            sender.layer.cornerRadius = 2
            //sender.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            self.blockCallBack!(sender.tag as AnyObject)
            
        }
        else
        {
            for item in (horizontalScrollView.items.enumerated())
            {
                let button = item.element as? UIButton
                button?.backgroundColor = UIColor.white
                button?.layer.borderColor = UIColor(hex: colorXam).cgColor
                button?.setTitleColor(UIColor(hex: colorXam), for: .normal)
            }
            sender.backgroundColor = UIColor(hex: colorXamNhat)
            sender.layer.borderColor = UIColor.clear.cgColor
            sender.setTitleColor(UIColor.white, for: .normal)
            self.blockCallBack!(sender.tag as AnyObject)
            
        }
    }
    func checkNextPreviousButton()
    {
        //let contentX = horizontalScrollView.contentOffset.x  + horizontalScrollView.frame.width
    }
    @IBAction func btnNext (_ sender: UIButton)
    {
        //tracking(actionKey: "C14.1Y")
        let needContentX = (horizontalScrollView.contentOffset.x) + horizontalScrollView.uniformItemSize.width + horizontalScrollView.itemsMargin
        
        horizontalScrollView.nextItem(x: needContentX)
        
        
        
    }
    @IBAction func btnPrevious (_ sender: UIButton)
    {
        let needContentX = (horizontalScrollView.contentOffset.x) - horizontalScrollView.uniformItemSize.width - horizontalScrollView.itemsMargin
        horizontalScrollView.nextItem(x: needContentX)
        // horizontalScrollView.setContentOffset(CGPoint(x: needContentX, y: 0), animated: true)
        
    }
    
    func callBackIndexPage(indexPage: Int) {
        if indexPage == 0
        {
            btnNext.isEnabled = true
            btnPrevious.isEnabled = false
        }
        else if indexPage == horizontalScrollView.items.count - indexScroll
        {
            btnNext.isEnabled = false
            btnPrevious.isEnabled = true
        }
        else
        {
            btnNext.isEnabled = true
            btnPrevious.isEnabled = true
        }
        
        
    }
    
}
