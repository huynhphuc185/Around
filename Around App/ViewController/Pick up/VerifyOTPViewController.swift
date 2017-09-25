//
//  VerifyOTPViewController.swift
//  Around App
//
//  Created by phuc.huynh on 8/3/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import UIKit

class VerifyOTPViewController: StatusbarViewController {
    
    @IBOutlet weak var txtOTP: UITextField!
    @IBOutlet weak var lblNumberPhoe: UILabel!
    var numberPhone : String!
    var registerInfo : RegisterInfo?
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        if numberPhone == nil
        {
            if registerInfo?.phone?[0] == "0"
            {
                registerInfo?.phone? = String((registerInfo!.phone)!.characters.dropFirst())
            }
            self.lblNumberPhoe.text = "+" + kCountryCode + " " + (registerInfo?.phone)!
           
        }
        else
        {
            
            if numberPhone[0] == "0"
            {
                numberPhone =  String(numberPhone.characters.dropFirst())
            }
            self.lblNumberPhoe.text = "+" + kCountryCode + " " + numberPhone
        }
    }
    @IBAction func btnResend(_ sender: AnyObject) {
        tracking(actionKey: "C3.3Y")
//        if numberPhone == nil
//        {
//            self.lblNumberPhoe.text = "+" + kCountryCode + " " + (registerInfo?.phone)!
//            DataConnect.registerByPhoneNumber((registerInfo?.phone)!, country_code: kCountryCode, token: "", fullname: (registerInfo?.fullName)!,email: (registerInfo?.email!)!, avatar: (registerInfo?.avatar)!,view: self.view, onsuccess: { (result) in
//                                               
//            }) {
//                error in
//                showErrorMessage(error: error as! Int, vc: self)
//                
//            }
//        }
//        else
//        {
//            self.lblNumberPhoe.text = "+" + kCountryCode + " " + numberPhone
//            DataConnect.login(numberPhone, country_code: kCountryCode, view: self.view, onsuccess: { (result) in
//                
//            }) { (error) in
//                showErrorMessage(error: error as! Int, vc: self)
//            }
//        }
        self.dismiss(animated: false, completion: nil)

    }
    
    
    @IBAction func btnSubmit(_ sender: AnyObject) {
        tracking(actionKey: "C3.2Y")
        dismissKeyboard()
        if numberPhone == nil
        {
            DataConnect.verifyOTP((registerInfo?.phone)!,otpCode: txtOTP.text!, country_code: kCountryCode, view: self.view, onsuccess: { data in
                let result = data as! String
                if result == "success"
                {
                    appDelegate.setRootViewFirstTime()
                }
            }, onFailure:
                { error in
                    showErrorMessage(error: error as! Int, vc: self)
            })
        }
        else
        {
        DataConnect.verifyOTP(numberPhone,otpCode: txtOTP.text!, country_code: kCountryCode, view: self.view, onsuccess: { data in
            let result = data as! String
            if result == "success"
            {
                appDelegate.setRootViewFirstTime()
            }
        }, onFailure:
            { error in
                showErrorMessage(error: error as! Int, vc: self)
        })
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
//DataConnect.registerByPhoneNumber(txtNumberPhone.text!, country_code: kCountryCode, token: "", fullname: txtFirstName.text! + "/" + txtLastName.text!,email: txtEmail.text!, avatar: base64Image,view: self.view,
class RegisterInfo: NSObject
{
    var phone : String?
    var fullName : String?
    var email: String?
    var avatar : String?
}
