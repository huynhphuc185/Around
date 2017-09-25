//
//  AlertViewController.swift
//  Around App
//
//  Created by phuc.huynh on 8/11/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import UIKit

class AlertViewController: StatusbarViewController {
    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var btnConfirm: UIButton!
    var titleMessage  = ""
    var btnimageName = ""
    var titleButton = ""
    var blockCallBack : callBack?
    override func viewDidLoad() {
        super.viewDidLoad()
        txtTitle.text = titleMessage
        btnConfirm.setTitle(titleButton, for: UIControlState())
        btnConfirm.setImage(UIImage(), for: UIControlState())
        btnConfirm.setBackgroundImage(UIImage(named: btnimageName), for: UIControlState())
        btnConfirm.addTarget(self, action: #selector(AlertViewController.clickAction), for: .touchUpInside)

    }
    func clickAction()
    {
        self.dismiss(animated: false) { 
             self.blockCallBack!(nil)
        }
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
