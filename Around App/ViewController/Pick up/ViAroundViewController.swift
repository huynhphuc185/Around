//
//  PaymentInfoViewController.swift
//  Around App
//
//  Created by phuc.huynh on 8/12/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import UIKit
class ViAroundViewController: StatusbarViewController,protocolPaymentWebViewAroundPay,UITextFieldDelegate {
    @IBOutlet weak var sidebarButton: UIBarButtonItem!
    @IBOutlet weak var btnChoose1: UIButton!
    @IBOutlet weak var btnChoose2: UIButton!
    @IBOutlet weak var btnChoose3: UIButton!
    @IBOutlet weak var txtValue: UITextField!
    @IBOutlet weak var lblCausion: UILabel!
    @IBOutlet weak var lblMoney: UILabel!
    @IBOutlet weak var lblBanKhongCotien: UILabel!
    @IBOutlet var contrainsHeightTopKhongCotien: NSLayoutConstraint?
    @IBOutlet weak var viewCoTien: UIView!
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    var money: Double?
    var indexChoose = 0
    var currentString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sidebarButton.action = #selector(self.dismissVC)
        self.hideKeyboardWhenTappedAround()
        btnChoose1.setTitle(String(format: "%@",setCommaforNumber((Config.sharedInstance.aroundpay?.prices?[0])!)), for: .normal)
        btnChoose2.setTitle(String(format: "%@",setCommaforNumber((Config.sharedInstance.aroundpay?.prices?[1])!)), for: .normal)
        btnChoose3.setTitle(String(format: "%@",setCommaforNumber((Config.sharedInstance.aroundpay?.prices?[2])!)), for: .normal)
        self.btnTab(btnChoose1)
        self.lblMoney.text =  String(format: "%@",setCommaforNumber(Int(money!)))
        if Int(money!) > 0
        {
            viewCoTien.isHidden = true
            lblBanKhongCotien.text = ""
            contrainsHeightTopKhongCotien?.constant = 0
            self.view.layoutIfNeeded()
        }
        
    }
    override func viewDidLayoutSubviews() {
        btnChoose1.roundCorners([.topLeft,.bottomLeft], radius: 3.0)
        btnChoose3.roundCorners([.topRight,.bottomRight], radius: 3.0)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch string {
        case "0","1","2","3","4","5","6","7","8","9":
            if currentString.length >= 9
            {
                return false
            }
            currentString += string
            formatCurrency(currentString)
        default:
            if string.characters.count == 0 && currentString.characters.count != 0 {
                currentString = String(currentString.characters.dropLast())
                formatCurrency(currentString)
            }
        }
        if  currentString == ""{
            if indexChoose == 0
            {
                self.btnTab(btnChoose1)
            }
            else if indexChoose == 1
            {
                self.btnTab(btnChoose2)
            }
            else if indexChoose == 2
            {
                self.btnTab(btnChoose3)
            }
            
        }
        else {
            self.resetBtnTab()
        }
        
        return false
        
        
        
    }
    func formatCurrency(_ string: String) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let numberFromField = (NSString(string: string).doubleValue)
        let temp = formatter.string(from: NSNumber(value: numberFromField))
        self.txtValue.text = String(describing: temp!)
    }
    func resetBtnTab()
    {
        btnChoose1.setTitleColor(UIColor(hex:colorXam), for: .normal)
        btnChoose2.setTitleColor(UIColor(hex:colorXam), for: .normal)
        btnChoose3.setTitleColor(UIColor(hex:colorXam), for: .normal)
        btnChoose1.backgroundColor = .clear
        btnChoose2.backgroundColor = .clear
        btnChoose3.backgroundColor =  .clear
    }
    @IBAction func btnTab (_ sender: UIButton?)
    {
        lblCausion.isHidden = true
        txtValue.text = ""
        currentString = ""
        if sender == btnChoose1
        {
            indexChoose = 0
            btnChoose1.setTitleColor(UIColor.white, for: .normal)
            btnChoose2.setTitleColor(UIColor(hex:colorXam), for: .normal)
            btnChoose3.setTitleColor(UIColor(hex:colorXam), for: .normal)
            btnChoose1.backgroundColor = UIColor(hex: colorCam)
            btnChoose2.backgroundColor = .clear
            btnChoose3.backgroundColor =  .clear
            
            
        }
        else if sender == btnChoose2
        {
            indexChoose = 1
            btnChoose2.setTitleColor(UIColor.white, for: .normal)
            btnChoose1.setTitleColor(UIColor(hex:colorXam), for: .normal)
            btnChoose3.setTitleColor(UIColor(hex:colorXam), for: .normal)
            btnChoose2.backgroundColor = UIColor(hex: colorCam)
            btnChoose1.backgroundColor = .clear
            btnChoose3.backgroundColor =  .clear
            
        }
        else if sender == btnChoose3
        {
            indexChoose = 2
            btnChoose3.setTitleColor(UIColor.white, for: .normal)
            btnChoose1.setTitleColor(UIColor(hex:colorXam), for: .normal)
            btnChoose2.setTitleColor(UIColor(hex:colorXam), for: .normal)
            btnChoose3.backgroundColor = UIColor(hex: colorCam)
            btnChoose1.backgroundColor = .clear
            btnChoose2.backgroundColor =  .clear
            
        }
        self.view.layoutIfNeeded()
    }
    
    func dismissVC()
    {
        tracking(actionKey: "C18.6N")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSubmit (_ sender: UIButton)
    {
        self.view.endEditing(true)
        let vc = giftingStoryBoard.instantiateViewController(withIdentifier: "ViAroundBankViewController") as! ViAroundBankViewController
        vc.delegate = self
        var value: Double?
        if txtValue.text == ""
        {
            value =  Double((Config.sharedInstance.aroundpay?.prices?[indexChoose])!)
        }
        else
        {
            let str = (self.txtValue.text?.replacingOccurrences(of: ",", with: ""))
            value = Double((str?.replacingOccurrences(of: ".", with: ""))!)
        }
        
        if value! < Double((Config.sharedInstance.aroundpay?.min_around_pay_payment)!) || value! > Double((Config.sharedInstance.aroundpay?.max_around_pay_payment)!)
        {
            lblCausion.isHidden = false
            return
        }
        else
        {
            lblCausion.isHidden = true
            
        }
        vc.value = value!
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overCurrentContext
        nav.modalTransitionStyle = .crossDissolve
        nav.isNavigationBarHidden = true
        self.present(nav, animated: true, completion: nil)
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func callBack(isPayment: Bool) {
        if isPayment
        {
            DataConnect.getAroundPay_(token_API, country_code: kCountryCode, phone: userPhone_API,view: self.view,  onsuccess: { (result) in
                self.money = result as? Double
                self.lblMoney.text =  String(format: "%@",setCommaforNumber(Int(self.money!)))
                if Int(self.money!) > 0
                {
                    self.viewCoTien.isHidden = true
                    self.lblBanKhongCotien.text = ""
                    self.contrainsHeightTopKhongCotien?.constant = 0
                    self.view.layoutIfNeeded()
                }
            }) { (error) in
                showErrorMessage(error: error as! Int, vc: self)
            }
        }
    }
    
}



