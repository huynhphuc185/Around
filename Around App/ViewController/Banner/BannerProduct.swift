/*
 The MIT License (MIT)
 
 Copyright (c) 2015-present Badoo Trading Limited.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

import UIKit

class BannerProduct: UIView {
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "BannerProduct", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    @IBOutlet weak var lblNameProduct: UILabel!
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPriceSale: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lbldate: UILabel!
    @IBOutlet weak var btnMuaNgay: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSafeOff: UILabel!
    @IBOutlet weak var viewSaleOff : UIView!
    @IBOutlet weak var lblgiamgia : UILabel!
    @IBOutlet weak var contrainsHeightTietKiem : NSLayoutConstraint?
}
