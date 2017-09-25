//
//  BottomLineTextfield.swift
//  Around App
//
//  Created by phuc.huynh on 8/4/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import UIKit

class PaddingTextField: UITextField {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
       // useUnderline()

        paddingLeft()
    }
    required override init(frame: CGRect) {
        super.init(frame: frame)
        //useUnderline()
//        self.font = UIFont.systemFontOfSize(self.font!.pointSize)
        paddingLeft()
    }
    
    func paddingLeft()
    {
        self.textColor = UIColor(hex: colorXam)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = UITextFieldViewMode.always
        let borderColor = UIColor(hex: colorXamNhat)
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = 1.0;

        
    }
    func useUnderline() {
        
        if let strPlaceholder = self.placeholder
        {
            self.attributedPlaceholder = NSAttributedString(string:strPlaceholder,
                                                            attributes:[NSForegroundColorAttributeName: UIColor.black])
        }
        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        border.borderColor = UIColor.black.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - borderWidth, width: 500, height: self.frame.size.height)
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
      //  self.borderStyle = .none
    }
}
