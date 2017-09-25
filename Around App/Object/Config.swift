//
//  Config.swift
//  Around
//
//  Created by phuc.huynh on 12/12/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import Foundation
import ObjectMapper
class Config : NSObject
{

    var ping_time : Int?
    var request_shipper_timeout : Int?
    var response_shipper_timeout : Int?
    var draw_shipper_position_time_in_journey:Int?
    var draw_shipper_position_time_out_journey:Int?
    var shipper_update_postion_time_in_journey:Int?
    var request_shipper_count: Int?
    var set_schedule_control_time: Int?
    var show_cancel_request_shipper_time: Int?
    var max_delivery_day : Int?
    var min_gifting_payment_cost : Int?
    var min_pickup_payment_cost : Int?
    var imagePrice_TV : String?
    var imagePrice_TA : String?
    
    var imagePrice_ServicePickupTV : String?
    var imagePrice_ServicePickupTA : String?
    var imagePrice_ServiceGiftingTV : String?
    var imagePrice_ServiceGiftingTA : String?
    
    var listPayment : [String]?
    var max_book_order: Int?
    var start_working_hour: Int?
    var end_working_hour : Int?
    var giftbox_fee : String?
    var min_around_pay_payment : Int?
    var max_item_cost_cod : Int?
    var min_item_cost_cod : Int?
    var min_item_cost_purchase: Int?
    var aroundpay : AroundPay?
    var maintenance : Maintenance?
    var update : Update?
    var phoneNumberCallCenter : String?
    var googleKey : String?
    
    class var sharedInstance: Config {
        struct Static {
            static let instance = Config()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
        
    }
    
    
    
}
class ConfigIP : NSObject
{
    var version : Int?
    var restful_ip : String?
    var restful_port : Int?
    
    var smartfox_ip : String?
    var smartfox_port : Int?
    var zone_ = "AroundAppZone"
    var useBlueBox = true
    var httpPort = 8080
    var httpPollSpeed = 750
    class var sharedInstance: ConfigIP {
        struct Static {
            static let instance = ConfigIP()
        }
        return Static.instance
    }
    override init() {
        super.init()
        
    }
}





class DataConfig : Mappable{
    var error: Error?
    var update: Update?
    var maintenance: Maintenance?
    var google_key : GoogleKey?
    var smartfox : ConfigCoundownTime?
    var image: PriceImage?
    var payment :[String]?
    var order: ConfigWaiting?
    var support : Support?
    var aroundpay : AroundPay?
    required init?(map: Map) {
    
    }
    func mapping(map: Map) {
        error    <- map["error"]
        update         <- map["update"]
        maintenance    <- map["maintenance"]
        google_key    <- map["google_key"]
        smartfox    <- map["smartfox"]
        image    <- map["image"]
        payment    <- map["payment"]
        order    <- map["order"]
        support    <- map["support"]
        aroundpay    <- map["aroundpay"]
    }
}

class AroundPay : Mappable{
    var min_around_pay_payment: Int?
    var max_around_pay_payment: Int?
    var prices : [Int]?
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        min_around_pay_payment    <- map["min_around_pay_payment"]
        max_around_pay_payment         <- map["max_around_pay_payment"]
        prices    <- map["prices"]
    }
}



class ConfigCoundownTime : Mappable{
    var ping_time: Int?
    var request_shipper_timeout: Int?
    var response_shipper_timeout: Int?
    var draw_shipper_position_time_in_journey: Int?
    var draw_shipper_position_time_out_journey: Int?
    var shipper_update_postion_time_in_journey: Int?
    var request_shipper_count: Int?
    var set_schedule_control_time: Int?
    var show_cancel_request_shipper_time: Int?
    var max_delivery_day : Int?
    var min_gifting_payment_cost : Int?
    var min_pickup_payment_cost : Int?
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        ping_time    <- map["ping_time"]
        request_shipper_timeout         <- map["request_shipper_timeout"]
        response_shipper_timeout    <- map["response_shipper_timeout"]
        draw_shipper_position_time_in_journey    <- map["draw_shipper_position_time_in_journey"]
        draw_shipper_position_time_out_journey    <- map["draw_shipper_position_time_out_journey"]
        shipper_update_postion_time_in_journey    <- map["shipper_update_postion_time_in_journey"]
        request_shipper_count    <- map["request_shipper_count"]
        set_schedule_control_time    <- map["set_schedule_control_time"]
        show_cancel_request_shipper_time    <- map["show_cancel_request_shipper_time"]
        max_delivery_day    <- map["max_delivery_day"]
        min_gifting_payment_cost    <- map["min_gifting_payment_cost"]
        min_pickup_payment_cost    <- map["min_pickup_payment_cost"]
    }
}


class Error : Mappable{
    var status: Int?
    var version: Int?
    var content: [ContentError]?
    var vn_content: [ContentError]?
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        status    <- map["status"]
        version         <- map["version"]
        content    <- map["content"]
        vn_content    <- map["vn_content"]
    }
}


class Update : Mappable{
    var status: Int?
    var url: String?
    var message: String?
    var vn_message : String?
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        status    <- map["status"]
        url         <- map["url"]
        message    <- map["message"]
        vn_message    <- map["vn_message"]
    }
}

class Maintenance : Mappable{
    var status: Int?
    var message: String?
    var vn_message : String?
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        status    <- map["status"]
        message    <- map["message"]
        vn_message    <- map["vn_message"]
    }
}

class ContentError : Mappable{
    var id: Int?
    var description: String?
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        id    <- map["id"]
        description         <- map["description"]
    }
}

class GoogleKey : Mappable{
    var ios_key: String?
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        ios_key         <- map["ios_key"]
    }
}

class PriceImage : Mappable{
    
    var popup_pickup_service_fee_vn : String?
    var popup_pickup_service_fee_en : String?
    var popup_gifting_service_fee_vn : String?
    var popup_gifting_service_fee_en : String?
    var popup_price_en: String?
    var popup_price_vn : String?
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        popup_price_en         <- map["popup_price_en"]
        popup_price_vn         <- map["popup_price_vn"]
        
        popup_pickup_service_fee_vn         <- map["popup_pickup_service_fee_vn"]
        popup_pickup_service_fee_en         <- map["popup_pickup_service_fee_en"]
        popup_gifting_service_fee_vn         <- map["popup_gifting_service_fee_vn"]
        popup_gifting_service_fee_en         <- map["popup_gifting_service_fee_en"]
    }
}
class ConfigWaiting : Mappable{
    var max_book_order: Int?
    var start_working_hour: Int?
    var end_working_hour : Int?
    var giftbox_fee : String?
    var min_around_pay_payment : Int?
    var max_item_cost_cod : Int?
    var min_item_cost_cod: Int?
    var min_item_cost_purchase : Int?
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        max_book_order         <- map["max_book_order"]
        start_working_hour         <- map["start_working_hour"]
        end_working_hour         <- map["end_working_hour"]
        giftbox_fee         <- map["giftbox_fee"]
        min_around_pay_payment         <- map["min_around_pay_payment"]
        max_item_cost_cod         <- map["max_item_cost_cod"]
        min_item_cost_purchase         <- map["min_item_cost_purchase"]
         min_item_cost_cod         <- map["min_item_cost_cod"]
        
        
    }
}


class Support : Mappable{
    var customer_service_phone: String?
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        customer_service_phone         <- map["customer_service_phone"]
    }
}

