//
//  ShipperInfoObject.swift
//  Around
//
//  Created by phuc.huynh on 10/14/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import Foundation
class ShipperInfoObject: NSObject,JSONSerializable
{
    var shipper_latitude: Double?
    var shipper_longitude: Double?
    var shipper_status : Int?
    var shipper_fullname : String?
    var shipper_phone: String?
    var shipper_rating : Int?
    var shipper_name : String?
    var shipper_country_code : String?
    var shipper_avatar : String?
    var duration = 0.0
    var new_chat_number : Int?
    func parseDataFromObject (_ sfObj:SFSObject)->ShipperInfoObject
    {
        self.shipper_latitude = Double(sfObj.getDouble("shipper_latitude"))
        self.shipper_longitude = Double(sfObj.getDouble("shipper_longitude"))
        self.shipper_status = sfObj.getInt("shipper_status") as Int
        self.shipper_fullname = sfObj.getUtfString("shipper_fullname") as String
        self.shipper_phone = sfObj.getUtfString("shipper_phone") as String
        self.shipper_rating = sfObj.getInt("shipper_rating") as Int
        self.shipper_name = sfObj.getUtfString("shipper_name") as String
        self.shipper_country_code = sfObj.getUtfString("shipper_country_code") as String
        self.shipper_avatar = sfObj.getUtfString("shipper_avatar") as String
        self.duration = sfObj.getDouble("duration") as! Double
        self.new_chat_number = sfObj.getInt("new_chat_number") as Int
        return self
        
    }
    
}
class ResponseShipper : NSObject
{
    var shipper : ShipperInfoObject?
    var listLocation:[PointLocation] = []
    var is_payment: Bool?
    var order_id: Int?
}


class RequestShipper : NSObject
{
    var code : Int?
    var distance : Double?
    var duration: Double?
    var is_follow_journey: Bool?
    var shipper_name: String?
    var shipper_avatar: String?
    var is_set_schedule_time: Bool?
    var set_schedule_time: String?
    var is_online_payment: Bool?
    var online_payment_order_id: Int?
    var is_max_process: Bool?
    var is_not_enough_aroundpay:Bool?
    
    func parseDataFromObject (_ sfObj:SFSObject)->RequestShipper
    {
        self.code = sfObj.getInt("code")
        self.distance = Double(sfObj.getDouble("distance"))
        self.duration = Double(sfObj.getDouble("duration"))
        self.is_follow_journey = sfObj.getBool("is_follow_journey")
        self.shipper_name = sfObj.getUtfString("shipper_name")
        self.shipper_avatar = sfObj.getUtfString("shipper_avatar")
        self.is_set_schedule_time = sfObj.getBool("is_set_schedule_time")
        self.set_schedule_time = sfObj.getUtfString("set_schedule_time")
        self.is_online_payment = sfObj.getBool("is_online_payment")
        self.is_max_process = sfObj.getBool("is_max_process")
        self.online_payment_order_id = sfObj.getInt("online_payment_order_id")
        self.is_not_enough_aroundpay = sfObj.getBool("is_not_enough_aroundpay")
        return self
        
    }
}

class ResponseShipperError : NSObject
{
    var code : Int?
    var set_schedule_time: String?
    var is_set_schedule_time : Bool?
    var is_show_follow_list_screen : Bool?
}
