//
//  RegisterViewController.swift
//  Shipper
//
//  Created by phuc.huynh on 9/14/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import UIKit

class SignUpToShipViewController: StatusbarViewController,UIGestureRecognizerDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var txtFullname: BottomLineTextfield!
    @IBOutlet weak var txtPhonenumber: BottomLineTextfield!
    @IBOutlet weak var txtIDNumber: BottomLineTextfield!
    @IBOutlet weak var txtAddress: BottomLineTextfield!
    @IBOutlet weak var sidebarButton: UIBarButtonItem!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var constrainsTop: NSLayoutConstraint!
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    var picker = UIImagePickerController()
    var base64Image = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sidebarButton.action = #selector(self.dismissVC)
        self.hideKeyboardWhenTappedAround()
        txtFullname.useUnderline()
        txtPhonenumber.useUnderline()
        txtIDNumber.useUnderline()
        txtAddress.useUnderline()
        self.containerView.setShadowBorder()
    }
    
    
    func dismissVC()
    {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func editAvatar (_ sender: UIButton)
    {
        let alert:UIAlertController=UIAlertController(title: MCLocalization.string(forKey: "CHOOSEIMAGE"), message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: MCLocalization.string(forKey: "CAMERA"), style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: MCLocalization.string(forKey: "GALLARY"), style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: MCLocalization.string(forKey: "CANCEL"), style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
        }
        // Add the actions
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    } 
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            picker.sourceType = UIImagePickerControllerSourceType.camera
            self .present(picker, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: MCLocalization.string(forKey: "CHOOSEIMAGE"), message: nil, preferredStyle: UIAlertControllerStyle.alert)
            alert.title =  MCLocalization.string(forKey: "WARNING")
            alert.message =  MCLocalization.string(forKey: "YOUDONTHAVECAMERA")
            let OkAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel)
            {
                UIAlertAction in
            }
            
            alert.addAction(OkAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    func openGallary(){
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    //MARK:UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        picker .dismiss(animated: true, completion: nil)
        imageAvatar.image = (info[UIImagePickerControllerOriginalImage] as? UIImage)
        self.imageAvatar.setRound()
        base64Image = convertImageToBase64(image: imageAvatar.image!)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        print("picker cancel.")
        picker .dismiss(animated: true, completion: nil)
    }

    @IBAction func btnConfirm (_ sender: UIButton?)
    {
        self.dismissKeyboard()
        let dict = NSMutableDictionary()
        dict.setValue(txtFullname.text, forKey: "fullname")
        dict.setValue(txtPhonenumber.text, forKey: "phone_no")
        dict.setValue(txtAddress.text, forKey: "address")
        dict.setValue(txtIDNumber.text, forKey: "id_no")
        dict.setValue(base64Image, forKey: "avatar")
        DataConnect.signUpToShip(kCountryCode, dict: dict, view: self.view, onsuccess: { (result) in
            customAlertView(self, title: MCLocalization.string(forKey: "REGISTERSUCCESS"), btnTitleNameNormal: name_confirm_Button_Normal,titleButton: "OK",blockCallback: {
                result in
                 self.dismissVC()
            })
           
        }) { (error) in
            showErrorMessage(error: error as! Int, vc: self)
        }
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtAddress
        {
            self.btnConfirm(nil)
        }
        else
        {
            textField.nextField?.becomeFirstResponder()
        }
        return true
    }
   
    
}

