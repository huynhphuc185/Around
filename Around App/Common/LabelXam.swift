//
//  LabelXam.swift
//  Around
//
//  Created by phuc.huynh on 2/28/17.
//  Copyright © 2017 phuc.huynh. All rights reserved.
//

import UIKit

class LabelXam: UILabel {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.textColor = UIColor(hex: colorXam)
        
    }

}


