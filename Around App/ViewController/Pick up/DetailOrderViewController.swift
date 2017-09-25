//
//  DetailOrderViewController.swift
//  Shipper
//
//  Created by phuc.huynh on 10/10/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import UIKit

class DetailOrderViewController: StatusbarViewController {
 @IBOutlet weak var sidebarButton: UIBarButtonItem!
    @IBOutlet weak var txtPickupLocation: BottomLineTextfield!
    @IBOutlet weak var txtNote: BottomLineTextfield!
    @IBOutlet weak var txtStatus: BottomLineTextfield!
    var point:PointLocation?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sidebarButton.action = #selector(self.goBack)
        txtPickupLocation.isEnabled = false
        txtNote.isEnabled = false
        txtStatus.isEnabled = false
        txtPickupLocation.text = point?.address
        txtNote.text = point?.note
        txtStatus.text = "Done"
        // Do any additional setup after loading the view.

    }
    
    func goBack()  {
        self.navigationController?.popViewController(animated: true)
       
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
