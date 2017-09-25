//
//  NavigationViewController.swift
//  Around
//
//  Created by phuc.huynh on 3/9/17.
//  Copyright © 2017 phuc.huynh. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override var prefersStatusBarHidden : Bool {
        return false
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation
    {
        return UIStatusBarAnimation.slide
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
