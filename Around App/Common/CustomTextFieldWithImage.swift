
import UIKit

class CustomTextFieldWithImage: UITextField {
    var callback : callBack?
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
   
        
    }
    @IBInspectable var paddingLeft: CGFloat = 0
    @IBInspectable var paddingRight: CGFloat = 0
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + paddingLeft, y: bounds.origin.y, width: bounds.size.width - paddingLeft - paddingRight, height: bounds.size.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    func insertRightButtonWithImage(image: UIImage, size: CGSize ,_callback : @escaping callBack )
    {
        callback = _callback
        self.rightViewMode = .always
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        btn.setImage(image, for: .normal)
        btn.addTarget(self, action: #selector(btnCallBlock), for: .touchUpInside)
        self.rightView = btn
    }

    
    func btnCallBlock()
    {
        callback!(nil)
    }
}
