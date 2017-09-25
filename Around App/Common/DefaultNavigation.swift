//
//  DefaultNavigation.swift
//  Around App
//
//  Created by phuc.huynh on 8/4/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import UIKit

class DefaultNavigation: UINavigationBar {
    @IBInspectable var imageTitle: UIImage? = nil {
        
        didSet {
            guard let imageTitle = imageTitle else {
                
                topItem?.titleView = nil
                
                return
            }
            
            let imageView = UIImageView(image: imageTitle)
            //imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            imageView.contentMode = .scaleAspectFit
            
            topItem?.titleView = imageView
        }
    }
    func setTransparent()
    {
        self.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        let colors =  [UIColor(hex: "#fc8301").cgColor, UIColor(hex: "#f7bf00").cgColor]
        let startPoint = CGPoint(x: 0.0, y: 0.5)
        let endPoint = CGPoint(x: 1.0, y: 0.5)
        var bounds : CGRect?
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS
        {
            bounds = CGRect(x: 0, y: 0, width: 320, height: 64)
        }
        else if DeviceType.IS_IPHONE_6
        {
            bounds = CGRect(x: 0, y: 0, width: 375, height: 64)
        }
        else if DeviceType.IS_IPHONE_6P
        {
            bounds = CGRect(x: 0, y: 0, width: 414, height: 64)
        }
        let image = setGradian(bounds: bounds! , colors: colors, startPoint: startPoint, endPoint: endPoint)
        self.setBackgroundImage(image, for: UIBarMetrics.default)
        self.titleTextAttributes = [NSFontAttributeName: UIFont(name: "OpenSans-Light", size: 17)!, NSForegroundColorAttributeName : UIColor.white]
        
      

        
    }
}
class ProfileNavigation: UINavigationBar {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
        self.titleTextAttributes = [NSFontAttributeName: UIFont(name: "OpenSans-Light", size: 17)!, NSForegroundColorAttributeName : UIColor.white]
    }
}
