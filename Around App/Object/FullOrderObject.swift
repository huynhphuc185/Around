import ObjectMapper


class CheckOrderStatusObject: Mappable {
    var status : Int?
    var order_code: String?
    
    
    required init?(map: Map) {
        
        
    }
    func mapping(map: Map) {
        status    <- map["status"]
        order_code         <- map["order_code"]
       
    }

}

class PaymentURL: Mappable {
    var trans_ref : String?
    var url: String?
    
    
    required init?(map: Map) {
        
        
    }
    func mapping(map: Map) {
        trans_ref    <- map["trans_ref"]
        url         <- map["url"]
        
    }
    
}
class FullOrder : Mappable{
    var locations: [FullOrderLocation] = []
    var return_to_pickup: Bool?
    var payment_type: String?
    var is_gift: Bool?
    var delivery_minute: Int?
    var delivery_hour: Int?
    var delivery_day: Int?
    var delivery_month: Int?
    var delivery_year: Int?
    var allow_change_payment: Bool?
    var show_gift: Bool?
    var distance: Double?
    var duration: Double?
    var shipping_fee: Int?
    var service_fee: Int?
    var return_to_pickup_fee: Bool?
    var item_cost: Int?
    var total: Int?
    var order_code :String?
    var verify_code :String?
    required init?(map: Map) {
        
        
    }
    func mapping(map: Map) {
        locations    <- map["locations"]
        return_to_pickup         <- map["return_to_pickup"]
        payment_type    <- map["payment_type"]
        is_gift         <- map["is_gift"]
        delivery_minute    <- map["delivery_minute"]
        delivery_hour         <- map["delivery_hour"]
        delivery_day    <- map["delivery_day"]
        delivery_month         <- map["delivery_month"]
        delivery_year    <- map["delivery_year"]
        allow_change_payment         <- map["allow_change_payment"]
        show_gift    <- map["show_gift"]
        
        distance         <- map["distance"]
        duration    <- map["duration"]
        shipping_fee         <- map["shipping_fee"]
        service_fee    <- map["service_fee"]
        return_to_pickup_fee         <- map["return_to_pickup_fee"]
        item_cost    <- map["item_cost"]
        total    <- map["total"]
        order_code    <- map["order_code"]
        verify_code    <- map["verify_code"]
    }
}


class LocationItem : Mappable{
    var indexItemname: Int?
    var item_name: String?
    var recipent_name: String?
    var item_cost: Int?
    var note: String?
    var phone: String?
    var is_gift: Bool?
    var item_quantity: Int?
    var item_image: String?
    
    required init?(map: Map) {
        
        
    }
    func mapping(map: Map) {
        item_name    <- map["item_name"]
        item_cost         <- map["item_cost"]
        note    <- map["note"]
        phone         <- map["phone"]
        is_gift         <- map["is_gift"]
        recipent_name         <- map["recipent_name"]
        item_quantity         <- map["item_quantity"]
        item_image         <- map["item_image"]

    }
}


class FullOrderLocation : Mappable{
    var role: Int?
    var address: String?
    var item_name : String?
    var item_cost : Int?
    var recipent_name : String?
    var note: String?
    var phone: String?
    var location_items :[LocationItem]?
    var pickup_type :Int?
    required init?(map: Map) {
        
        
    }
    func mapping(map: Map) {
        role    <- map["role"]
        address         <- map["address"]
        item_name         <- map["item_name"]
        item_cost         <- map["item_cost"]
        recipent_name         <- map["recipent_name"]
        note    <- map["note"]
        phone         <- map["phone"]
        location_items         <- map["location_items"]
        pickup_type         <- map["pickup_type"]
    }
}


class FullOrderContent: NSObject
{
    var return_to_pickup: Bool?
    var payment_type: String?
    var is_gift: Bool?
    var delivery_minute:Int?
    var delivery_hour: Int?
    var delivery_day: Int?
    var delivery_month: Int?
    var delivery_year: Int?
    var show_gift: Bool?
    var allow_change_payment :Bool?
    func parseDataFromDictionary(_ jsonDic : NSDictionary )->FullOrderContent
    {
        let obj = FullOrderContent()
        obj.return_to_pickup = jsonDic["return_to_pickup"] as? Bool
        obj.payment_type = jsonDic["payment_type"] as? String
        obj.is_gift = jsonDic["is_gift"] as? Bool
        obj.delivery_minute = jsonDic["delivery_minute"] as? Int
        obj.delivery_hour = jsonDic["delivery_hour"] as? Int
        obj.delivery_month = jsonDic["delivery_month"] as? Int
        obj.delivery_year = jsonDic["delivery_year"] as? Int
        obj.show_gift = jsonDic["show_gift"] as? Bool
        obj.allow_change_payment = jsonDic["allow_change_payment"] as? Bool
        return obj
        
    }
    
}


class NotificationObject: Mappable {
    var id : Int?
    var title: String?
    var description:String?
    var vn_description: String?
    var is_read: Bool?
    var time: String?
    
    required init?(map: Map) {
        
        
    }
    func mapping(map: Map) {
        id    <- map["id"]
        title         <- map["title"]
        description    <- map["description"]
        time    <- map["time"]
        vn_description    <- map["vn_description"]
        is_read    <- map["is_read"]
}
    
}
class ListNotificationObject: Mappable {
    var data : [NotificationObject]?
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        data    <- map["data"]
    }
    
}



class EventObject: Mappable {
    var id : Int?
    var image: String?
    var type:Int?
    var time: String?
     var id_content: Int?
    required init?(map: Map) {
        
        
    }
    func mapping(map: Map) {
        id    <- map["id"]
        image         <- map["image"]
        type    <- map["type"]
        time    <- map["time"]
        id_content    <- map["id_content"]
    }
    
}
class ListEventObject: Mappable {
    var data : [EventObject]?
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        data    <- map["data"]
    }
    
}

class ListBanner: Mappable {
    var data : [BannerObject]?
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        data    <- map["data"]
    }
    
}

class NotificationDetail: Mappable {
    var detail : String?
    var vn_detail : String?
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        detail    <- map["detail"]
        vn_detail    <- map["vn_detail"]
    }
    
}


class BannerDetail: Mappable {
    var data : BannerObject?
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        data    <- map["data"]
    }
    
}



class BannerObject: Mappable {
    var id : Int?
    var title: String?
    var vn_title:String?
    var type: Int?
    var show_number : Int?
    var start_date:String?
    var end_date:String?
    var contents:[ContentObject]?
    required init?(map: Map) {
        
        
    }
    func mapping(map: Map) {
        id    <- map["id"]
        title         <- map["title"]
        vn_title    <- map["vn_title"]
        type    <- map["type"]
        show_number    <- map["show_number"]
        start_date    <- map["start_date"]
        end_date    <- map["end_date"]
        contents         <- map["contents"]
    }
    
}


class ContentObject: Mappable {
    var title : String?
    var vn_title: String?
    var start_date:String?
    var end_date: String?
    var image:String?
    var vn_image:String?
    var description:String?
    var vn_description:String?
    var product:BannerProductObject?
    var id_notification: Int?
    required init?(map: Map) {
        
        
    }
    func mapping(map: Map) {
        title    <- map["title"]
        vn_title         <- map["vn_title"]
        start_date    <- map["start_date"]
        end_date    <- map["end_date"]
        image    <- map["image"]
        vn_image    <- map["vn_image"]
        description         <- map["description"]
        vn_description    <- map["vn_description"]
        product    <- map["product"]
        id_notification    <- map["id_notification"]
    }
    
}


class BannerProductObject: Mappable {
    var id : Int?
    var name: String?
    var price:Int?
    var old_price: Int?
    var save_percent:Int?
    var image:String?
    required init?(map: Map) {
        
        
    }
    func mapping(map: Map) {
        id    <- map["id"]
        name         <- map["name"]
        price    <- map["price"]
        old_price    <- map["old_price"]
        save_percent    <- map["save_percent"]
        image    <- map["image"]
    }
    
}
