//
//  ToBeSupplierViewController.swift
//  Around
//
//  Created by phuc.huynh on 8/21/17.
//  Copyright © 2017 phuc.huynh. All rights reserved.
//

import UIKit

class ToBeSupplierViewController: StatusbarViewController,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,YMSPhotoPickerViewControllerDelegate,UITextFieldDelegate {
    @IBOutlet weak var txtHoten: BottomLineTextfield!
    @IBOutlet weak var txtTencuahang: BottomLineTextfield!
    @IBOutlet weak var txtSodienthoai: BottomLineTextfield!
    @IBOutlet weak var txtDiachi: BottomLineTextfield!
    @IBOutlet weak var txtEmail: BottomLineTextfield!
    @IBOutlet weak var txtWebsite: BottomLineTextfield!
    @IBOutlet weak var txtFacebook: BottomLineTextfield!
    @IBOutlet weak var txtMathanghoptac: BottomLineTextfield!
    @IBOutlet weak var photoCollection: UICollectionView!
    @IBOutlet weak var btnGiaonhan: UIButton!
    @IBOutlet weak var btnHangHoa: UIButton!
    @IBOutlet weak var constrainBottom: NSLayoutConstraint!
    @IBOutlet weak var mainScrollView: UIScrollView!
    var listImage: NSMutableArray! = []
    var indexType = "1"
    override func viewDidLoad() {
        super.viewDidLoad()
        txtHoten.useUnderline()
        txtTencuahang.useUnderline()
        txtSodienthoai.useUnderline()
        txtDiachi.useUnderline()
        txtEmail.useUnderline()
        txtWebsite.useUnderline()
        txtFacebook.useUnderline()
        txtMathanghoptac.useUnderline()
        self.hideKeyboardWhenTappedAround()
        self.photoCollection.register(UINib.init(nibName: "DemoImageViewCell", bundle: nil), forCellWithReuseIdentifier: "imageCellIdentifier")
        if indexType == "1"
        {
            btnGiaonhan.isSelected = true
            btnHangHoa.isSelected = false
        }
        else
        {
            btnGiaonhan.isSelected = false
            btnHangHoa.isSelected = true
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func btnClose (_ sender: UIButton)
    {
        tracking(actionKey: "C17.6N")
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func btnPaymentMethod(_ sender: UIButton) {
        if sender.tag == 1
        {
            indexType = "1"
            btnGiaonhan.isSelected = true
            btnHangHoa.isSelected = false
        }
        else if sender.tag == 2
        {
            indexType = "2"
            btnGiaonhan.isSelected = false
            btnHangHoa.isSelected = true
        }
    }
    @IBAction func btnSubmit(_ sender: UIButton) {
        self.view.endEditing(true)
        if (txtHoten.text?.length)! != 0 && (txtTencuahang.text?.length)! != 0 && (txtSodienthoai.text?.length)! > 0 && (txtDiachi.text?.length)! != 0 && isValidEmail(testStr: txtEmail.text!) && (txtMathanghoptac.text?.length)! != 0
        {
            txtHoten.removeRightIcon()
            txtTencuahang.removeRightIcon()
            txtSodienthoai.removeRightIcon()
            txtDiachi.removeRightIcon()
            txtEmail.removeRightIcon()
            txtMathanghoptac.removeRightIcon()
            
//            if (txtSodienthoai.text?.length)! < 10
//            {
//                self.mainScrollView.setContentOffset(CGPoint.zero, animated: true)
//                txtSodienthoai.insertImageRight(image: UIImage(named: "icon-loi")!, size : CGSize(width: 15, height: 15))
//                txtSodienthoai.shake()
//                return
//            }
//           if isValidEmail(testStr: txtEmail.text!) == false
//           {
//            self.mainScrollView.setContentOffset(CGPoint.zero, animated: true)
//                txtEmail.insertImageRight(image: UIImage(named: "icon-loi")!, size : CGSize(width: 15, height: 15))
//                txtEmail.shake()
//                return
//            }
           
            if self.listImage.count == 0
            {
                customAlertView(self, title: MCLocalization.string(forKey: "KHONGHINHANH") , btnTitleNameNormal: name_confirm_Button_Normal,titleButton: "OK",  blockCallback: { (result) in
                    
                })
            }
            else
            {
                DataConnect.tobeSupplier(userPhone_API, country_code: kCountryCode, token: token_API, fullname: txtHoten.text!, shopname: txtTencuahang.text!, address: txtDiachi.text!, phone_number: txtSodienthoai.text!, email: txtEmail.text!, product: txtMathanghoptac.text!, type: indexType,website: txtWebsite.text!, facebook: txtFacebook.text!, arrImage: listImage, view: self.view, onsuccess: { (result) in
                    customAlertView(self, title: MCLocalization.string(forKey: "SUPPLIERTHANHCONG") , btnTitleNameNormal: name_confirm_Button_Normal,titleButton: "OK",  blockCallback: { (result) in
                        self.dismiss(animated: true, completion: nil)
                    })
                    
                }) { (error) in
                    showErrorMessage(error: error as! Int, vc: self)
                }
                
                
            }
            
        }
        else
        {
            
            self.mainScrollView.setContentOffset(CGPoint.zero, animated: true)
            if txtHoten.text?.length == 0
            {
                txtHoten.insertImageRight(image: UIImage(named: "icon-loi")!, size : CGSize(width: 15, height: 15))
                txtHoten.shake()
            }
            else
            {
                txtHoten.removeRightIcon()
            }
            
            if txtTencuahang.text?.length == 0
            {
                txtTencuahang.insertImageRight(image: UIImage(named: "icon-loi")!, size : CGSize(width: 15, height: 15))
                txtTencuahang.shake()
            }
            else
            {
                txtTencuahang.removeRightIcon()
            }
            
            
            if (txtSodienthoai.text?.length)! < 10
            {
                txtSodienthoai.insertImageRight(image: UIImage(named: "icon-loi")!, size : CGSize(width: 15, height: 15))
                txtSodienthoai.shake()
            }
            else
            {
                txtSodienthoai.removeRightIcon()
            }
            
            if txtDiachi.text?.length == 0
            {
                txtDiachi.insertImageRight(image: UIImage(named: "icon-loi")!, size : CGSize(width: 15, height: 15))
                txtDiachi.shake()
            }
            else
            {
                txtDiachi.removeRightIcon()
            }
            
            if isValidEmail(testStr: txtEmail.text!) == false
            {
                txtEmail.insertImageRight(image: UIImage(named: "icon-loi")!, size : CGSize(width: 15, height: 15))
                txtEmail.shake()
            }
            else
            {
                txtEmail.removeRightIcon()
            }
            
            if txtMathanghoptac.text?.length == 0
            {
                txtMathanghoptac.insertImageRight(image: UIImage(named: "icon-loi")!, size : CGSize(width: 15, height: 15))
                txtMathanghoptac.shake()
            }
            else
            {
                txtMathanghoptac.removeRightIcon()
            }
            
        }
        
        
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.txtMathanghoptac
        {
            dismissKeyboard()
        }
        else
        {
            //                if textField.nextField == txtSodienthoai
            //                {
            //                    txtDiachi.becomeFirstResponder()
            //                }
            //                else
            //                {
            textField.nextField?.becomeFirstResponder()
            //  }
            
        }
        return true
        
    }
    // MARK: - YMSPhotoPickerViewControllerDelegate
    
    func photoPickerViewControllerDidReceivePhotoAlbumAccessDenied(_ picker: YMSPhotoPickerViewController!) {
        let alertController = UIAlertController.init(title: "Allow photo album access?", message: "Need your permission to access photo albumbs", preferredStyle: .alert)
        let dismissAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        let settingsAction = UIAlertAction.init(title: "Settings", style: .default) { (action) in
            UIApplication.shared.openURL(URL.init(string: UIApplicationOpenSettingsURLString)!)
        }
        alertController.addAction(dismissAction)
        alertController.addAction(settingsAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func photoPickerViewControllerDidReceiveCameraAccessDenied(_ picker: YMSPhotoPickerViewController!) {
        let alertController = UIAlertController.init(title: "Allow camera album access?", message: "Need your permission to take a photo", preferredStyle: .alert)
        let dismissAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        let settingsAction = UIAlertAction.init(title: "Settings", style: .default) { (action) in
            UIApplication.shared.openURL(URL.init(string: UIApplicationOpenSettingsURLString)!)
        }
        alertController.addAction(dismissAction)
        alertController.addAction(settingsAction)
        
        // The access denied of camera is always happened on picker, present alert on it to follow the view hierarchy
        picker.present(alertController, animated: true, completion: nil)
    }
    
    func photoPickerViewController(_ picker: YMSPhotoPickerViewController!, didFinishPicking image: UIImage!) {
        picker.dismiss(animated: true) {
            //   self.images = [image]
            //self.collectionView.reloadData()
        }
    }
    
    func photoPickerViewController(_ picker: YMSPhotoPickerViewController!, didFinishPickingImages photoAssets: [PHAsset]!) {
        picker.dismiss(animated: true) {
            showProgressHub()
            
           
            
            let myGroup = DispatchGroup()
            for asset: PHAsset in photoAssets
            {
                myGroup.enter()
                self.getAssetImage(asset: asset, firstTry: true, completion: { (image) in
                    self.listImage.add(image!)
                    myGroup.leave()
                })
            }
            
            myGroup.notify(queue: .main) {
                hideProgressHub()
                self.photoCollection.reloadData()
            }
        }
    }
    
    
    private func getAssetImage(asset: PHAsset, firstTry: Bool, completion: @escaping (UIImage?) -> Void) {
        //let targetSize = CGSizeMake(1000, (CGFloat(asset.pixelHeight) / CGFloat(asset.pixelWidth)) * 1000)
        let targetSize = CGSize(width: 400, height: (CGFloat(asset.pixelHeight) / CGFloat(asset.pixelWidth)) * 400)
        let options = PHImageRequestOptions()
        options.version = PHImageRequestOptionsVersion.current
        options.deliveryMode =  PHImageRequestOptionsDeliveryMode.highQualityFormat
        options.resizeMode = PHImageRequestOptionsResizeMode.exact
        options.isNetworkAccessAllowed = true
        
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: PHImageContentMode.aspectFill, options: options) { (result: UIImage?, info) -> Void in
            let degraded = info?[PHImageResultIsDegradedKey] as? NSNumber
            
            if degraded != nil && !degraded!.boolValue {
                print("asset.pixelWidth: \(asset.pixelWidth)")
                print("asset.pixelHeight: \(asset.pixelHeight)")
                print("targetSize: \(targetSize)")
                print("result.size: \(result!.size)")
                print("result.imageOrientation: \(result!.imageOrientation.rawValue)")
                
                if (targetSize.width - targetSize.height) * (result!.size.width - result!.size.height) < 0 {
                    if firstTry {
                        print("Resulting image's dimensions are not in accordance with target size. Reversing dimensions!")
                        self.getAssetImage(asset: asset, firstTry: false, completion: completion)
                    } else {
                        print("Resulting image's dimensions are still not in accordance with target size. Giving up!")
                        completion(nil)
                    }
                    
                } else {
                    completion(result)
                }
            }
        }
    }
    func addMore()
    {
        let pickerViewController = YMSPhotoPickerViewController.init()
        let numberOfSelect = 3 - listImage.count
        pickerViewController.numberOfPhotoToSelect = UInt(numberOfSelect)
        
        let customColor = UIColor.init(red:252/255.0, green:131/255.0, blue:1/255.0, alpha:1.0)
        pickerViewController.theme.titleLabelTextColor = UIColor.white
        pickerViewController.theme.navigationBarBackgroundColor = customColor
        let colors =  [UIColor(hex: "#fc8301").cgColor, UIColor(hex: "#f7bf00").cgColor]
        let startPoint = CGPoint(x: 0.0, y: 0.5)
        let endPoint = CGPoint(x: 1.0, y: 0.5)
        var bounds : CGRect?
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS
        {
            bounds = CGRect(x: 0, y: 0, width: 320, height: 64)
        }
        else if DeviceType.IS_IPHONE_6
        {
            bounds = CGRect(x: 0, y: 0, width: 375, height: 64)
        }
        else if DeviceType.IS_IPHONE_6P
        {
            bounds = CGRect(x: 0, y: 0, width: 414, height: 64)
        }
        let image = setGradian(bounds: bounds! , colors: colors, startPoint: startPoint, endPoint: endPoint)
        
        pickerViewController.theme.navigationBarImageBackground = image
        
        pickerViewController.theme.tintColor = UIColor.white
        pickerViewController.theme.orderTintColor = customColor
        pickerViewController.theme.orderLabelTextColor = UIColor.white
        pickerViewController.theme.cameraVeilColor = customColor
        pickerViewController.theme.cameraIconColor = UIColor.white
        pickerViewController.theme.statusBarStyle = .default
        
        self.yms_presentCustomAlbumPhotoView(pickerViewController, delegate: self)
    }
    func deletePhotoImage(_ sender: UIButton!) {
        self.listImage.removeObject(at: sender.tag)
        self.photoCollection.reloadData()
        
    }
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if listImage.count == 3
        {
            return 3
        }
        return  listImage.count + 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if listImage.count == 3
        {
            
            let cell: DemoImageViewCell! = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCellIdentifier", for: indexPath) as! DemoImageViewCell
            cell.progressBar.isHidden = true
            cell.photoImageView.image = (self.listImage.object(at: indexPath.item) as! UIImage)
            cell.deleteButton.tag = (indexPath as NSIndexPath).item
            cell.deleteButton.addTarget(self, action: #selector(self.deletePhotoImage(_:)), for: .touchUpInside)
            return cell
            
            
            
        }
        else
        {
            if indexPath.item == listImage.count
            {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddMoreCell", for: indexPath) as! AddMoreCell
                cell.btnAddMore.addTarget(self, action: #selector(self.addMore), for: .touchUpInside)
//                cell.btnAddMore.backgroundColor = UIColor.gray
                return cell
                
            }
            else
            {
                let cell: DemoImageViewCell! = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCellIdentifier", for: indexPath) as! DemoImageViewCell
                cell.progressBar.isHidden = true
                cell.photoImageView.image = (self.listImage.object(at: indexPath.item) as! UIImage)
                cell.deleteButton.tag = (indexPath as NSIndexPath).item
                cell.deleteButton.addTarget(self, action: #selector(self.deletePhotoImage(_:)), for: .touchUpInside)
                return cell
                
                
            }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 100, height: 100)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        let fileName: String = self.noteDetail.note_attach_files[indexPath.row].file_url!
        //        let fileNameArr = fileName.components(separatedBy: ".")
        //        let fileTag:String  = fileNameArr.last!
        //        print("////////////////////////\(fileTag)")
        //
        //        let cell: DemoImageViewCell! = collectionView.cellForItem(at: indexPath) as! DemoImageViewCell
        //        if (fileTag != "png" && fileTag != "jpg" && fileTag != "jpeg") {
        //            customAlertViewWithCancelButton(self, title: "Bạn có muốn download file này không?", btnTitleNameNormal: name_confirm_Button_Normal, btnCancelNameNormal: name_cancel_Button_Normal, titleOrangeButton: "OK", titleGreyButton: MCLocalization.string(forKey: "CANCEL"),blockCallback: {result in
        //                let cell: DemoImageViewCell! = collectionView.cellForItem(at: indexPath) as! DemoImageViewCell
        //                let url = self.noteDetail.note_attach_files[indexPath.row].file_url
        //                let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        //                cell.progressBar.isHidden = false
        //                Alamofire.download(
        //                    url!,
        //                    method: .get,
        //                    parameters: nil,
        //                    encoding: JSONEncoding.default,
        //                    headers: nil,
        //                    to: destination).downloadProgress(closure: { (progress) in
        //                        let percent = Float(progress.completedUnitCount) / Float(progress.totalUnitCount)
        //                        cell.progressBar.setProgress(Float(percent), animated: true)
        //                    }).response(completionHandler: { (DefaultDownloadResponse) in
        //                        cell.progressBar.setProgress(0, animated: false)
        //                        cell.progressBar.isHidden = true
        //                        customAlertView(self, title: "Done!", btnTitleNameNormal: name_confirm_Button_Normal,titleButton: "OK") { result in
        //                        }
        //                    })
        //
        //            }, blockCallbackCancel: {result in
        //
        //
        //            })
        //
        //
        //        }else{
        //            CustomPhotoAlbum.sharedInstance.save(image: cell.photoImageView.image!) { (result) in
        //                customAlertView(self, title: "Download xong!", btnTitleNameNormal: name_confirm_Button_Normal,titleButton: "OK") { result in
        //                }
        //            }
        //
        //        }
        
        //        let pickerViewController = YMSPhotoPickerViewController.init()
        //        //let numberOfSelect = 3
        //        pickerViewController.numberOfPhotoToSelect = 3
        //        pickerViewController.selectedPhotos = listImage
        //        let customColor = UIColor.init(red:252/255.0, green:131/255.0, blue:1/255.0, alpha:1.0)
        //        pickerViewController.theme.titleLabelTextColor = UIColor.white
        //        pickerViewController.theme.navigationBarBackgroundColor = customColor
        //        let colors =  [UIColor(hex: "#fc8301").cgColor, UIColor(hex: "#f7bf00").cgColor]
        //        let startPoint = CGPoint(x: 0.0, y: 0.5)
        //        let endPoint = CGPoint(x: 1.0, y: 0.5)
        //        var bounds : CGRect?
        //        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS
        //        {
        //            bounds = CGRect(x: 0, y: 0, width: 320, height: 64)
        //        }
        //        else if DeviceType.IS_IPHONE_6
        //        {
        //            bounds = CGRect(x: 0, y: 0, width: 375, height: 64)
        //        }
        //        else if DeviceType.IS_IPHONE_6P
        //        {
        //            bounds = CGRect(x: 0, y: 0, width: 414, height: 64)
        //        }
        //        let image = setGradian(bounds: bounds! , colors: colors, startPoint: startPoint, endPoint: endPoint)
        //
        //        pickerViewController.theme.navigationBarImageBackground = image
        //
        //        pickerViewController.theme.tintColor = UIColor.white
        //        pickerViewController.theme.orderTintColor = customColor
        //        pickerViewController.theme.orderLabelTextColor = UIColor.white
        //        pickerViewController.theme.cameraVeilColor = customColor
        //        pickerViewController.theme.cameraIconColor = UIColor.white
        //        pickerViewController.theme.statusBarStyle = .default
        //        
        //        self.yms_presentCustomAlbumPhotoView(pickerViewController, delegate: self)
    }
    
    
    
    
}
class AddMoreCell:UICollectionViewCell
{
    @IBOutlet weak var btnAddMore: UIButton!
}
