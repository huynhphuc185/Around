//
//  HistoryViewController.swift
//  Shipper
//
//  Created by phuc.huynh on 10/11/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import UIKit

class HistoryViewController: StatusbarViewController {

    @IBOutlet weak var sidebarButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sidebarButton.action = #selector(self.dissmissViewController)
        
        
               
        
    }
    func dissmissViewController()
    {
        self.dismiss(animated: true, completion: nil)
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
