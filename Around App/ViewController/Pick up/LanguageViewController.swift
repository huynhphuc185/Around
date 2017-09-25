//
//  InformationPickUpViewController.swift
//  Around
//
//  Created by phuc.huynh on 1/13/17.
//  Copyright © 2017 phuc.huynh. All rights reserved.
//

import UIKit
import GooglePlaces
class LanguageViewController : StatusbarViewController {
    @IBOutlet weak var btnEnglish: UIButton!
    @IBOutlet weak var btnVietnamese: UIButton!
    @IBOutlet weak var imageEnglish: UIImageView!
    @IBOutlet weak var imageVietnam: UIImageView!
    @IBOutlet weak var viewClose: UIView!
    var blockCallBack : callBack?
    override func viewDidLoad() {
        super.viewDidLoad()
        if MCLocalization.sharedInstance().language == "en"
        {
            self.btnEnglish.isSelected = true
        }
        else
        {
            self.btnVietnamese.isSelected = true
        }
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.close))
        self.viewClose.addGestureRecognizer(gesture)
        
    }
    func close()
    {
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func btnConfirm (_ sender: UIButton){
        self.dismiss(animated: false) {
            
            if self.btnEnglish.isSelected == true{
                MCLocalization.sharedInstance().language = "en"
                self.blockCallBack!("en" as AnyObject?)
                
            }
            else
            {
                MCLocalization.sharedInstance().language = "vi"
                self.blockCallBack!("vi" as AnyObject?)
                
            }

           
        }
    }
    @IBAction func selectRadioButton(_ sender: UIButton) {
        
        if sender.tag == 1
        {
            btnEnglish.isSelected = true
            btnVietnamese.isSelected = false
        }
        else if sender.tag == 2
        {
            btnVietnamese.isSelected = true
            btnEnglish.isSelected = false
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
