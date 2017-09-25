//
//  PopUpGiaViewController.swift
//  Around
//
//  Created by phuc.huynh on 6/13/17.
//  Copyright © 2017 phuc.huynh. All rights reserved.
//

import UIKit

class PopUpGiaViewController: StatusbarViewController {
    @IBOutlet weak var tapView: UIView!
    @IBOutlet weak var imageViewPrice: UIImageView!
    var imageURL: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.closeView))
        self.tapView.addGestureRecognizer(gesture)
        if let url = URL(string: imageURL!),let placeholder = UIImage(named: "default_product") {
            imageViewPrice.sd_setImageWithURLWithFade(url, placeholderImage: placeholder)
        }
//        if MCLocalization.sharedInstance().language == "en"
//        {
//            if let url = URL(string: Config.sharedInstance.imagePrice_TA!),let placeholder = UIImage(named: "default_product") {
//                imageViewPrice.sd_setImageWithURLWithFade(url, placeholderImage: placeholder)
//            }
//        }
//        else if MCLocalization.sharedInstance().language == "vi"
//        {
//            if let url = URL(string: Config.sharedInstance.imagePrice_TV!),let placeholder = UIImage(named: "default_product") {
//                imageViewPrice.sd_setImageWithURLWithFade(url, placeholderImage: placeholder)
//            }
//            
//        }
        
    }
    func closeView()
    {
        self.dismiss(animated: false, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
