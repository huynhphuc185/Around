//
//  InsetLabelWithBottomLine.swift
//  Around
//
//  Created by phuc.huynh on 10/4/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

class InsetLabelWithBottomLine: UILabel {
    let topInset = CGFloat(12.0), bottomInset = CGFloat(12.0), leftInset = CGFloat(12.0), rightInset = CGFloat(12.0)
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        useUnderline()

    }
    required override init(frame: CGRect) {
        super.init(frame: frame)
        useUnderline()

    }
    
    func useUnderline() {
        self.textColor = UIColor(hex: colorXamNhat)
        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        border.borderColor = UIColor.orange.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - borderWidth, width: 500, height: self.frame.size.height)
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    override func drawText(in rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override var intrinsicContentSize : CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
    
}
