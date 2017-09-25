//
//  WriteCommentViewController.swift
//  Around
//
//  Created by phuc.huynh on 2/23/17.
//  Copyright © 2017 phuc.huynh. All rights reserved.
//

import UIKit

class WriteCommentViewController: StatusBarWithSearchBarViewController,UITextViewDelegate {
    @IBOutlet weak var viewRate: FloatRatingView!
    @IBOutlet weak var tvComment: UITextView!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var csHeight: NSLayoutConstraint!
    var id_product: Int?
    var enableRate : Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        self.hideKeyboardWhenTappedAround()
        tvComment.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        tvComment.layer.borderWidth = 1.0
        tvComment.layer.cornerRadius = 5
        tvComment.delegate = self
        tvComment.text = MCLocalization.string(forKey: "HINTCOMMENT")
        tvComment.textColor = UIColor.lightGray
        if enableRate == true
        {
            viewRate.isHidden = true
            csHeight.constant = 0
        }
        else
        {
            csHeight.constant = 40
            viewRate.isHidden = false
        }
        self.btnComment.isEnabled = false
       // self.btnComment.isSelected = true
        self.view.layoutIfNeeded()
    }
    override func viewWillAppear(_ animated: Bool) {
        makeTopNavigationSearchbar(isMenuScreen: false,isCartScreen: false,needShake: false)
    }
    @IBAction func btnConfirm (_ sender: UIButton)
    {
        DataConnect.rateAndComment(token_API, country_code: kCountryCode, phone: userPhone_API, id_product: id_product!, star: Int(viewRate.rating), comment: tvComment.text, view: self.view, onsuccess: { (result) in
            self.dissmiss()
        }) { (error) in
            showErrorMessage(error: error as! Int, vc: self)
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = MCLocalization.string(forKey: "HINTCOMMENT")
            textView.textColor = UIColor.lightGray
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        if tvComment.text.replacingOccurrences(of: " ", with: "").length == 0 {
            self.btnComment.isEnabled = false
            //self.btnComment.isSelected = true
        }
        else{
            self.btnComment.isEnabled = true
           // self.btnComment.isSelected = false
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
