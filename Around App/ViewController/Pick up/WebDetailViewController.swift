//
//  WebDetailViewController.swift
//  Around
//
//  Created by phuc.huynh on 8/28/17.
//  Copyright © 2017 phuc.huynh. All rights reserved.
//

import UIKit

class WebDetailViewController: StatusbarViewController {
    var id_notification: Int?
    var isCloseLefftButton = false
    @IBOutlet weak var sidebarButton: UIBarButtonItem!
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if isCloseLefftButton == false
        {
            sidebarButton.image = UIImage(named: "back x2")
            sidebarButton.action = #selector(self.back)
        }
        else
        {
            sidebarButton.image = UIImage(named: "close x2")
            sidebarButton.action = #selector(self.close)
        }

        DataConnect.getNotificationDetail(token_API, country_code: kCountryCode, phone: userPhone_API, id: id_notification!, view: self.view, onsuccess: { (result) in
            let detail = result as? NotificationDetail
            if MCLocalization.sharedInstance().language == "en"
            {
                self.webView.loadHTMLString((detail?.detail?.fromBase64())!, baseURL: Bundle.main.bundleURL)
            }
            else
            {
                self.webView.loadHTMLString((detail?.vn_detail?.fromBase64())!, baseURL: Bundle.main.bundleURL)
            }
            
        }) { (error) in
            showErrorMessage(error: error as! Int, vc: self)
        }
        // Do any additional setup after loading the view.
    }
    func back (_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    func close (_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
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
