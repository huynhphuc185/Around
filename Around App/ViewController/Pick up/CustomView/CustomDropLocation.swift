import UIKit

class CustomDropLocation: UIView {
    @IBOutlet weak var lblAddress: UILabel!
    class func instanceFromNib() -> CustomDropLocation {
        return UINib(nibName: "CustomDropLocation", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomDropLocation
    }
    func prepareView( address: String)
    {
        self.lblAddress.text = address
    }
}
