//
//  RegisterPhoneNumberViewController.swift
//  Around
//
//  Created by phuc.huynh on 8/2/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//
import Alamofire
import UIKit

class RegisterPhoneNumberViewController: StatusbarViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var sidebarButton: UIBarButtonItem!
    @IBOutlet weak var txtFirstName: PaddingTextField!
    @IBOutlet weak var txtLastName: PaddingTextField!
    @IBOutlet weak var txtNumberPhone: PaddingTextField!
    @IBOutlet weak var txtEmail: PaddingTextField!
    @IBOutlet weak var txt84: PaddingTextField!
    @IBOutlet weak var txtLanguage: PaddingTextField!
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var lblFirstName: CustomLabel!
    @IBOutlet weak var lblLastName: CustomLabel!
    @IBOutlet weak var lblCountryCode: CustomLabel!
    @IBOutlet weak var lblCellPhone: CustomLabel!
    @IBOutlet weak var lblLanguage: CustomLabel!
    @IBOutlet weak var lblEmail: CustomLabel!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var embleView: UIView!
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    var flagLogin = false
    var picker = UIImagePickerController()
    var base64Image = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        containerView.setShadowBorder()
        setLocalize()
        
        if flagLogin
        {
            sidebarButton.image = UIImage(named: "back x2")
            sidebarButton.action = #selector(self.back)
        }
        else
        {
            sidebarButton.image = UIImage(named: "close x2")
            sidebarButton.action = #selector(self.close)
        }
       
        txt84.text = "+" + kCountryCode
    }
    func setLocalize()
    {
        navItem.title = MCLocalization.string(forKey: "REGISTER")
        lblFirstName.text = MCLocalization.string(forKey: "FIRST_NAME")
        lblLastName.text = MCLocalization.string(forKey: "LAST_NAME")
        lblCountryCode.text = MCLocalization.string(forKey: "COUNTRY_CODE")
        lblCellPhone.text = MCLocalization.string(forKey: "CELL_PHONE")
        lblLanguage.text = MCLocalization.string(forKey: "LANGUAGE")
        lblEmail.text = MCLocalization.string(forKey: "EMAIL")
        btnConfirm.setTitle(MCLocalization.string(forKey: "CONFIRM"), for: .normal)
        
        if MCLocalization.sharedInstance().language == "en"
        {
            self.txtLanguage.text =  MCLocalization.string(forKey: "ENGLISH")
        }
        else if MCLocalization.sharedInstance().language == "vi"
        {
            self.txtLanguage.text =  MCLocalization.string(forKey: "VIETNAMESE")
        }
        
    }
    func close()
    {
        self.dismiss(animated: true, completion: nil)
        tracking(actionKey: "C2.1N")
    }
    func back()
    {
        self.navigationController?.popViewController(animated: true)
        tracking(actionKey: "C2.1N")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    @IBAction func btnEditClick(_ sender: AnyObject)
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
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func btnChangeEnglish(_ sender: AnyObject){
        self.showPopUpLanguage { (result) in
            self.setLocalize()
            if result as! String == "en"
            {
                self.txtLanguage.text =  MCLocalization.string(forKey: "ENGLISH")
            }
            else if result as! String == "vi"
            {
                self.txtLanguage.text =  MCLocalization.string(forKey: "VIETNAMESE")
            }
            
            
        }
    }
    
    func showPopUpLanguage(blockCallback: @escaping callBack)
    {
        let myAlert = pickUpStoryBoard.instantiateViewController(withIdentifier: "LanguageViewController") as! LanguageViewController
        myAlert.blockCallBack = blockCallback
        myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(myAlert, animated: false, completion: nil)
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
        imageAvatar.setRound()
        base64Image = convertImageToBase64(image: imageAvatar.image!)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        print("picker cancel.")
        picker .dismiss(animated: true, completion: nil)
    }
    @IBAction func btnSubmit(_ sender: AnyObject) {
        tracking(actionKey: "C2.2Y")
        dismissKeyboard()
        DataConnect.registerByPhoneNumber(txtNumberPhone.text!, country_code: kCountryCode, token: "", fullname: txtFirstName.text! + "/" + txtLastName.text!,email: txtEmail.text!, avatar: base64Image,view: self.view,
                                          onsuccess: { (result) in
                                            let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "VerifyOTPViewController") as! VerifyOTPViewController
                                            // vc.numberPhone = self.txtNumberPhone.text
                                            let regInfo = RegisterInfo()
                                            regInfo.phone = self.txtNumberPhone.text
                                            regInfo.fullName =  self.txtFirstName.text! + "/" + self.txtLastName.text!
                                            regInfo.email = self.txtEmail.text!
                                            regInfo.avatar = self.base64Image
                                            vc.registerInfo = regInfo
                                            vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                                            vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                                            self.present(vc, animated: true, completion: nil)
                                            defaults.set(self.txtNumberPhone.text, forKey: "userphone")
                                            userPhone_API = defaults.value(forKey: "userphone") as! String
        }) {
            error in
            showErrorMessage(error: error as! Int, vc: self)
            
        }
        
    }
    
}
