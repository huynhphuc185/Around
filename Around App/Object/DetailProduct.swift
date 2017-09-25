import Foundation
import ObjectMapper
class Attributes : NSObject,JSONSerializable
{
       var id_attribute:String?
        var id_data: String?
}

class Attribute : Mappable{
    var id_attribute: String?
    var data : [DataAtribute]?
    var name_attribute : String?
    var vn_name_attribute : String?
    required init?(map: Map) {
        
        
    }
    func mapping(map: Map) {
        id_attribute    <- map["id_attribute"]
        data         <- map["data"]
        name_attribute         <- map["name_attribute"]
        vn_name_attribute         <- map["vn_name_attribute"]
    }
}
class DataAtribute : Mappable{
    var id_data: String?
     var name_data: String?
    required init?(map: Map) {


    }
    func mapping(map: Map)
    {
        id_data    <- map["id_data"]
        name_data         <- map["name_data"]
    }

}
class Comments : Mappable{
    var user_name: String?
    var user_avatar: String?
    var comment: String?
    var time: String?
    required init?(map: Map) {
        
        
    }
    func mapping(map: Map) {
        user_name    <- map["user_name"]
        user_avatar         <- map["user_avatar"]
        comment    <- map["comment"]
        time         <- map["time"]
    }
}
class TotalComments : Mappable
{
    var comments: [Comments]?
    required init?(map: Map) {
        
        
    }
    func mapping(map: Map) {
        comments    <- map["comments"]
    }

}
class ImageProduct : Mappable{
    var url: String?
    required init?(map: Map) {
        
        
    }
    func mapping(map: Map) {
        url    <- map["url"]
    }
}

class Reason : Mappable{
    var id: Int?
    var name: String?
    var vn_name : String?
    required init?(map: Map) {
        
        
    }
    func mapping(map: Map) {
        id    <- map["id"]
        name    <- map["name"]
        vn_name    <- map["vn_name"]
    }
}
class RatingReason : Mappable
{
    var reasons: [Reason]?
    required init?(map: Map) {
        
        
    }
    func mapping(map: Map) {
        reasons    <- map["reasons"]
    }
    
}

class TextPolicy : Mappable
{
    var title: String?
    var vn_title: String?
    required init?(map: Map) {
        
        
    }
    func mapping(map: Map) {
        title    <- map["title"]
        vn_title    <- map["vn_title"]
    }
    
}

class ImagePolicy : Mappable
{
    var image: String?
    var vn_image:String?
    required init?(map: Map) {
        
        
    }
    func mapping(map: Map) {
        image    <- map["image"]
        vn_image    <- map["vn_image"]
    }
    
}

class DetailProduct: Mappable {
    var id : Int?
    var name : String?
    var price : Int?
    var old_price : Int?
    var rating: Int?
    var is_rate: Bool?
    var description_: String?
    var shop_name: String?
    var shop_address: String?
    var images: [ImageProduct]?
    var attributes :[Attribute]?
    var total_like : Double?
    var total_comment : Double?
    var is_like : Bool?
    var comments : [Comments]?
    var total_rating : Int?
    var save_price: Int?
    var save_percent : Int?
    var text_policy: TextPolicy?
    var image_policy : [ImagePolicy]?
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        id    <- map["id"]
        name         <- map["name"]
        price      <- map["price"]
        old_price       <- map["old_price"]
        rating       <- map["rating"]
        is_rate       <- map["is_rate"]
        description_  <- map["description"]
        shop_name  <- map["shop_name"]
        shop_address     <- map["shop_address"]
        images     <- map["images"]
        attributes     <- map["attributes"]
        total_like     <- map["total_like"]
        total_comment     <- map["total_comment"]
        is_like     <- map["is_like"]
        comments     <- map["comments"]
        
        total_rating     <- map["total_rating"]
        save_price     <- map["save_price"]
        save_percent     <- map["save_percent"]
        text_policy     <- map["text_policy"]
        image_policy     <- map["image_policy"]
    }

    
    
    
    
    
}


