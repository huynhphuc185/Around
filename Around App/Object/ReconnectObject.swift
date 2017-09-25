import Foundation
class ReconnectObject: NSObject {
    var shipper = ShipperInfoObject()
    var locations : [PointLocation] = []
    var room_name:String?
    var distance:Double?
    func parseDataFromSFSObject(_ sfObj : SFSObject )->ReconnectObject
    {
        let listLocation = sfObj.getSFSArray("locations")
        for index in 0...(listLocation?.size())! - 1
        {
            let jSon = listLocation?.getUtfString(index)
          //  let dic:NSDictionary = convertStringToDictionary(item!)! as NSDictionary
            let pointObj = PointLocation(JSONString: jSon!)
            locations.append(pointObj!)
        }
        room_name = sfObj.getUtfString("room_name")
        shipper.shipper_name = sfObj.getUtfString("shipper_name")
        shipper.shipper_country_code = sfObj.getUtfString("shipper_country_code")
        shipper.shipper_phone = sfObj.getUtfString("shipper_phone")
        shipper.shipper_fullname = sfObj.getUtfString("shipper_fullname")
        shipper.shipper_avatar = sfObj.getUtfString("shipper_avatar")
        shipper.shipper_rating = sfObj.getInt("shipper_rating")
        shipper.shipper_latitude = Double(sfObj.getDouble("shipper_latitude"))
        shipper.shipper_longitude = Double(sfObj.getDouble("shipper_longitude"))
        distance = Double(sfObj.getDouble("distance"))
        return self
        
    }
    
}


class FollowJourneyObject: NSObject {
    var shipper = ShipperInfoObject()
    var locations : [PointLocation] = []
    var room_name:String?
    var distance:Double?
    var is_payment : Bool?
    var order_id : Int?
    func parseDataFromSFSObject(_ sfObj : SFSObject )->FollowJourneyObject
    {
        let listLocation = sfObj.getSFSArray("locations")
        for index in 0...(listLocation?.size())! - 1
        {
            let jSon = listLocation?.getUtfString(index)
          //  let dic:NSDictionary = convertStringToDictionary(item!)! as NSDictionary
            let pointObj = PointLocation(JSONString: jSon!)
            locations.append(pointObj!)
        }
        
        is_payment = sfObj.getBool("is_payment")
        order_id = sfObj.getInt("order_id")
        room_name = sfObj.getUtfString("room_name")
        distance = Double(sfObj.getDouble("distance"))
        shipper.shipper_name = sfObj.getUtfString("shipper_name")
        shipper.shipper_country_code = sfObj.getUtfString("shipper_country_code")
        shipper.shipper_phone = sfObj.getUtfString("shipper_phone")
        shipper.shipper_fullname = sfObj.getUtfString("shipper_fullname")
        shipper.shipper_avatar = sfObj.getUtfString("shipper_avatar")
        shipper.shipper_rating = sfObj.getInt("shipper_rating")
        shipper.shipper_latitude = Double(sfObj.getDouble("shipper_latitude"))
        shipper.shipper_longitude = Double(sfObj.getDouble("shipper_longitude"))
        shipper.duration = Double(sfObj.getDouble("duration"))
        
        shipper.new_chat_number = sfObj.getInt("new_chat_number")
        return self
        
    }
    
}

class CheckRequest: NSObject {
    var status : Int?
    func parseDataFromSFSObject(_ sfObj : SFSObject )->CheckRequest
    {

        status = sfObj.getInt("status")
        return self
        
    }
    
}
