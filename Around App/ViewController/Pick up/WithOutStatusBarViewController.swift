//
//  WithOutStatusBarViewController.swift
//  Around
//
//  Created by phuc.huynh on 8/2/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import UIKit

class WithOutStatusBarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
