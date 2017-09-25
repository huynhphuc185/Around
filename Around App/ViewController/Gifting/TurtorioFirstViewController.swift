//
//  TurtorioFirstViewController.swift
//  Around
//
//  Created by phuc.huynh on 8/2/17.
//  Copyright © 2017 phuc.huynh. All rights reserved.
//

import UIKit

class TurtorioFirstViewController: StatusbarViewController {
    var imageName: String?
    @IBOutlet weak var imageDemo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageDemo.image = UIImage(named: imageName!)
        // Do any additional setup after loading the view.
    }
    @IBAction func btnClose(_ sender_: UIButton) {
        self.dismiss(animated: true) {
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
