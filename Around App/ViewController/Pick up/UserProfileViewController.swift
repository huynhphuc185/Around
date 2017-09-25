//
//  UserProfileViewController.swift
//  Around App
//
//  Created by phuc.huynh on 8/16/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import UIKit
import GooglePlaces
class UserProfileViewController: StatusbarViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var placeClient = GMSPlacesClient()
    var resultsArray = [Address]()
    @IBOutlet weak var sidebarButton: UIBarButtonItem!
    @IBOutlet weak var lblName: CustomLabel!
    @IBOutlet weak var lblPhone: CustomLabel!
    @IBOutlet weak var lblEmail: CustomLabel!
    @IBOutlet weak var lblHome: CustomLabel!
    @IBOutlet weak var lblWork: CustomLabel!
    @IBOutlet weak var lblPlace: CustomLabel!
    @IBOutlet weak var txtLocation: BottomLineTextfield!
    @IBOutlet weak var imageViewAvatar: UIImageView!
    @IBOutlet weak var imageHome: UIImageView!
    @IBOutlet weak var imageWork1: UIImageView!
    @IBOutlet weak var imagePlace: UIImageView!
    @IBOutlet weak var btnEditProfile: UIButton!
    @IBOutlet weak var btnEditName: UIButton!
    @IBOutlet weak var btnEditEmail: UIButton!
    @IBOutlet weak var btnHomeLocation: UIButton!
    @IBOutlet weak var btnWork1Location: UIButton!
    @IBOutlet weak var btnWork2Location: UIButton!
    @IBOutlet weak var tblViewLocation: UITableView!
    @IBOutlet weak var viewClose: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblLanguage: UILabel!
    @IBOutlet weak var lblBirthday: UILabel!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    var picker = UIImagePickerController()
    var listPoint:[Address] = []
    var indexChooseTableViewCell = 0
    var flagKeyboard = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sidebarButton.action = #selector(self.dismissVC)
        DataConnect.getUserInfo(token_API,country_code: kCountryCode,phone: userPhone_API, isNeedShowProcess: true, onsuccess: { (result) in
            if let obj = result as? Profile
            {
                appDelegate.nameUser = obj.fullname
                self.lblName.text = obj.fullname
                self.lblPhone.text = obj.phone
                if obj.email == ""
                {
                    self.lblEmail.text = MCLocalization.string(forKey: "YOUREMAIL")
                }
                else
                {
                    self.lblEmail.text = obj.email
                }
                if obj.birthday == ""
                {
                    self.lblBirthday.text = MCLocalization.string(forKey: "YOURBIRTHDAY")
                }
                else{
                    self.lblBirthday.text = obj.birthday
                }
                self.imageViewAvatar.sd_setImageWithURLWithFade(URL(string: obj.avatar!), placeholderImage: UIImage(named:"default_Profile"))
                self.imageViewAvatar.setRound()
                
            }
        }) { error in
            showErrorMessage(error: error as! Int, vc: self)
        }
        txtLocation.insertImageLeft(image: UIImage(named: "ic_home-a")!, size: CGSize(width: 15, height: 15))
        txtLocation.useUnderline()
        tblViewLocation.isHidden = true
        btnHomeLocation.isSelected = true
        setStatusButton()
        self.containerView.setShadowBorder()
        let listLocation = defaults.value(forKey: "locations") as! [String]
        for item in listLocation
        {
            let dict = try!JSONSerialization.jsonObject(with: item.data(using: .utf8)!, options: .allowFragments) as! NSDictionary
            listPoint.append(Address().parseDataFromDictionary(dict) )
            
        }
        txtLocation.text =  listPoint[indexChooseTableViewCell].fullAddress
        
        txtLocation.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
        viewClose.isHidden = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.closeInputData))
        self.viewClose.addGestureRecognizer(gesture)
        self.setLocalize()
    }
    func setStatusButton()
    {
        if btnHomeLocation.isSelected
        {
            imageHome.image = UIImage(named: "ic_home-a")
            imageWork1.image = UIImage(named: "ic_work-a-1")
            imagePlace.image = UIImage(named: "ic_place-a")
            lblHome.textColor = UIColor(hex: colorCam)
            lblWork.textColor = UIColor(hex: colorXamNhat)
            lblPlace.textColor = UIColor(hex: colorXamNhat)
            lblHome.font = UIFont(name: "OpenSans-Semibold", size: 13)
            lblWork.font = UIFont(name: "OpenSans", size: 13)
            lblPlace.font = UIFont(name: "OpenSans", size: 13)
            txtLocation.insertImageLeft(image: UIImage(named: "ic_home-a")!, size: CGSize(width: 15, height: 15))
            
        }
        else if btnWork1Location.isSelected
        {
            imageHome.image = UIImage(named: "ic_home-a-1")
            imageWork1.image = UIImage(named: "ic_work-a")
            imagePlace.image = UIImage(named: "ic_place-a")
            lblHome.textColor = UIColor(hex: colorXamNhat)
            lblWork.textColor = UIColor(hex: colorCam)
            lblPlace.textColor = UIColor(hex: colorXamNhat)
            lblWork.font = UIFont(name: "OpenSans-Semibold", size: 13)
            lblHome.font = UIFont(name: "OpenSans", size: 13)
            lblPlace.font = UIFont(name: "OpenSans", size: 13)
            txtLocation.insertImageLeft(image: UIImage(named: "ic_work-a")!, size: CGSize(width: 15, height: 15))
        }
        else if btnWork2Location.isSelected
        {
            imageHome.image = UIImage(named: "ic_home-a-1")
            imageWork1.image = UIImage(named: "ic_work-a-1")
            imagePlace.image = UIImage(named: "order_location")
            lblHome.textColor = UIColor(hex: colorXamNhat)
            lblWork.textColor = UIColor(hex: colorXamNhat)
            lblPlace.textColor = UIColor(hex: colorCam)
            lblPlace.font = UIFont(name: "OpenSans-Semibold", size: 13)
            lblHome.font = UIFont(name: "OpenSans", size: 13)
            lblWork.font = UIFont(name: "OpenSans", size: 13)
            txtLocation.insertImageLeft(image: UIImage(named: "order_location")!, size: CGSize(width: 15, height: 15))
        }
    }
    
    func setLocalize()
    {
        navItem.title = MCLocalization.string(forKey: "PROFILE")
        txtLocation.placeholder = MCLocalization.string(forKey: "LOCATIONINPUT")
        lblHome.text = MCLocalization.string(forKey: "HOME")
        lblWork.text = MCLocalization.string(forKey: "WORK")
        lblPlace.text = MCLocalization.string(forKey: "PLACE")
        if MCLocalization.sharedInstance().language == "en"
        {
            self.lblLanguage.text =  MCLocalization.string(forKey: "ENGLISH")
        }
        else if MCLocalization.sharedInstance().language == "vi"
        {
            self.lblLanguage.text =  MCLocalization.string(forKey: "VIETNAMESE")
        }
        
        self.view.layoutIfNeeded()
    }
    
    func closeInputData()
    {
        txtLocation.text =  listPoint[indexChooseTableViewCell].fullAddress
        viewClose.isHidden = true
        self.tblViewLocation.isHidden = true
        self.view.endEditing(true)
    }
    @IBAction func editAvatar (_ sender: UIButton)
    {
        tracking(actionKey: "C17.2Y")
        let alert = UIAlertController(title: MCLocalization.string(forKey: "CHOOSEIMAGE"), message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
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
        imageViewAvatar.image = (info[UIImagePickerControllerOriginalImage] as? UIImage)
        self.imageViewAvatar.setRound()
        let base64Image = convertImageToBase64(image: imageViewAvatar.image!)
        
        let birthdayString :String?
        if self.lblBirthday.text == MCLocalization.string(forKey: "YOURBIRTHDAY")
        {
            birthdayString = ""
        }
        else
        {
            birthdayString = self.lblBirthday.text
        }
        
        let emailString :String?
        if self.lblEmail.text == MCLocalization.string(forKey: "YOUREMAIL")
        {
            emailString = ""
        }
        else
        {
            emailString = self.lblEmail.text
        }
        DataConnect.updateProfile(userPhone_API, token: token_API, country_code: kCountryCode, new_email: emailString!, new_fullname: self.lblName.text!, new_avatar: base64Image, birthday: birthdayString!,view: self.view,  onsuccess: { (result) in
            
        }) { error in
            showErrorMessage(error: error as! Int, vc: self)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        print("picker cancel.")
        picker .dismiss(animated: true, completion: nil)
    }
    @IBAction func btnHome (_ sender: UIButton)
    {
        tracking(actionKey: "C17.3Y")
        btnHomeLocation.isSelected = true
        btnWork1Location.isSelected = false
        btnWork2Location.isSelected = false
        setStatusButton()
        indexChooseTableViewCell = 0
        txtLocation.text = listPoint[indexChooseTableViewCell].fullAddress
    }
    @IBAction func btnWork1 (_ sender: UIButton)
    {
        tracking(actionKey: "C17.5Y")
        btnHomeLocation.isSelected = false
        btnWork1Location.isSelected = true
        btnWork2Location.isSelected = false
        setStatusButton()
        indexChooseTableViewCell = 1
        txtLocation.text = listPoint[indexChooseTableViewCell].fullAddress
    }
    @IBAction func btnWork2 (_ sender: UIButton)
    {
        tracking(actionKey: "C17.4Y")
        btnHomeLocation.isSelected = false
        btnWork1Location.isSelected = false
        btnWork2Location.isSelected = true
        setStatusButton()
        indexChooseTableViewCell = 2
        txtLocation.text = listPoint[indexChooseTableViewCell].fullAddress
    }
    
    @IBAction func btnEdit (_ sender: UIButton)
    {
        flagKeyboard = true
        if sender.tag == 1
        {
            
            customAlertViewWithTextField(self,typeTextfield: "", title: MCLocalization.string(forKey: "INPUTFULLNAME"), btnTitleNameNormal: name_confirm_Button_Normal,btnCancelNameNormal: name_cancel_Button_Normal, titleOrangeButton: "OK", titleGreyButton: MCLocalization.string(forKey: "CANCEL"), blockCallback: { (result) in
                
                let fullName = result as? String
                self.view.endEditing(true)
                self.dismissVC()
                self.flagKeyboard = false
                
                let birthdayString :String?
                if self.lblBirthday.text == MCLocalization.string(forKey: "YOURBIRTHDAY")
                {
                    birthdayString = ""
                }
                else
                {
                    birthdayString = self.lblBirthday.text
                }

                let emailString :String?
                if self.lblEmail.text == MCLocalization.string(forKey: "YOUREMAIL")
                {
                    emailString = ""
                }
                else
                {
                    emailString = self.lblEmail.text
                }
                
                DataConnect.updateProfile(userPhone_API, token: token_API, country_code: kCountryCode, new_email: emailString!, new_fullname: fullName!, new_avatar: "", birthday: birthdayString! ,view: self.view,  onsuccess: { (result) in
                    self.lblName.text = fullName
                    appDelegate.nameUser = fullName
                }) { error in
                    showErrorMessage(error: error as! Int, vc: self)
                }
                
            }) { (result) in
                self.flagKeyboard = false
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        else if sender.tag == 2
        {
            customAlertViewWithTextField(self,typeTextfield: "", title: MCLocalization.string(forKey: "INPUTEMAIL"), btnTitleNameNormal: name_confirm_Button_Normal,btnCancelNameNormal: name_cancel_Button_Normal, titleOrangeButton: "OK", titleGreyButton: MCLocalization.string(forKey: "CANCEL"), blockCallback: { (result) in
                let email = result as? String
                self.view.endEditing(true)
                self.dismissVC()
                self.flagKeyboard = false
                
                let birthdayString :String?
                if self.lblBirthday.text == MCLocalization.string(forKey: "YOURBIRTHDAY")
                {
                    birthdayString = ""
                }
                else
                {
                    birthdayString = self.lblBirthday.text
                }
                
                DataConnect.updateProfile(userPhone_API, token: token_API, country_code: kCountryCode, new_email: email!, new_fullname: self.lblName.text!, new_avatar: "", birthday: birthdayString!, view: self.view, onsuccess: { (result) in
                    self.lblEmail.text = email
                }) { error in
                    showErrorMessage(error: error as! Int, vc: self)
                    
                    
                }
                
            }) { (result) in
                self.flagKeyboard = false
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        else if sender.tag == 3
        {
            
            self.showPopUpLanguage { (result) in
                self.setLocalize()
                if result as! String == "en"
                {
                    self.lblLanguage.text =  MCLocalization.string(forKey: "ENGLISH")
                }
                else if result as! String == "vi"
                {
                    self.lblLanguage.text =  MCLocalization.string(forKey: "VIETNAMESE")
                }
                
                
            }
            
            
        }
        else if sender.tag == 4
        {
            showCalendar(birthday: self.lblBirthday.text!, blockCallback: { (result) in
                let date = result as? String
                let emailString :String?
                if self.lblEmail.text == MCLocalization.string(forKey: "YOUREMAIL")
                {
                    emailString = ""
                }
                else
                {
                    emailString = self.lblEmail.text
                }
                DataConnect.updateProfile(userPhone_API, token: token_API, country_code: kCountryCode, new_email: emailString!, new_fullname: self.lblName.text!, new_avatar: "", birthday: date!, view: self.view, onsuccess: { (result) in
                    self.lblBirthday.text = date
                }) { error in
                    showErrorMessage(error: error as! Int, vc: self)
                    
                    
                }
                
            })
        }
    }
    
    
    func showCalendar(birthday: String,blockCallback: @escaping callBack)
    {
        let myAlert = pickUpStoryBoard.instantiateViewController(withIdentifier: "CalendarProfileViewController") as! CalendarProfileViewController
        myAlert.blockCallBack = blockCallback
        myAlert.birthday = birthday
        myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(myAlert, animated: false, completion: nil)
    }
    func showPopUpLanguage(blockCallback: @escaping callBack)
    {
        let myAlert = pickUpStoryBoard.instantiateViewController(withIdentifier: "LanguageViewController") as! LanguageViewController
        myAlert.blockCallBack = blockCallback
        myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(myAlert, animated: false, completion: nil)
    }
    
    func dismissVC()
    {
        tracking(actionKey: "C17.6N")
        self.dismiss(animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension UserProfileViewController: UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    func textFieldDidChange(_ textField: UITextField) {
        if textField.text?.length == 0
        {
            tblViewLocation.isHidden = true
            //viewClose.isHidden = false
        }
        else
        {
            tblViewLocation.isHidden = false
            //viewClose.isHidden = true
        }
        
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        filter.country = "VN"
        //        let visibleRegion = googleMapsView.projection.visibleRegion()
        //        let bounds = GMSCoordinateBounds(coordinate: visibleRegion.farLeft, coordinate: visibleRegion.nearRight)
        
        let lat = 10.779784
        let long = 106.698995
        let offset = 200.0 / 1000.0;
        let latMax = lat + offset;
        let latMin = lat - offset;
        let lngOffset = offset * cos(lat * .pi / 200.0);
        let lngMax = long + lngOffset;
        let lngMin = long - lngOffset;
        let initialLocation = CLLocationCoordinate2D(latitude: latMax, longitude: lngMax)
        let otherLocation = CLLocationCoordinate2D(latitude: latMin, longitude: lngMin)
        let bounds = GMSCoordinateBounds(coordinate: initialLocation, coordinate: otherLocation)
        placeClient.autocompleteQuery(textField.text!, bounds: bounds, filter: filter) { (results) -> Void in
            self.resultsArray.removeAll()
            if results.0 == nil {
                return
            }
            for result in results.0! {
                let objAddress = Address()
                objAddress.name = result.attributedPrimaryText.string
                objAddress.street = result.attributedSecondaryText!.string
                objAddress.fullAddress = result.attributedFullText.string
                objAddress.placeID = result.placeID!
                self.resultsArray.append(objAddress)
                
            }
            self.tblViewLocation.reloadData()
        }
        
        
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        viewClose.isHidden = false
        tblViewLocation.isHidden = true
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return resultsArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblViewLocation.dequeueReusableCell(withIdentifier: "deliveryCell") as! DeliveryTableViewCell
        cell.lblTitle.text = self.resultsArray[(indexPath as NSIndexPath).row].name
        cell.lbldetail.text = self.resultsArray[(indexPath as NSIndexPath).row].street
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tblViewLocation.isHidden = true
        viewClose.isHidden = true
        txtLocation.endEditing(true)
        if indexChooseTableViewCell == 0
        {
            listPoint[indexChooseTableViewCell].name = "Home"
        }
        else if indexChooseTableViewCell == 1
        {
            listPoint[indexChooseTableViewCell].name = "Work"
        }
        else if indexChooseTableViewCell == 2
        {
            listPoint[indexChooseTableViewCell].name = "Place"
        }
        listPoint[indexChooseTableViewCell].fullAddress = self.resultsArray[indexPath.row].fullAddress
        listPoint[indexChooseTableViewCell].street = self.resultsArray[indexPath.row].street
        listPoint[indexChooseTableViewCell].placeID = self.resultsArray[indexPath.row].placeID
        txtLocation.text = self.resultsArray[indexPath.row].fullAddress
        
        var list : [String] = []
        for item in listPoint
        {
            list.append(item.toJSON()!)
        }
        defaults.setValue(list, forKey: "locations")
        // let listPoint = [PointLocation().toJSON(),PointLocation().toJSON(),PointLocation().toJSON()]
        //  defaults.setValue(listPoint, forKey: "locations")
        
    }
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        listPoint[indexChooseTableViewCell].address = self.resultsArray[indexPath.row].fullAddress
    //        listPoint[indexChooseTableViewCell].placeid = self.resultsArray[indexPath.row].placeID
    //        txtLocation.text = self.resultsArray[indexPath.row].fullAddress
    //    }
    
    
    
    
}
