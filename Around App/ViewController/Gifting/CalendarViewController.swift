//
//  CalendarViewController.swift
//  Around
//
//  Created by phuc.huynh on 7/25/17.
//  Copyright © 2017 phuc.huynh. All rights reserved.
//

import UIKit

class CalendarViewController: StatusbarViewController {
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var maindatePicker: UIDatePicker!
    @IBOutlet weak var viewClose: UIView!
    var blockCallBack : callBack?
    var dateChoose : Time?
    override func viewDidLoad() {
        super.viewDidLoad()
        maindatePicker.addTarget(self, action: #selector(self.datePickerValueChanged), for: .valueChanged)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.closeView))
        self.viewClose.addGestureRecognizer(gesture)
        if dateChoose?.day == 0{
            let currentTime = Time()
            currentTime.year = Calendar.current.component(.year, from: Date())
            currentTime.month = Calendar.current.component(.month, from: Date())
            currentTime.day = Calendar.current.component(.day, from: Date())
            currentTime.minute = Calendar.current.component(.minute, from: Date())
            currentTime.hour = Calendar.current.component(.hour, from: Date())
            lblTime.text = setCurrentDayString(date: currentTime,needSet90Phut: true)
        }
        else
        {
            lblTime.text = setCurrentDayString(date: dateChoose!,needSet90Phut: false)
        }
        maindatePicker.minimumDate = Date()
        maindatePicker.maximumDate = Calendar.current.date(byAdding: .day, value: Config.sharedInstance.max_delivery_day! - 1, to: Date())
        if MCLocalization.sharedInstance().language == "vi"
        {
            maindatePicker.locale = Locale(identifier: "vi_VN")
        }
        else{
            maindatePicker.locale = Locale(identifier: "en_US")
        }
    }

    func setCurrentDayString(date:Time,needSet90Phut : Bool) -> String{
        if needSet90Phut
        {
            let mins15304500 :Int?
            if date.minute <= 15
            {
                mins15304500 = 15
            }
            else if date.minute <= 30
            {
                mins15304500 = 30
            }
            else if date.minute <= 45
            {
                mins15304500 = 45
            }
            else
            {
                mins15304500 = 60
            }
            let now = Date()
            let miliMore15Mins: Double?
            miliMore15Mins = now.timeIntervalSinceNow + Double((mins15304500! - date.minute)*60)  + 5400
            let date15Mins = Date(timeIntervalSinceNow: miliMore15Mins!)
            
            let newHour =  Calendar.current.component(.hour, from: date15Mins)
            let newMin =  Calendar.current.component(.minute, from: date15Mins)
            
            let currentTimeString = formatTimeWithFormat(min: newMin, hour: newHour, formatString: "h:mm a")
            let currentDateString = formatDateWithFormat(day: date.day, month: date.month, year: date.year, formatString: "dd/MM/yyyy")
            let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)
            let components = NSDateComponents()
            components.year = date.year
            components.month = date.month
            components.day = date.day
            components.minute = newMin
            components.hour = newHour
            maindatePicker.setDate((calendar?.date(from: components as DateComponents))!, animated: true)
            
            return currentTimeString + " " + currentDateString
        }
        else
        {
            let currentTimeString = formatTimeWithFormat(min: date.minute, hour: date.hour, formatString: "h:mm a")
            let currentDateString = formatDateWithFormat(day: date.day, month: date.month, year: date.year, formatString: "dd/MM/yyyy")
            
            let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)
            let components = NSDateComponents()
            components.year = date.year
            components.month = date.month
            components.day = date.day
            components.minute = date.minute
            components.hour = date.hour
            maindatePicker.setDate((calendar?.date(from: components as DateComponents))!, animated: true)
            
            return currentTimeString + " " + currentDateString
        }
        
    }
    func closeView()
    {
        self.dismiss(animated: true, completion: nil)
    }
    func datePickerValueChanged (datePicker: UIDatePicker) {
        self.dateChoose?.year = Calendar.current.component(.year, from: datePicker.date)
        self.dateChoose?.month = Calendar.current.component(.month, from: datePicker.date)
        self.dateChoose?.day = Calendar.current.component(.day, from: datePicker.date)
        self.dateChoose?.minute = Calendar.current.component(.minute, from: datePicker.date)
        self.dateChoose?.hour = Calendar.current.component(.hour, from: datePicker.date)
        lblTime.text = setCurrentDayString(date: self.dateChoose!, needSet90Phut: false)
        
    }
    @IBAction func btnComfirm(_ sender_: UIButton) {
        self.dismiss(animated: true) {
            self.dateChoose?.year = Calendar.current.component(.year, from: self.maindatePicker.date)
            self.dateChoose?.month = Calendar.current.component(.month, from: self.maindatePicker.date)
            self.dateChoose?.day = Calendar.current.component(.day, from: self.maindatePicker.date)
            self.dateChoose?.minute = Calendar.current.component(.minute, from: self.maindatePicker.date)
            self.dateChoose?.hour = Calendar.current.component(.hour, from: self.maindatePicker.date)
            self.blockCallBack!(self.dateChoose as AnyObject)
        }
    }
    
    @IBAction func btnBookNow(_ sender_: UIButton) {
        self.dismiss(animated: true) {
            self.dateChoose = Time()
            self.blockCallBack!(self.dateChoose as AnyObject)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
