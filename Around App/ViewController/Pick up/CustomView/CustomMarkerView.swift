import UIKit

class CustomMarkerView: UIView {
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    class func instanceFromNib() -> CustomMarkerView {
        return UINib(nibName: "CustomMarkerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomMarkerView
    }
    func prepareView(number:String, address: String)
    {
        self.lblNumber.text = number
        self.lblAddress.text = address
    }
}
