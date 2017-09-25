//
//  NetworkViewController.swift
//  Around
//
//  Created by phuc.huynh on 6/1/17.
//  Copyright © 2017 phuc.huynh. All rights reserved.
//

import UIKit

class NetworkViewController: StatusbarViewController {
    @IBOutlet weak var viewTap: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.close))
        self.viewTap.addGestureRecognizer(gesture)
    }

    
    func close()
    {
        self.dismiss(animated: false, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    



}
