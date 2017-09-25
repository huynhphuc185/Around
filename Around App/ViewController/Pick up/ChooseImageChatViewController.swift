//
//  ChooseImageChatViewController.swift
//  Around
//
//  Created by phuc.huynh on 12/2/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import UIKit

class ChooseImageChatViewController: WithOutStatusBarViewController {
    @IBOutlet weak var imageView: UIImageView!
    var chooseImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = chooseImage
        let btnBack = UIButton()
        btnBack.frame = CGRect(x: 0, y: 0, width: 30, height: 50)
        btnBack.setImage(UIImage(named: "back normal x2"), for: UIControlState())
        btnBack.addTarget(self, action: #selector(self.btnBack(_:)), for: .touchUpInside)
        self.view.addSubview(btnBack)
        // Do any additional setup after loading the view.
    }
@IBAction func btnBack (_ sender: UIButton)
{
    self.dismiss(animated: false, completion: nil)
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
