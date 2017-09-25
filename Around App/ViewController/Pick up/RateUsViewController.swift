//
//  RateUsViewController.swift
//  Around App
//
//  Created by phuc.huynh on 8/16/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import UIKit
class CustomSlide: UISlider {
    
    @IBInspectable var trackHeight: CGFloat = 3
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = super.trackRect(forBounds: bounds)
        newBounds.size.height = trackHeight
        return newBounds
        
    }
}
class RateUsViewController: StatusbarViewController {
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var viewTop: UIImageView!
    @IBOutlet weak var slider: UISlider!
    var flagChooseReason = false
    var indexStar  = 5
    var indexReason = 5
    var order_id : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        let colors =  [UIColor(hex: "#fbfbfb").cgColor, UIColor(hex: "#ebebeb").cgColor]
        let image = setGradian(bounds: viewTop.bounds, colors: colors, startPoint: nil, endPoint: nil)
        self.viewTop.image = image
        DataConnect.getRatingReason(token_API, country_code: kCountryCode, phone: userPhone_API, view: self.view, onsuccess: { (result) in
            if let data = result as? RatingReason
            {
                if MCLocalization.sharedInstance().language == "vi"
                {
                    self.btn1.setTitle(data.reasons?[0].vn_name, for: .normal)
                    self.btn2.setTitle(data.reasons?[1].vn_name, for: .normal)
                    self.btn3.setTitle(data.reasons?[2].vn_name, for: .normal)
                    self.btn4.setTitle(data.reasons?[3].vn_name, for: .normal)
                    self.btn5.setTitle(data.reasons?[4].vn_name, for: .normal)
                }
                else
                {
                    self.btn1.setTitle(data.reasons?[0].name, for: .normal)
                    self.btn2.setTitle(data.reasons?[1].name, for: .normal)
                    self.btn3.setTitle(data.reasons?[2].name, for: .normal)
                    self.btn4.setTitle(data.reasons?[3].name, for: .normal)
                    self.btn5.setTitle(data.reasons?[4].name, for: .normal)
                }

                
            }
        }) { (error) in
            showErrorMessage(error: error as! Int, vc: self)
        }
        btnConfirm.isEnabled = true
        imageIcon.image = UIImage(named: String(format: "level%d", indexStar))
    }
    
    @IBAction func valueChange (_ sender: UISlider)
    {
        tracking(actionKey: "C10.1Y")
        sender.setValue(Float(lroundf(slider.value)), animated: true)
        indexStar = Int(slider.value)
        imageIcon.image = UIImage(named: String(format: "level%d", indexStar))
        if flagChooseReason == false
        {
        if indexStar == 4 || indexStar == 5
        {
            btnConfirm.isEnabled = true
        }
        else
        {
            btnConfirm.isEnabled = false
        }
        }
        else
        {
            btnConfirm.isEnabled = true
        }
        
    }
    
    
    @IBAction func btnSelected (_ sender: UIButton)
    {
        flagChooseReason = true
        if sender.tag == 0
        {
            tracking(actionKey: "C10.5Y")
        }
        else if sender.tag == 1
        {
            tracking(actionKey: "C10.2Y")
        }
        else if sender.tag == 2
        {
            tracking(actionKey: "C10.3Y")
        }
        else if sender.tag == 3
        {
            tracking(actionKey: "C10.6Y")
        }
        else if sender.tag == 4
        {
            tracking(actionKey: "C10.4Y")
        }
        setSelectedButton(arrayButton: [btn1,btn2,btn3,btn4,btn5], indexSelected: sender.tag)
        indexReason = sender.tag + 1
    }
    func unSelectedButton(arrayButton : [UIButton])
    {
        
        for item in arrayButton{
            arrayButton[item.tag].setBackgroundImage(UIImage(named: "textfieldChung"), for: .normal)
        }
        
    }
    func setSelectedButton(arrayButton : [UIButton], indexSelected : Int)
    {
        btnConfirm.isEnabled = true
        btnConfirm.alpha = 1
        for item in arrayButton{
            if item.tag == indexSelected
            {
                arrayButton[item.tag].setBackgroundImage(UIImage(named: "otp_textfield"), for: .normal)
            }
            else
            {
                arrayButton[item.tag].setBackgroundImage(UIImage(named: "textfieldChung"), for: .normal)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnConfirm (_ sender: UIButton)
    {
        tracking(actionKey: "C10.7Y")
        DataConnect.rating_(token_API, country_code: kCountryCode, phone: userPhone_API, id_reason: self.indexReason , star: self.indexStar, id_order: self.order_id!, onsuccess: { (result) in
            appDelegate.setRootView(isShowFollowJouneyStackScreen: false)
        }) { (error) in
            appDelegate.setRootView(isShowFollowJouneyStackScreen: false)
        }
        
    }
   
    
    
}
