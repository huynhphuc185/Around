//
//  AlertViewController.swift
//  Around App
//
//  Created by phuc.huynh on 8/11/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import UIKit

class AlertWithCancelButtonViewController: StatusbarViewController {
    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var imageCLose: UIImageView!
    var titleMessage  = ""
    var btnimageName = ""
    var btnimageNameCancel = ""
    var titleOrangeButton = ""
    var titleGreyButton = ""
    var isCLoseButton = false
    var blockCallBack : callBack?
    var blockCallBackCancel : callBack?
    var blockCallBackClose : callBack?
    override func viewDidLoad() {
        super.viewDidLoad()
        txtTitle.text = titleMessage
        btnConfirm.setTitle(titleOrangeButton, for: UIControlState())
        btnConfirm.setImage(UIImage(), for: UIControlState())
        btnConfirm.setBackgroundImage(UIImage(named: btnimageName), for: UIControlState())
        btnConfirm.addTarget(self, action: #selector(AlertWithCancelButtonViewController.clickAction), for: .touchUpInside)
        btnCancel.setTitle(titleGreyButton, for: UIControlState())
        btnCancel.setImage(UIImage(), for: UIControlState())
        btnCancel.setBackgroundImage(UIImage(named: btnimageNameCancel), for: UIControlState())
        btnCancel.addTarget(self, action: #selector(AlertWithCancelButtonViewController.cancelAction), for: .touchUpInside)
       
        if isCLoseButton
        {
            btnClose.isHidden = false
            imageCLose.isHidden = false
            btnClose.addTarget(self, action: #selector(AlertWithCancelButtonViewController.clickClose), for: .touchUpInside)
        }
        else
        {
            imageCLose.isHidden = true
            btnClose.isHidden = true
        }
        
        // Do any additional setup after loading the view.
    }
    func clickClose()
    {
        self.dismiss(animated: false) {
            self.blockCallBackClose!(nil)
        }
    }
    func clickAction()
    {
        self.dismiss(animated: false) { 
            self.blockCallBack!(nil)
        }
    }
    func cancelAction()
    {
        self.dismiss(animated: false) {
            self.blockCallBackCancel!(nil)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
