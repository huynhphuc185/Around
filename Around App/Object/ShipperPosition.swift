import Foundation
import ObjectMapper
class ShipperPosition: Mappable {
    var shipper_latitude : Double?
    var shipper_longitude : Double?
    var shipper_description: String?
    
    init()
    {
        
    }
    required init?(map: Map) {
        
        
    }
    func mapping(map: Map) {
        shipper_latitude    <- map["latitude"]
        shipper_longitude         <- map["longitude"]
        shipper_description    <- map["shipper_description"]
    }
    
    func parseDataFromObject (_ sfObj:SFSObject)->ShipperPosition
    {
        self.shipper_latitude = Double(sfObj.getDouble("shipper_latitude"))
        self.shipper_longitude = Double(sfObj.getDouble("shipper_longitude"))
        self.shipper_description = sfObj.getUtfString("shipper_description")
        return self
        
    }
}


class ListShipperPosition : Mappable{
    var positions : [ShipperPosition]?
    
    init()
    {
        
    }
    required init?(map: Map) {
        
        
    }
    func mapping(map: Map) {
        positions    <- map["positions"]
    }

}
