
//
//  SubCategoryViewController.swift
//  Around
//
//  Created by phuc.huynh on 12/20/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import UIKit

class SubNotificationViewController: StatusbarViewController {
    @IBOutlet weak var sidebarButton: UIBarButtonItem!
    @IBOutlet weak var viewNew: UIView!
    @IBOutlet weak var viewTime: UIView!
    @IBOutlet weak var btnNew: UIButton!
    @IBOutlet weak var btnTime: UIButton!
    @IBOutlet weak var lblNew: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imageNewCuatoi  : UIImageView!
    @IBOutlet weak var imageNewTinMoi  : UIImageView!
    var id_category: Int?
    var kindOfProduct: String?
    
    var pageVC: PageNotificationViewController? {
        didSet {
            pageVC?.subCateDelegate = self
        
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.sidebarButton.action = #selector(self.dissmissViewController)
        btnNew.isSelected = true
        btnTime.isSelected = false
        viewNew.backgroundColor = UIColor(hex: colorCam)
        viewTime.backgroundColor = UIColor.clear
        lblNew.textColor = UIColor(hex: "616161")
        lblTime.textColor = UIColor(hex: "b4b4b4")
        
       
        
    }

    func dissmissViewController()
    {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
       // nav.isNavigationBarHidden = true
        self.navigationController?.isNavigationBarHidden = true
        DataConnect.getOrderNumber(token_API, country_code: kCountryCode, phone: userPhone_API, onsuccess: { (result) in
            let numberLeftMenu = result as? NumberLeftMenu
            if numberLeftMenu?.number_notification == 0 || numberLeftMenu?.number_notification == nil
            {
                self.imageNewCuatoi.isHidden = true
            }
            else
            {
                self.imageNewCuatoi.isHidden = false
            }
            
            if numberLeftMenu?.number_event == 0 || numberLeftMenu?.number_event == nil
            {
                self.imageNewTinMoi.isHidden = true
            }
            else
            {
                self.imageNewTinMoi.isHidden = false
            }
        }) { (error) in
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.∫
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PageNotificationViewController {
            vc.parentVC = self
            pageVC = vc
        }

    }
     @IBAction func btnHotClick (_ sender: UIButton?)
     {
        if btnNew.isSelected == true
        {
            return
        }
        btnNew.isSelected = true
        btnTime.isSelected = false
        viewNew.backgroundColor = UIColor(hex: colorCam)
        lblNew.textColor = UIColor(hex: "616161")
        lblTime.textColor = UIColor(hex: "b4b4b4")
        viewTime.backgroundColor = UIColor.clear
        pageVC?.scrollToViewController(index: 0)
    }
     @IBAction func btnInterestClick (_ sender: UIButton)
     {
        if btnTime.isSelected == true
        {
            return
        }
        btnTime.isSelected = true
        btnNew.isSelected = false
        lblTime.textColor = UIColor(hex: "616161")
        lblNew.textColor = UIColor(hex: "b4b4b4")
        viewTime.backgroundColor = UIColor(hex: colorCam)
        viewNew.backgroundColor = UIColor.clear
        pageVC?.scrollToViewController(index: 1)
        
    }
}
extension SubNotificationViewController: PageViewControllerDelegate {
    
    func tutorialPageViewController(_ tutorialPageViewController: PageNotificationViewController,
                                    didUpdatePageCount count: Int) {
    }
    
    func tutorialPageViewController(_ tutorialPageViewController: PageNotificationViewController,
                                    didUpdatePageIndex index: Int) {
        if index == 0
        {
            btnNew.isSelected = true
            btnTime.isSelected = false
            viewNew.backgroundColor = UIColor(hex: colorCam)
            viewTime.backgroundColor = UIColor.clear
            lblNew.textColor = UIColor(hex: "616161")
            lblTime.textColor = UIColor(hex: "b4b4b4")
        }
        else
        {
            btnTime.isSelected = true
            btnNew.isSelected = false
            viewTime.backgroundColor = UIColor(hex: colorCam)
            viewNew.backgroundColor = UIColor.clear
            lblTime.textColor = UIColor(hex: "616161")
            lblNew.textColor = UIColor(hex: "b4b4b4")
        }
    }
    
}

