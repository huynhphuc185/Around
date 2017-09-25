//
//  StatusBarWithSearchBarViewController.swift
//  Around
//
//  Created by phuc.huynh on 12/19/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import UIKit

class StatusBarWithSearchBarViewController: UIViewController,UISearchBarDelegate {
    var searchBar = UISearchBar()
    var leftSearchBarButtonItem: UIBarButtonItem?
    var rightSearchBarButtonItem: [UIBarButtonItem]?
    let cartButton: MIBadgeButton = MIBadgeButton()
    let cartTitle: MIBadgeButton = MIBadgeButton()
    var countOfNumberCart : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.setStatusBarHidden(false, with: .none)
    }
    
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        // self.navigationController?.navigationBar.barStyle = .black
        return .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation
    {
        return UIStatusBarAnimation.slide
    }
    
    
    
    //Search Bar Appear & Disappear
    func showSearchBar() {
        searchBar.isHidden =  false
        searchBar.alpha = 0
        navigationItem.titleView = searchBar
        navigationItem.setLeftBarButton(nil, animated: true)
        navigationItem.setRightBarButtonItems(nil, animated: true)
        
        UIView.animate(withDuration:0.5, animations: {
            self.searchBar.alpha = 1
        }, completion: { finished in
            self.enableCancleButton(searchBar: self.searchBar)
            self.searchBar.setPlaceholderTextColor(color: UIColor(hex: "f8bf00"))
            self.searchBar.setSearchImageColor(color: .white)
            self.searchBar.setTextFieldClearButtonColor(color: .white)
        })
    }
    
    func hideSearchBar() {
        
        hideSearchBarAndMakeUIChanges()
        UIView.animate(withDuration: 0.3, animations: {
            
            //   self.logoImageView.alpha = 1
        }, completion: { finished in
            
        })
    }
    func backAction()
    {
        if self is DetailViewProductViewController
        {
            tracking(actionKey: "C14.7N")
        }
        self.navigationController?.popViewController(animated: true)
    }
    func dissmiss()
    {
        if let cartVC = self as? CartViewController
        {
            tracking(actionKey: "C15.7N")
            if cartVC.cartObj.product.count == 0
            {
                 self.dismiss(animated: true, completion: nil)
            }
            else
            {
                DataConnect.updateDeliveryInfo(token_API, country_code: kCountryCode, phone: userPhone_API, recipent_name: cartVC.txtRecieptname.text!, recipent_phone: cartVC.txtRecipentPhone.text!, recipent_note: cartVC.txtNote.text!, onsuccess: { (result) in
                    self.dismiss(animated: true, completion: nil)
                }) { (error) in
                }
            }

        }
        else
        {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    //Making secondary Searchbar
    func makeTopNavigationSearchbar(isMenuScreen : Bool, isCartScreen: Bool, needShake: Bool)
    {
        activateInitialUISetUp()
        hideSearchBar()
        if self is HomeGiftingViewController || self is MainCategoryViewController || self is SearchProductViewController
        {
            if self is HomeGiftingViewController {
                
                DataConnect.getOrderNumber(token_API, country_code: kCountryCode, phone: userPhone_API, onsuccess: { (result) in
                    let numberLeftMenu = result as? NumberLeftMenu
                    let total = (numberLeftMenu?.number_event)! + (numberLeftMenu?.number_order)! + (numberLeftMenu?.number_notification)!
                    if total == 0
                    {
                        self.leftSearchBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
                    }
                    else
                    {
                        let btnNotiMenu = MIBadgeButton()
                        btnNotiMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
                        btnNotiMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                        btnNotiMenu.setImage(UIImage(named: "menu"), for: .normal)
                        btnNotiMenu.badgeString = String(format: "%d", total)
                        let menuNotiBarButton = UIBarButtonItem(customView: btnNotiMenu)
                        self.leftSearchBarButtonItem = menuNotiBarButton
                    }
                    self.navigationItem.leftBarButtonItem = self.leftSearchBarButtonItem
                    
                }) { (error) in
                    self.leftSearchBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
                    self.navigationItem.leftBarButtonItem = self.leftSearchBarButtonItem
                }
            }
            else{
                leftSearchBarButtonItem = UIBarButtonItem(image: UIImage(named: "back x2"), style: .plain, target: self, action: #selector(self.backAction))
                navigationItem.leftBarButtonItem = leftSearchBarButtonItem
            }
            
            cartButton.addTarget(self, action: #selector(self.cartClick), for: UIControlEvents.touchUpInside)
            cartButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            cartButton.setImage(UIImage(named: "cart_icon_white"), for: .normal)
            let cartBarButton = UIBarButtonItem(customView: cartButton)
            rightSearchBarButtonItem = [cartBarButton]
            navigationItem.rightBarButtonItems = rightSearchBarButtonItem
            searchBar.searchBarStyle = UISearchBarStyle.minimal
            leftSearchBarButtonItem?.tintColor =  UIColor.white
            rightSearchBarButtonItem?[0].tintColor =  UIColor.white
            DataConnect.getNumberProductnCart(token_API, country_code: kCountryCode, phone: userPhone_API,view: self.view, onsuccess: { (result) in
                self.countOfNumberCart = result as! Int
                if (result as? Int) == 0 || isCartScreen == true
                {
                    if (result as? Int) == 0
                    {
                        self.cartButton.badgeString =  ""
                    }
                    else
                    {
                        self.cartButton.badgeString =  String(format: "%d", (result as? Int)!)
                    }
                    self.rightSearchBarButtonItem?[0].isEnabled = false
                }
                else{
                    self.cartButton.badgeString =  String(format: "%d", (result as? Int)!)
                    self.rightSearchBarButtonItem?[0].isEnabled = true
                }
                if needShake
                {
                    self.cartButton.bounce(nil)
                }
                
            }) { (error) in
                showErrorMessage(error: error as! Int, vc: self)
            }
            
        }
        else if self is CartViewController
        {
            leftSearchBarButtonItem = UIBarButtonItem(image: UIImage(named: "close x2"), style: .plain, target: self, action: #selector(self.dissmiss))
            navigationItem.leftBarButtonItem = leftSearchBarButtonItem
            leftSearchBarButtonItem?.tintColor =  UIColor.white
            
            DataConnect.getNumberProductnCart(token_API, country_code: kCountryCode, phone: userPhone_API,view: self.view, onsuccess: { (result) in
                self.countOfNumberCart = result as! Int
                if (result as? Int) == 0 || isCartScreen == true
                {
                    if (result as? Int) == 0
                    {
                        self.cartTitle.badgeString =  ""
                    }
                    else
                    {
                        self.cartTitle.badgeString =  String(format: "%d", (result as? Int)!)
                    }
                }
                else{
                    self.cartTitle.badgeString =  String(format: "%d", (result as? Int)!)
                }
                if needShake
                {
                    self.cartTitle.bounce(nil)
                }
                
                
            }) { (error) in
                showErrorMessage(error: error as! Int, vc: self)
            }
            
        }
        else
        {
            
            if self is CommentViewController || self is RelateProductViewController || self is WriteCommentViewController{
                leftSearchBarButtonItem = UIBarButtonItem(image: UIImage(named: "close x2"), style: .plain, target: self, action: #selector(self.dissmiss))
                navigationItem.leftBarButtonItem = leftSearchBarButtonItem
            }
            else{
                leftSearchBarButtonItem = UIBarButtonItem(image: UIImage(named: "back x2"), style: .plain, target: self, action: #selector(self.backAction))
                navigationItem.leftBarButtonItem = leftSearchBarButtonItem
                let searchBarButton = UIBarButtonItem(image: UIImage(named: "search_icon"), style: .plain, target: self, action: #selector(self.showSearchBar))
                cartButton.addTarget(self, action: #selector(self.cartClick), for: UIControlEvents.touchUpInside)
                cartButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                cartButton.setImage(UIImage(named: "cart_icon_white"), for: .normal)
                let cartBarButton = UIBarButtonItem(customView: cartButton)
                rightSearchBarButtonItem = [searchBarButton, cartBarButton]
                navigationItem.rightBarButtonItems = rightSearchBarButtonItem
                searchBar.searchBarStyle = UISearchBarStyle.minimal
                leftSearchBarButtonItem?.tintColor =  UIColor.white
                rightSearchBarButtonItem?[0].tintColor =  UIColor.white
                rightSearchBarButtonItem?[1].tintColor =  UIColor.white
                
                DataConnect.getNumberProductnCart(token_API, country_code: kCountryCode, phone: userPhone_API,view: self.view, onsuccess: { (result) in
                    self.countOfNumberCart = result as! Int
                    if (result as? Int) == 0 || isCartScreen == true
                    {
                        if (result as? Int) == 0
                        {
                            self.cartButton.badgeString =  ""
                        }
                        else
                        {
                            self.cartButton.badgeString =  String(format: "%d", (result as? Int)!)
                        }
                        self.rightSearchBarButtonItem?[1].isEnabled = false
                    }
                    else{
                        self.cartButton.badgeString =  String(format: "%d", (result as? Int)!)
                        self.rightSearchBarButtonItem?[1].isEnabled = true
                    }
                    
                    if needShake
                    {
                        self.cartButton.bounce(nil)
                    }
                }) { (error) in
                    showErrorMessage(error: error as! Int, vc: self)
                }
            }
        }
        
    }
    
    private func imageLayerForGradientBackground() -> UIImage {
        
        var updatedFrame = self.navigationController?.navigationBar.bounds
        updatedFrame?.size.height += 20
        let colors =  [UIColor(hex: "#fc8301").cgColor, UIColor(hex: "#f7bf00").cgColor]
        let startPoint = CGPoint(x: 0.0, y: 0.5)
        let endPoint = CGPoint(x: 1.0, y: 0.5)
        let layer = CAGradientLayer.gradientLayerForBounds(bounds: updatedFrame!,colors:colors , startPoint: startPoint,endPoint: endPoint)
        UIGraphicsBeginImageContext(layer.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func enableCancleButton (searchBar : UISearchBar) {
        for view in searchBar.subviews {
            for subview in view.subviews {
                if let button = subview as? UIButton {
                    button.isEnabled = true
                }
            }
        }    }
    //UI-Related Methods
    func activateInitialUISetUp()
    {
        self.navigationController?.isNavigationBarHidden =  false
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "OpenSans-Light", size: 17)!, NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.navigationBar.setBackgroundImage(imageLayerForGradientBackground(), for: UIBarMetrics.default)
        searchBar.showsCancelButton = true
        searchBar.tintColor = UIColor.white
        
        if let textFieldInsideSearchBar = self.searchBar.value(forKey: "searchField") as? UITextField
           {
            textFieldInsideSearchBar.textColor = .white
            textFieldInsideSearchBar.placeholder = MCLocalization.string(forKey: "SEARCHHINT")
            
            }

        if self is MainCategoryViewController
        {
            navigationItem.title = (self as! MainCategoryViewController).kindOfProduct
        }
        else if self is SubCategoryViewController
        {
            navigationItem.title = (self as! SubCategoryViewController).kindOfProduct
        }
        else if self is DetailViewProductViewController
        {
            navigationItem.title = (self as! DetailViewProductViewController).kindOfProduct
        }
            
        else if self is WriteCommentViewController || self is CommentViewController
        {
            navigationItem.title = MCLocalization.string(forKey: "COMMENT")
        }
        else if self is CartViewController{
            cartTitle.setImage(UIImage(named: "cart_icon_white"), for: .normal)
            cartTitle.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            navigationItem.titleView = UIImageView(image: UIImage(named: "cart_icon_white"))
        }
        else
        {
            navigationItem.titleView = UIImageView(image: UIImage(named: "gift"))
        }
        
        
        
    }
    
    func cartClick()
    {
        if let viewVC = self as? SubCategoryViewController
        {
            tracking(actionKey: "C13.4Y")
            for item in (viewVC.pageVC?.orderedViewControllers)!
            {
                 if let vc = item as? PriceCategoryViewController
                 {
                    vc.flagChangetabTitle = true
                }
                
            }
        }
        if self is DetailViewProductViewController
        {
            tracking(actionKey: "C14.5Y")
            let arrVC = self.navigationController?.viewControllers
            var popVC : CartViewController?
            if (arrVC?.count)! > 0
            {
                for item in arrVC!
                {
                    if let viewVC = item as? CartViewController
                    {
                        popVC = viewVC
                        break
                    }
                }
                if popVC != nil
                {
                    
                    self.navigationController?.popToViewController(popVC!, animated: true)
                }
                else
                {
                    let vc = giftingStoryBoard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
                    let nav = UINavigationController(rootViewController: vc)
                    self.present(nav, animated: true, completion: nil)
                }
            }
            else
            {
                let vc = giftingStoryBoard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
                let nav = UINavigationController(rootViewController: vc)
                self.present(nav, animated: true, completion: nil)
            }

        }
        else
        {
            let vc = giftingStoryBoard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
        }

    }
    
    //Adding secondary uibar butttons to navigation bar
    func hideSearchBarAndMakeUIChanges ()
    {
        searchBar.isHidden =  true
        if self is MainCategoryViewController
        {
            navigationItem.titleView = nil
            navigationItem.title = (self as! MainCategoryViewController).kindOfProduct
            
        }
        else if self is DetailViewProductViewController
        {
            navigationItem.titleView = nil
            navigationItem.title = (self as! DetailViewProductViewController).kindOfProduct
        }
        else if self is SubCategoryViewController
        {
            navigationItem.titleView = nil
            navigationItem.title = (self as! SubCategoryViewController).kindOfProduct
        }
        else if self is WriteCommentViewController || self is CommentViewController
        {
            navigationItem.title = MCLocalization.string(forKey: "COMMENT")
        }
        else if self is CartViewController
        {
            cartTitle.setImage(UIImage(named: "cart_icon_white"), for: .normal)
            cartTitle.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            navigationItem.titleView = cartTitle
        }
        else
        {
            navigationItem.titleView = UIImageView(image: UIImage(named: "gift"))
        }
        
        //  navigationItem.title = "Around"
        navigationItem.setLeftBarButton(leftSearchBarButtonItem, animated: true)
        navigationItem.setRightBarButtonItems(rightSearchBarButtonItem, animated: true)
    }
    
    
    func revealController(revealController: SWRevealViewController!, didMoveToPosition position: FrontViewPosition) {
        if(position.rawValue == 3)
        {
            
            
        }
        else
        {
            
        }
        print("position\(position)")
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if self is SubCategoryViewController
        {
            tracking(actionKey: "C13.5Y")
        }
        else if self is DetailViewProductViewController
        {
            tracking(actionKey: "C14.6Y")
        }
        hideSearchBar()
        let vc = giftingStoryBoard.instantiateViewController(withIdentifier: "SearchProductViewController") as! SearchProductViewController
        vc.keyword = searchBar.text
        
        self.navigationController?.pushViewController(vc, animated: true)
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar_: UISearchBar) {

    }
    
    

    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideSearchBar()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
