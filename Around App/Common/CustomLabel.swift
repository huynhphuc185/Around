//
//  CustomLabel.swift
//  Around App
//
//  Created by phuc.huynh on 8/5/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.textColor = UIColor(hex: colorXamNhat)

    }
}

class PaddingLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 5.0
    @IBInspectable var rightInset: CGFloat = 5.0
    
    override func drawText(in rect: CGRect) {
        self.textColor = UIColor(hex: colorXamNhat)
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
}
