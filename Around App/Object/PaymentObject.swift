import Foundation
class PaymentObject: NSObject {
    var payment_type : String?
    func parseDataFromObject (_ sfObj:SFSObject)->PaymentObject
    {
        self.payment_type = sfObj.getUtfString("payment_type")
        return self
        
    }
}
