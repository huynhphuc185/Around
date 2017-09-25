//
//  BankViewController.swift
//  Around
//
//  Created by phuc.huynh on 1/4/17.
//  Copyright © 2017 phuc.huynh. All rights reserved.
//

import UIKit

class ViAroundBankViewController: StatusbarViewController {
    @IBOutlet weak var viewChooseService: UIView!
    @IBOutlet weak var btnVisa: UIButton!
    @IBOutlet weak var btnATM: UIButton!

    var delegate : protocolPaymentWebViewAroundPay?
    var listMethod : [String]?
    var value : Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listMethod = Config.sharedInstance.listPayment!
        if (self.listMethod?.count)! >= 2
        {
            btnVisa.setTitle(self.listMethod?[1], for: .normal)
            btnATM.setTitle(self.listMethod?[0], for: .normal)
        }
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.close))
        self.viewChooseService.addGestureRecognizer(gesture)
    }
    
    
    func close()
    {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnClick (_ sender: UIButton)
    {
        
        if sender == btnVisa
        {
            tracking(actionKey: "C18.3Y")
            let vc = giftingStoryBoard.instantiateViewController(withIdentifier: "ViAroundWebViewViewController") as! ViAroundWebViewViewController
            vc.type = sender.titleLabel?.text
            vc.value = value
            vc.delegate = delegate
            self.navigationController?.pushViewController(vc, animated: false)
        }
        if sender == btnATM
        {
            tracking(actionKey: "C18.4Y")
            let vc = giftingStoryBoard.instantiateViewController(withIdentifier: "ViAroundWebViewViewController") as! ViAroundWebViewViewController
            vc.type = sender.titleLabel?.text
            vc.value = value
            vc.delegate = delegate
            self.navigationController?.pushViewController(vc, animated: false)
            
        }
    }
}

