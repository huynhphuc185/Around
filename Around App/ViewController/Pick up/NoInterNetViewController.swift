//
//  AlertViewController.swift
//  Around App
//
//  Created by phuc.huynh on 8/11/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import UIKit

class NoInterNetViewController: StatusbarViewController {
    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var btnConfirm: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        // Do any additional setup after loading the view.
    }

    @IBAction func btnConfirm (_ sender: UIButton)
    {
        
//        if connectedToNetwork() == true{
//           appDelegate.setRootView()
//        }else
//        {
//            UIApplication.shared.openURL(URL(string:UIApplicationOpenSettingsURLString)!)
//        }
        
        exit(0)
        
       
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
