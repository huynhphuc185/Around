//
//  LoginByPhoneViewController.swift
//  Around
//
//  Created by phuc.huynh on 3/9/17.
//  Copyright © 2017 phuc.huynh. All rights reserved.
//

import UIKit

class LoginByPhoneViewController: StatusbarViewController {
    @IBOutlet weak var sidebarButton: UIBarButtonItem!
    @IBOutlet weak var txtNumberPhone: BottomLineTextfield!
    @IBOutlet weak var txt84: BottomLineTextfield!
    @IBOutlet weak var navItem: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
        sidebarButton.action = #selector(self.back)
        txtNumberPhone.useUnderlineWithColor(color: UIColor(hex: colorXamNhat))
        txtNumberPhone.becomeFirstResponder()
        txt84.useUnderlineWithColor(color: UIColor(hex: colorXamNhat))
    }
    
    func back()
    {
        self.dismiss(animated: true, completion: nil)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnSubmit(_ sender: AnyObject) {
        dismissKeyboard()
        let strNumber = txtNumberPhone.text?.replacingOccurrences(of: "+84 ", with: "")
        DataConnect.login(strNumber!, country_code: kCountryCode, view: self.view, onsuccess: { (result) in
            let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "VerifyOTPViewController") as! VerifyOTPViewController
            vc.numberPhone = strNumber
            vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            self.present(vc, animated: true, completion: nil)
            defaults.set(strNumber, forKey: "userphone")
            userPhone_API = defaults.value(forKey: "userphone") as! String
        }) { (error) in
            showErrorMessage(error: error as! Int, vc: self)
        }
    }
    
    
    @IBAction func btnRegister(_ sender: AnyObject) {
        let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "RegisterPhoneNumberViewController") as! RegisterPhoneNumberViewController
        vc.flagLogin = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnHelp(_ sender: UIButton) {

        if Config.sharedInstance.phoneNumberCallCenter != nil
        {
            
            sender.isEnabled = false
            delayWithSeconds(0.5) {
                sender.isEnabled = true
            }
            callNumber(Config.sharedInstance.phoneNumberCallCenter!) { (result) in
                
            }
        }
       
    }
}
