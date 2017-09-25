//
//  AlertViewController.swift
//  Around App
//
//  Created by phuc.huynh on 8/11/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import UIKit

class AlertWithTextFieldViewController: StatusbarViewController {
    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var txtInput: PaddingTextField?
    var titleMessage  = ""
    var btnimageName = ""
    var btnimageNameCancel = ""
    var titleOrangeButton = ""
    var titleGreyButton = ""
    var blockCallBack : callBack?
    var blockCallBackCancel: callBack?
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        txtTitle.text = titleMessage
        btnConfirm.setTitle(titleOrangeButton, for: UIControlState())
        btnConfirm.setImage(UIImage(), for: UIControlState())
        btnConfirm.setBackgroundImage(UIImage(named: btnimageName), for: UIControlState())
        btnConfirm.addTarget(self, action: #selector(self.clickConfirm), for: .touchUpInside)
        btnCancel.setTitle(titleGreyButton, for: UIControlState())
        btnCancel.setImage(UIImage(), for: UIControlState())
        btnCancel.setBackgroundImage(UIImage(named: btnimageNameCancel), for: UIControlState())
        btnCancel.addTarget(self, action: #selector(self.cancelAction), for: .touchUpInside)
        txtInput!.becomeFirstResponder()
        
        

        // Do any additional setup after loading the view.
    }
    func clickConfirm()
    {
        dismissKeyboard()
        blockCallBack!(txtInput!.text as AnyObject?)
        
    }
    func cancelAction()
    {
        dismissKeyboard()
        blockCallBackCancel!(nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
