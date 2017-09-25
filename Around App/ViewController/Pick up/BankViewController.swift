//
//  BankViewController.swift
//  Around
//
//  Created by phuc.huynh on 1/4/17.
//  Copyright © 2017 phuc.huynh. All rights reserved.
//

import UIKit

class BankViewController: StatusbarViewController {
    @IBOutlet weak var viewChooseService: UIView!
    @IBOutlet weak var btnVisa: UIButton!
    @IBOutlet weak var btnATM: UIButton!
    var delegate : protocolPaymentWebView?
    var listMethod : [String]?
    var order_id : Int?
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
            let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "PaymentWebViewViewController") as! PaymentWebViewViewController
            vc.order_id = order_id
            vc.type = sender.titleLabel?.text
            vc.delegate = delegate
            self.navigationController?.pushViewController(vc, animated: false)
        }
        if sender == btnATM
        {
            tracking(actionKey: "C18.4Y")
            let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "PaymentWebViewViewController") as! PaymentWebViewViewController
            vc.order_id = order_id
            vc.type = sender.titleLabel?.text
            vc.delegate = delegate
            self.navigationController?.pushViewController(vc, animated: false)
            
        }
    }
}
class BankCell : UICollectionViewCell
{
    @IBOutlet weak var imageView: UIImageView!
}
