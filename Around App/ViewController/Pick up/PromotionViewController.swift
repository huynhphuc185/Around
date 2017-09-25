//
//  PromotionViewController.swift
//  Around
//
//  Created by phuc.huynh on 1/11/17.
//  Copyright © 2017 phuc.huynh. All rights reserved.
//

import UIKit

class PromotionViewController: StatusbarViewController, UITextFieldDelegate {
    @IBOutlet weak var txtPromotionCode: BottomLineTextfield!
    @IBOutlet weak var txtPromotionCode2: BottomLineTextfield!
    @IBOutlet weak var btnShareToFriend: UIButton!
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnTwiter: UIButton!
    @IBOutlet weak var btnIntergram: UIButton!
    @IBOutlet weak var sidebarButton: UIBarButtonItem!
    @IBOutlet weak var constrainViewBottom: NSLayoutConstraint!
    @IBOutlet weak var constrainLeft: NSLayoutConstraint!
    @IBOutlet weak var constrainBottom2: NSLayoutConstraint!
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    var activeField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sidebarButton.action = #selector(self.dismissVC)
        self.hideKeyboardWhenTappedAround()
        txtPromotionCode.useUnderline()
        txtPromotionCode2.useUnderline()
        if DeviceType.IS_IPHONE_5  {
            constrainViewBottom.constant = 130
            constrainLeft.constant = 58
            constrainBottom2.constant = 10
        }
        else if DeviceType.IS_IPHONE_6
        {
             constrainViewBottom.constant = 170
            constrainLeft.constant = 70
            constrainBottom2.constant = 18
        }
        else if DeviceType.IS_IPHONE_6P
        {
            constrainViewBottom.constant = 200
            constrainLeft.constant = 75
            constrainBottom2.constant = 25

        }
        else if DeviceType.IS_IPHONE_4_OR_LESS
        {
            constrainViewBottom.constant = 90
            constrainLeft.constant = 58
            constrainBottom2.constant = 10
        }
        
        txtPromotionCode2.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        DataConnect.getPromotion(token_API, country_code: kCountryCode, phone: userPhone_API, view: self.view, onsuccess: { (result) in
            self.txtPromotionCode2.text = result as? String
            self.txtPromotionCode2.insertImageRight(image: UIImage(named:"promotion_check")!, size: CGSize(width: 15, height: 15))
        }) { (error) in
             showErrorMessage(error: error as! Int, vc: self)
        }
       // self.view.layoutIfNeeded()
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    
     func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
     func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 10 // Bool
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField == txtPromotionCode
//        {
//            customAlertView(self, title: MCLocalization.string(forKey: "COMMINGSOONPROMOTION"), btnTitleNameNormal: name_confirm_Button_Normal,titleButton: MCLocalization.string(forKey: "CONFIRM"),blockCallback: {result in
//            })
//        }
    }
    func textFieldDidChange(_ textField: UITextField) {
        if textField.text?.length == 10
        {
            DataConnect.updatePromotion(token_API, country_code: kCountryCode, phone: userPhone_API, promo_code: textField.text!, view: self.view, onsuccess: { (result) in
                textField.endEditing(true)
                self.txtPromotionCode2.insertImageRight(image: UIImage(named:"promotion_check")!, size: CGSize(width: 15, height: 15))
                
                customAlertView(self, title: MCLocalization.string(forKey: "PROMOTIONSUCCESS", withPlaceholders: ["%name%" : String(format: "%d", result as! Int)]), btnTitleNameNormal: name_confirm_Button_Normal,titleButton: MCLocalization.string(forKey: "CONFIRM"),blockCallback: {result in
                })
            }, onFailure: { (error) in
                 textField.endEditing(true)
                 showErrorMessage(error: error as! Int, vc: self)
            })
        }
        else
        {
             self.txtPromotionCode2.removeRightIcon()
        }
    }
    func dismissVC()
    {
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func btnShare(_ sender: AnyObject) {
        customAlertView(self, title: MCLocalization.string(forKey: "COMMINGSOONPROMOTION"), btnTitleNameNormal: name_confirm_Button_Normal,titleButton: MCLocalization.string(forKey: "CONFIRM"),blockCallback: {result in
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
