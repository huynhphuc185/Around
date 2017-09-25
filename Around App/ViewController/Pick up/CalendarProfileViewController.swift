//
//  CalendarViewController.swift
//  Around
//
//  Created by phuc.huynh on 7/25/17.
//  Copyright © 2017 phuc.huynh. All rights reserved.
//

import UIKit

class CalendarProfileViewController: StatusbarViewController {
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var maindatePicker: UIDatePicker!
    @IBOutlet weak var viewClose: UIView!
    var blockCallBack : callBack?
    var birthday : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        maindatePicker.addTarget(self, action: #selector(self.datePickerValueChanged), for: .valueChanged)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.closeView))
        self.viewClose.addGestureRecognizer(gesture)
        let currentDate = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd-MM-yyyy"
        self.maindatePicker.maximumDate = currentDate
        if MCLocalization.sharedInstance().language == "vi"
        {
            maindatePicker.locale = Locale(identifier: "vi_VN")
        }
        else{
            maindatePicker.locale = Locale(identifier: "en_US")
        }

        dateformatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        
        if let date = dateformatter.date(from: birthday!)
        {
             self.maindatePicker.setDate(date, animated: true)
            self.lblTime.text = birthday
        }
        else
        {
            let dateValue = dateformatter.string(from: currentDate)
            self.lblTime.text = dateValue
            
        }
       
        
    }
    func closeView()
    {
        self.dismiss(animated: true, completion: nil)
    }
    func datePickerValueChanged (datePicker: UIDatePicker) {
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd-MM-yyyy"
        let dateValue = dateformatter.string(from: datePicker.date)
        lblTime.text = dateValue
        
    }
    @IBAction func btnComfirm(_ sender_: UIButton) {
        self.dismiss(animated: true) {
            self.blockCallBack!(self.lblTime.text as AnyObject)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
}
