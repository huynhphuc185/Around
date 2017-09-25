import ObjectMapper
class PointLocation: Mappable
{
    var id: Int?
    var role: Int?
    var placeid: String?
    var address:String = ""
    var ispickup: Bool?
    var ispay: Bool?
    var distance = 0.0
    var duration = 0.0
    var longitude: Double?
    var latitude: Double?
    var item_name = ""
    var item_cost = 0
    var recipent_name = ""
    var note = ""
    var phone = ""
    var status: Int?
    var pickup_type = 0
    required init?(map: Map) {
        if let _role = map.JSON["role"] as? Int
        {
            self.role = _role
        }
        if let _ispay = map.JSON["ispay"] as? Bool
        {
            self.ispay = _ispay
        }
        if let _ispickup = map.JSON["ispickup"] as? Bool
        {
            self.ispickup = _ispickup
        }
    }
    
    
    
    func mapping(map: Map) {
        id    <- map["id"]
        role    <- map["role"]
        placeid    <- map["placeid"]
        address    <- map["address"]
        ispickup    <- map["ispickup"]
        ispay    <- map["ispay"]
        distance    <- map["distance"]
        duration    <- map["duration"]
        longitude    <- map["longitude"]
        latitude    <- map["latitude"]
        item_name    <- map["item_name"]
        item_cost    <- map["item_cost"]
        recipent_name    <- map["recipent_name"]
        note    <- map["note"]
        phone    <- map["phone"]
        status    <- map["status"]
        pickup_type    <- map["pickup_type"]
    }
    
    
    
}

class GiftingLocation: NSObject,JSONSerializable
{
    var longitude: Double?
    var latitude: Double?
    var address = ""
    var placeid: String?
    convenience init(longitude : Double,latitude: Double, address: String, placeid: String) {
        self.init()
        self.longitude = longitude
        self.latitude = latitude
        self.address = address
        self.placeid = placeid
    }
    func parseDataFromDictionary(_ jsonDic : NSDictionary )->GiftingLocation
    {
        let obj = GiftingLocation()
        obj.longitude = jsonDic["longitude"] as? Double
        obj.latitude = jsonDic["latitude"] as? Double
        obj.address = jsonDic["address"] as! String
        obj.placeid = jsonDic["placeid"] as? String
        return obj
        
    }
    
}
