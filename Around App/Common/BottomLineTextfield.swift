//
//  BottomLineTextfield.swift
//  Around App
//
//  Created by phuc.huynh on 8/4/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import UIKit

class BottomLineTextfield: UITextField {
    var callback : callBack?
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.textColor = UIColor(hex: colorXam)
    }

    @IBInspectable var paddingLeft: CGFloat = 0
    @IBInspectable var paddingRight: CGFloat = 0
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + paddingLeft, y: bounds.origin.y, width: bounds.size.width - paddingLeft - paddingRight, height: bounds.size.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    

    func useUnderline() {
        self.layoutIfNeeded()
        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        border.borderColor = UIColor(hex: colorXamNhat).cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - borderWidth, width: 500, height: self.frame.size.height)
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    func settextColor(color: UIColor)
    {
        self.textColor = color
    }
    func useUnderlineWithColor(color: UIColor) {
        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        border.borderColor = color.cgColor
        
        border.frame = CGRect(x: 0, y: self.frame.size.height - borderWidth, width: 500, height: self.frame.size.height)
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
