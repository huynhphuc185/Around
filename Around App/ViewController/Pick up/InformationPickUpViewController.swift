//
//  InformationPickUpViewController.swift
//  Around
//
//  Created by phuc.huynh on 1/13/17.
//  Copyright © 2017 phuc.huynh. All rights reserved.
//

import UIKit
import GooglePlaces
class InformationPickUpViewController: StatusbarViewController,UITextFieldDelegate {
    @IBOutlet weak var txtItemname: BottomLineTextfield!
    @IBOutlet weak var txtRecipentPhone: BottomLineTextfield!
    @IBOutlet weak var txtItemcost: BottomLineTextfield!
    @IBOutlet weak var txtRecipentname: BottomLineTextfield!
    @IBOutlet weak var txtNote: BottomLineTextfield!
    @IBOutlet weak var viewCausion: UIView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblSoTien: UILabel!
    @IBOutlet weak var constrainBottom: NSLayoutConstraint!
    @IBOutlet weak var lblNumberPickup: UILabel!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var btnVanchuyen: UIButton!
    @IBOutlet weak var btnMuaho: UIButton!
    @IBOutlet weak var btnThuho: UIButton!
    @IBOutlet weak var imageSaoItemCost: UIImageView!
    @IBOutlet weak var constrainHeightSotienThuHo: NSLayoutConstraint!
    @IBOutlet weak var constrainHeightTAB: NSLayoutConstraint!
    @IBOutlet weak var lblPhi: UILabel!
    var payOnBehaft = 0
    var blockCallBack : callBack?
    var point : PointLocation?
    var currentString = ""
    var placeClient = GMSPlacesClient()
    var indexPickUpTypeTemp:Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        indexPickUpTypeTemp = point?.pickup_type
        txtItemname.becomeFirstResponder()
        viewCausion.isHidden = true
        txtItemname.useUnderline()
        txtRecipentPhone.useUnderline()
        txtItemcost.useUnderline()
        txtNote.useUnderline()
        txtRecipentname.useUnderline()
        
        lblAddress.text = point?.address
        txtItemname.text = point?.item_name
        txtRecipentname.text = point?.recipent_name
        txtNote.text = point?.note
        if point?.item_cost == 0
        {
            txtItemcost.text = ""
        }
        else
        {
            self.currentString = String(format: "%d", (point?.item_cost)!)
            formatCurrency(currentString)
        }
        if point?.role == 0
        {
            lblNumberPickup.text = "1"
        }
        else if point?.role == 1
        {
            lblNumberPickup.text = "2"
        }
        else if point?.role == 2
        {
            lblNumberPickup.text = "3"
        }
        txtRecipentPhone.text = point?.phone
        
        if self.point?.pickup_type == 0 || self.point?.pickup_type == 1
        {
            self.btnTab(btnVanchuyen)
        }
        else if self.point?.pickup_type == 2
        {
            self.btnTab(btnMuaho)
        }
        else if self.point?.pickup_type == 3
        {
            self.btnTab(btnThuho)
        }
        
    }
    override func viewDidLayoutSubviews() {
        btnVanchuyen.roundCorners([.topLeft,.bottomLeft], radius: 3.0)
        btnThuho.roundCorners([.topRight,.bottomRight], radius: 3.0)
    }
    @IBAction func btnTab (_ sender: UIButton?)
    {
        viewCausion.isHidden = true
        txtItemcost.removeRightIcon()
        txtItemname.becomeFirstResponder()
        if sender == btnVanchuyen
        {
            indexPickUpTypeTemp = 1
            btnVanchuyen.setTitleColor(UIColor.white, for: .normal)
            btnMuaho.setTitleColor(UIColor(hex:colorXam), for: .normal)
            btnThuho.setTitleColor(UIColor(hex:colorXam), for: .normal)
            btnVanchuyen.backgroundColor = UIColor(hex: colorCam)
            btnThuho.backgroundColor = .clear
            btnMuaho.backgroundColor =  .clear
            self.constrainHeightSotienThuHo.constant = 0
            self.constrainHeightTAB.constant = 50
            self.lblPhi.isHidden = true
            self.imageSaoItemCost.isHidden = true
            
        }
        else if sender == btnMuaho
        {
            indexPickUpTypeTemp = 2
            btnMuaho.setTitleColor(UIColor.white, for: .normal)
            btnVanchuyen.setTitleColor(UIColor(hex:colorXam), for: .normal)
            btnThuho.setTitleColor(UIColor(hex:colorXam), for: .normal)
            btnMuaho.backgroundColor = UIColor(hex: colorCam)
            btnThuho.backgroundColor = .clear
            btnVanchuyen.backgroundColor =  .clear
            self.constrainHeightSotienThuHo.constant =  64
            self.constrainHeightTAB.constant = 50
            self.lblPhi.isHidden = true
            self.imageSaoItemCost.isHidden = false
        }
        else if sender == btnThuho
        {
            indexPickUpTypeTemp = 3
            btnThuho.setTitleColor(UIColor.white, for: .normal)
            btnMuaho.setTitleColor(UIColor(hex:colorXam), for: .normal)
            btnVanchuyen.setTitleColor(UIColor(hex:colorXam), for: .normal)
            btnThuho.backgroundColor = UIColor(hex: colorCam)
            btnMuaho.backgroundColor = .clear
            btnVanchuyen.backgroundColor =  .clear
            self.constrainHeightSotienThuHo.constant = 64
            self.constrainHeightTAB.constant = 80
            self.lblPhi.isHidden = false
            self.imageSaoItemCost.isHidden = false
        }
        self.view.layoutIfNeeded()
    }
    @IBAction func btnClose (_ sender: UIButton?)
    {
        self.blockCallBack!(nil)
    }
    
    @IBAction func btnConfirm (_ sender: UIButton?){
        if self.constrainHeightSotienThuHo.constant == 0
        {
            if  txtItemname.text?.length != 0{
                txtRecipentname.removeRightIcon()
                txtRecipentPhone.removeRightIcon()
                txtItemname.removeRightIcon()
                if (txtRecipentPhone.text?.length)! > 0
                {
                    if txtRecipentPhone.text!.removingWhitespaces().replacingOccurrences(of: "+", with: "").isNumber == false || (txtRecipentPhone.text?.removingWhitespaces().length)! < 10
                    {
                        txtItemcost.removeRightIcon()
                        txtItemname.removeRightIcon()
                        txtRecipentname.removeRightIcon()
                        txtRecipentPhone.insertImageRight(image: UIImage(named: "icon-loi")!, size : CGSize(width: 15, height: 15))
                        txtRecipentPhone.shake()
                        return
                    }
                }
                self.point?.pickup_type = 1
                self.point?.item_name = self.txtItemname.text!
                self.point?.recipent_name = self.txtRecipentname.text!
                self.point?.phone = (self.txtRecipentPhone.text?.removingWhitespaces())!
                self.point?.note = self.txtNote.text!
                self.point?.item_cost = 0
                self.blockCallBack!(nil)
                
            }
            else
            {
                if txtItemname.text?.length == 0
                {
                    txtItemname.insertImageRight(image: UIImage(named: "icon-loi")!, size : CGSize(width: 15, height: 15))
                    txtItemname.shake()
                }
                else
                {
                    txtItemname.removeRightIcon()
                }
                
            }
        }
        else
        {
            if  txtItemname.text?.length != 0 && txtItemcost.text?.length != 0 {
                txtRecipentname.removeRightIcon()
                txtRecipentPhone.removeRightIcon()
                txtItemname.removeRightIcon()
                txtItemcost.removeRightIcon()
                if (txtRecipentPhone.text?.length)! > 0
                {
                    if txtRecipentPhone.text!.removingWhitespaces().replacingOccurrences(of: "+", with: "").isNumber == false || (txtRecipentPhone.text?.removingWhitespaces().length)! < 10
                    {
                        txtItemcost.removeRightIcon()
                        txtItemname.removeRightIcon()
                        txtRecipentname.removeRightIcon()
                        txtRecipentPhone.insertImageRight(image: UIImage(named: "icon-loi")!, size : CGSize(width: 15, height: 15))
                        txtRecipentPhone.shake()
                        return
                    }
                }
                if self.txtItemcost.text?.length != 0
                {
                    let str = (self.txtItemcost.text?.replacingOccurrences(of: ",", with: ""))
                    let newStr = (str?.replacingOccurrences(of: ".", with: ""))
                    payOnBehaft = Int((newStr?.replacingOccurrences(of: " VND", with: ""))!)!
                    
                    
                    if indexPickUpTypeTemp == 2 //muaho
                    {
                        if payOnBehaft < Config.sharedInstance.min_item_cost_purchase!
                        {
                            txtItemcost.insertImageRight(image: UIImage(named: "icon-loi")!, size : CGSize(width: 15, height: 15))
                            self.viewCausion.isHidden = false
                            self.lblSoTien.text = MCLocalization.string(forKey: "SOTIENTOITHIEU") + String(format: "%@đ",setCommaforNumber(Int(Config.sharedInstance.min_item_cost_purchase!)))
                            self.viewCausion.shake()
                            txtItemcost.becomeFirstResponder()
                            self.mainScrollView.setContentOffset(CGPoint.zero, animated: true)
                            return
                        }
                        else
                        {
                            txtItemcost.removeRightIcon()
                            self.viewCausion.isHidden = true
                        }
                    }
                    else if indexPickUpTypeTemp == 3 // thuho
                    {
                        if payOnBehaft > Config.sharedInstance.max_item_cost_cod! || payOnBehaft < Config.sharedInstance.min_item_cost_cod!
                        {
                            txtItemcost.insertImageRight(image: UIImage(named: "icon-loi")!, size : CGSize(width: 15, height: 15))
                            self.viewCausion.isHidden = false
                            
                            
                            
                            self.lblSoTien.text =  MCLocalization.string(forKey: "SOTIENTOIDA", withPlaceholders: ["%min%" : String(format: "%@đ",setCommaforNumber(Int(Config.sharedInstance.min_item_cost_cod!))),"%max%" : String(format: "%@đ",setCommaforNumber(Int(Config.sharedInstance.max_item_cost_cod!)))])
                            
                            self.viewCausion.shake()
                            txtItemcost.becomeFirstResponder()
                            self.mainScrollView.setContentOffset(CGPoint.zero, animated: true)
                            return
                        }
                        else
                        {
                            txtItemcost.removeRightIcon()
                            self.viewCausion.isHidden = true
                        }
                        
                    }
                }
                
                self.point?.item_name = self.txtItemname.text!
                if  self.txtItemcost.text != ""
                {
                    self.point?.item_cost = self.payOnBehaft
                }
                self.point?.recipent_name = self.txtRecipentname.text!
                self.point?.phone = (self.txtRecipentPhone.text?.removingWhitespaces())!
                self.point?.note = self.txtNote.text!
                self.point?.pickup_type = indexPickUpTypeTemp!
                self.blockCallBack!(nil)
                
            }
            else
            {
                if txtItemname.text?.length == 0
                {
                    txtItemname.insertImageRight(image: UIImage(named: "icon-loi")!, size : CGSize(width: 15, height: 15))
                    txtItemname.shake()
                }
                else
                {
                    txtItemname.removeRightIcon()
                }
                
                if txtItemcost.text?.length == 0
                {
                    txtItemcost.insertImageRight(image: UIImage(named: "icon-loi")!, size : CGSize(width: 15, height: 15))
                    txtItemcost.shake()
                }
                else
                {
                    txtItemcost.removeRightIcon()
                }
            }
        }
        
        
        
    }
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField  == txtItemcost
        {
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
            return false
        }
        else
        {
            return true
        }
        
    }
    func formatCurrency(_ string: String) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let numberFromField = (NSString(string: string).doubleValue)
        let temp = formatter.string(from: NSNumber(value: numberFromField))
        self.txtItemcost.text = String(describing: temp! + " VND")
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if indexPickUpTypeTemp == 1
        {
            if textField == self.txtNote
            {
                self.dismissKeyboard()
            }
            else
            {
                if textField.nextField == txtItemcost
                {
                    txtRecipentname.becomeFirstResponder()
                }
                else
                {
                    textField.nextField?.becomeFirstResponder()
                }
                
            }
            return true
        }
        else
        {
            if textField == self.txtNote
            {
                self.dismissKeyboard()
            }
            else
            {
                textField.nextField?.becomeFirstResponder()
            }
            return true
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
}
