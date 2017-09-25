//
//  HistoryObject.swift
//  Around
//
//  Created by phuc.huynh on 11/23/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//
import CoreLocation
import ObjectMapper
class HistoryObject: Mappable {

    var id : Int?
    var order_code: String?
    var distance :Double?
    var total:Int?
    var start: CLLocationCoordinate2D?
    var end: CLLocationDegrees?
    var duration : Double?
    var payment_type: String?
    var status: Int?
    var is_payment: Bool?
    var create_date: String?
    var order_type: [Int]?
    var locations:[PointLocation]?
    var strPickupType : String?
    var type : String?
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        id    <- map["id"]
        order_code         <- map["order_code"]
        payment_type    <- map["payment_type"]
        distance         <- map["distance"]
        total    <- map["total"]
        start         <- map["start"]
        end    <- map["end"]
        duration         <- map["duration"]
        payment_type    <- map["payment_type"]
        status         <- map["status"]
        is_payment    <- map["is_payment"]
        create_date         <- map["create_date"]
        order_type    <- map["order_type"]
        locations    <- map["locations"]
        type    <- map["type"]
    }

}
class ListHistoryObject: Mappable {
    
    var data : [HistoryObject]?
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        data    <- map["data"]
    }
    
}

class NumberLeftMenu: Mappable {
    
    var number_order : Int?
    var number_notification : Int?
    var number_event : Int?
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        number_order    <- map["number_order"]
        number_notification         <- map["number_notification"]
        number_event    <- map["number_event"]
    }
    
}

