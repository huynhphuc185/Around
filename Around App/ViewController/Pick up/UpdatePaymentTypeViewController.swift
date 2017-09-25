//
//  InformationPickUpViewController.swift
//  Around
//
//  Created by phuc.huynh on 1/13/17.
//  Copyright © 2017 phuc.huynh. All rights reserved.
//

import UIKit
import GooglePlaces
class UpdatePaymentTypeViewController: StatusbarViewController {
    @IBOutlet weak var btnCash: UIButton!
    @IBOutlet weak var btnOnline: UIButton!
    @IBOutlet weak var imageCash: UIImageView!
    @IBOutlet weak var imageOnline: UIImageView!
    @IBOutlet weak var viewClose: UIView!
    var blockCallBack : callBack?
    var fullOrder : FullOrder?
    var id_order : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
      //  btnCash.isSelected = (sender?.returnToPickupSender)!
        // Do any additional setup after loading the view.
        
        if fullOrder?.payment_type == "ONLINE"
        {
            self.btnOnline.isSelected = true
            self.imageCash.image = UIImage(named: "ic_cast_unselected")
            self.imageOnline.image = UIImage(named: "ic_online_selected")
        }
        else
        {
            self.btnCash.isSelected = true
            self.imageCash.image = UIImage(named: "ic_cast_selected")
            self.imageOnline.image = UIImage(named: "ic_online_unselected")
        }

        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.close))
        self.viewClose.addGestureRecognizer(gesture)
        
    }
    func close()
    {
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func btnConfirm (_ sender: UIButton){

        if btnOnline.isSelected == true{
            DataConnect.updatePaymentType(token_API, country_code: kCountryCode, phone: userPhone_API, id_order: self.id_order!, payment_type: "ONLINE", view: self.view, onsuccess: { (result) in
            self.fullOrder?.payment_type = "ONLINE"
            self.blockCallBack!(nil)
            }, onFailure: { (error) in
                 showErrorMessage(error: error as! Int, vc: self)
            })
        }
        else
        {
            DataConnect.updatePaymentType(token_API, country_code: kCountryCode, phone: userPhone_API, id_order: self.id_order!, payment_type: "CASH", view: self.view, onsuccess: { (result) in
                self.fullOrder?.payment_type = "CASH"
                self.blockCallBack!(nil)
            }, onFailure: { (error) in
                 showErrorMessage(error: error as! Int, vc: self)
            })
        }

        
        
    
        
        
        
    }
    
    @IBAction func selectRadioButton(_ sender: UIButton) {
        
        if sender.tag == 1
        {
            btnCash.isSelected = true
            btnOnline.isSelected = false
            self.imageCash.image = UIImage(named: "ic_cast_selected")
            self.imageOnline.image = UIImage(named: "ic_online_unselected")
            
        }
        else if sender.tag == 2
        {
            btnOnline.isSelected = true
            btnCash.isSelected = false
            self.imageCash.image = UIImage(named: "ic_cast_unselected")
            self.imageOnline.image = UIImage(named: "ic_online_selected")
            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
