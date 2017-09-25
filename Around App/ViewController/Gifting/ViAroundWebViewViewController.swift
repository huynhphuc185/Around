//
//  PaymentWebViewViewController.swift
//  Around
//
//  Created by phuc.huynh on 1/3/17.
//  Copyright © 2017 phuc.huynh. All rights reserved.
//

import UIKit
protocol protocolPaymentWebViewAroundPay {
    func callBack(isPayment: Bool)
}
class ViAroundWebViewViewController: StatusbarViewController,UIWebViewDelegate {
    var delegate: protocolPaymentWebViewAroundPay? = nil
    @IBOutlet weak var webView: UIWebView!
    var type: String?
    var value:Double?
    var aroundPay: PaymentURL?
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.scalesPageToFit = true
        
        DataConnect.getAroundPay_URL(token_API, country_code: kCountryCode, phone: userPhone_API, value: value!, type: type!, view: self.view, onsuccess: { (result) in
            
            self.aroundPay = result as? PaymentURL
            self.webView.loadRequest(URLRequest(url: URL(string: (self.aroundPay?.url)!)!))
            
        }) { (error) in
            showErrorMessage(error: error as! Int, vc: self)
        }
        
    }
    func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if let str = getQueryStringParameter(url: (webView.request!.url!.absoluteString), param: "around_status")
        {
            if str == "done"
            {
                DataConnect.checkAroundPay(token_API, country_code: kCountryCode, phone: userPhone_API, trans_ref: (aroundPay?.trans_ref)!, view: self.view, onsuccess: { (result) in
                    customAlertView(self, title: MCLocalization.string(forKey: "PAYMENTSUCCESS"), btnTitleNameNormal: name_confirm_Button_Normal,titleButton: MCLocalization.string(forKey: "CONFIRM")) { result in
                        self.dismiss(animated: true, completion: {
                            self.delegate?.callBack(isPayment: true)
                        })
                    }
                }, onFailure: { (error) in
                    customAlertView(self, title: MCLocalization.string(forKey: "PAYMENTFAIL"), btnTitleNameNormal: name_confirm_Button_Normal,titleButton: MCLocalization.string(forKey: "CONFIRM")) { result in
                        self.dismiss(animated: true, completion: {
                            self.delegate?.callBack(isPayment: false)
                        })
                    }
                    
                })
                
            }
            
        }
        
    }
    @IBAction func btnClose (_ sender: UIButton)
    {
        
        customAlertViewWithCancelButton(self, title: MCLocalization.string(forKey: "THOATTHANHTOAN"), btnTitleNameNormal: name_confirm_Button_Normal,  btnCancelNameNormal: name_cancel_Button_Normal,titleOrangeButton: MCLocalization.string(forKey: "CONFIRM"), titleGreyButton: MCLocalization.string(forKey: "CANCEL"), isClose: false, blockCallback: {result in
            self.dismiss(animated: true, completion: nil)
        }, blockCallbackCancel: {result in
            
        })
        
        
    }
    @IBAction func btnBack (_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: false)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
