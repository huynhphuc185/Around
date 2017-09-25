//
//  DropInformationViewController.swift
//  Around
//
//  Created by phuc.huynh on 8/23/17.
//  Copyright © 2017 phuc.huynh. All rights reserved.
//

import UIKit

class DropInformationViewController: StatusbarViewController,UITextFieldDelegate {
    var blockCallBack : callBack?
    var point : PointLocation?
   
    @IBOutlet weak var txtRecipentPhone: BottomLineTextfield!
    
    @IBOutlet weak var txtRecipentname: BottomLineTextfield!
    @IBOutlet weak var txtNote: BottomLineTextfield!
  
    @IBOutlet weak var lblAddress: UILabel!
   
    @IBOutlet weak var constrainBottom: NSLayoutConstraint!
 
    @IBOutlet weak var mainScrollView: UIScrollView!
    var currentString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        txtRecipentPhone.useUnderline()
        txtRecipentname.useUnderline()
        txtNote.useUnderline()
        txtRecipentname.becomeFirstResponder()
        self.hideKeyboardWhenTappedAround()
        
        
        
        lblAddress.text = point?.address
        txtRecipentname.text = point?.recipent_name
        txtNote.text = point?.note
        txtRecipentPhone.text = point?.phone
        
               // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnClose (_ sender: UIButton?)
    {
        self.blockCallBack!(nil)
    }
    @IBAction func btnConfirm (_ sender: UIButton?){
 
            if  txtRecipentname.text?.length != 0 && txtRecipentPhone.text?.length != 0{

                if txtRecipentPhone.text!.removingWhitespaces().replacingOccurrences(of: "+", with: "").isNumber == false || (txtRecipentPhone.text?.removingWhitespaces().length)! < 10
                {
                    txtRecipentPhone.insertImageRight(image: UIImage(named: "icon-loi")!, size : CGSize(width: 15, height: 15))
                    txtRecipentPhone.shake()
                    return
                }
                txtRecipentname.removeRightIcon()
                txtRecipentPhone.removeRightIcon()
                self.point?.pickup_type = 1
                self.point?.recipent_name = self.txtRecipentname.text!
                self.point?.phone = (self.txtRecipentPhone.text?.removingWhitespaces())!
                self.point?.note = self.txtNote.text!
                self.point?.item_cost = 0
                self.blockCallBack!(nil)
                
            }
            else
            {

                if txtRecipentname.text?.length == 0
                {
                    txtRecipentname.insertImageRight(image: UIImage(named: "icon-loi")!, size : CGSize(width: 15, height: 15))
                    txtRecipentname.shake()
                }
                else
                {
                    txtRecipentname.removeRightIcon()
                }
                if txtRecipentPhone.text?.length == 0
                {
                    txtRecipentPhone.insertImageRight(image: UIImage(named: "icon-loi")!, size : CGSize(width: 15, height: 15))
                    txtRecipentPhone.shake()
                }
                else
                {
                    txtRecipentPhone.removeRightIcon()
                }
                
            }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.txtNote
        {
            dismissKeyboard()
        }
        else
        {
            textField.nextField?.becomeFirstResponder()
        
        }
        return true
        
    }

}
