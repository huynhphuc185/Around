//
//  PaymentWebViewViewController.swift
//  Around
//
//  Created by phuc.huynh on 1/3/17.
//  Copyright © 2017 phuc.huynh. All rights reserved.
//

import UIKit
protocol protocolPaymentWebView {
    func callBack(isPayment: Bool, order_ID: Int)
}
class PaymentWebViewViewController: StatusbarViewController,UIWebViewDelegate {
    var delegate: protocolPaymentWebView? = nil
    @IBOutlet weak var webView: UIWebView!
    var order_id : Int?
    var type: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.scalesPageToFit = true
        DataConnect.get1PayURL(token_API, country_code: kCountryCode, phone: userPhone_API, order_id: order_id!,type:type!, view: self.view, onsuccess: { (result) in
            if let url = result as? String
            {
                self.webView.loadRequest(URLRequest(url: URL(string: url)!))
            }
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
                
                DataConnect.check1Pay_(token_API, country_code: kCountryCode, phone: userPhone_API, order_id: self.order_id!, view: self.view, onsuccess: { (result) in
                    customAlertView(self, title: MCLocalization.string(forKey: "PAYMENTSUCCESS"), btnTitleNameNormal: name_confirm_Button_Normal,titleButton: MCLocalization.string(forKey: "CONFIRM")) { result in
                        self.dismiss(animated: true, completion: {
                            // self.delegate?.callBack(isPayment: true)
                            self.delegate?.callBack(isPayment: true, order_ID: self.order_id!)
                        })
                        
                        
                    }
                }, onFailure: { (error) in
                    customAlertView(self, title: MCLocalization.string(forKey: "PAYMENTFAIL"), btnTitleNameNormal: name_confirm_Button_Normal,titleButton: MCLocalization.string(forKey: "CONFIRM")) { result in
                        self.dismiss(animated: true, completion: {
                            self.delegate?.callBack(isPayment: false, order_ID: self.order_id!)
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
//        DataConnect.check1Pay_(token_API, country_code: kCountryCode, phone: userPhone_API, order_id: self.order_id!, view: self.view, onsuccess: { (result) in
//            customAlertView(self, title: MCLocalization.string(forKey: "PAYMENTSUCCESS"), btnTitleNameNormal: name_confirm_Button_Normal,titleButton: MCLocalization.string(forKey: "CONFIRM")) { result in
//                self.dismiss(animated: true, completion: {
//                    // self.delegate?.callBack(isPayment: true)
//                    self.delegate?.callBack(isPayment: true, order_ID: self.order_id!)
//                })
//                
//                
//            }
//        }, onFailure: { (error) in
//            customAlertView(self, title: MCLocalization.string(forKey: "PAYMENTFAIL"), btnTitleNameNormal: name_confirm_Button_Normal,titleButton: MCLocalization.string(forKey: "CONFIRM")) { result in
//                self.dismiss(animated: true, completion: {
//                    self.delegate?.callBack(isPayment: false, order_ID: self.order_id!)
//                })
//            }
//        })
        
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
