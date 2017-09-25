//
//  InformationPickUpViewController.swift
//  Around
//
//  Created by phuc.huynh on 1/13/17.
//  Copyright © 2017 phuc.huynh. All rights reserved.
//

import UIKit
import GooglePlaces
class BackToPickupInfomartionViewController: StatusbarViewController {
    @IBOutlet weak var btnCheckBox: UIButton!
    @IBOutlet weak var tapView: UIView!
    @IBOutlet weak var lblBackToPickup: CustomLabel!
    @IBOutlet weak var lblNote: CustomLabel!
    @IBOutlet weak var btnConfirm: UIButton!
    var blockCallBack : callBack?
    var point : PointLocation?
    var placeClient = GMSPlacesClient()
    var sender : DataSender?
    
     var flagTapClose: Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        btnCheckBox.isSelected = (sender?.returnToPickupSender)!
        // Do any additional setup after loading the view.
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.closeView))
        self.tapView.addGestureRecognizer(gesture)
    }
    
    
    func closeView()
    {
        if flagTapClose == false
        {
            return
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnConfirm (_ sender: UIButton){
        tracking(actionKey: "C5.7Y")
        showProgressHub()
        placeClient.lookUpPlaceID(point!.placeid!, callback: { (place, err) -> Void in
            if let error = err {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            
            if let place = place {
                self.point?.placeid = place.placeID
                self.point?.latitude = place.coordinate.latitude
                self.point?.longitude = place.coordinate.longitude
                self.sender?.returnToPickupSender = self.btnCheckBox.isSelected
            } else {
                print("No place details for")
            }
            hideProgressHub()
            self.blockCallBack!(nil)
        })


    }
    
    @IBAction func selectRadioButton(_ sender: UIButton) {

        tracking(actionKey: "C5.6Y")
        if btnCheckBox.isSelected == true
        {
            btnCheckBox.isSelected = false
        }
        else
        {
            btnCheckBox.isSelected = true
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
