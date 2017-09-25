import Foundation
class Cart: NSObject {
    var product : [Product] = []
    var locations : [GiftingLocation] = []
    var deliveryTime = DeliveryTime()
    var item_cost : Int?
    var service_fee: Int?
    var shipping_fee: Int?
    var total: Int?
    var payment_type: String?
    var is_gift: Int?
    
    var recipent_name:String?
    var recipent_phone :String?
    var recipent_note :String?

    func parseDataFromDictionary(_ jsonDic : NSDictionary )->Cart
    {
        let obj = Cart()
        obj.item_cost = jsonDic["item_cost"] as? Int
        obj.service_fee = jsonDic["service_fee"] as? Int
        obj.shipping_fee = jsonDic["shipping_fee"] as? Int
        obj.total = jsonDic["total"] as? Int
        obj.payment_type = jsonDic["payment_type"] as? String
        obj.is_gift = jsonDic["is_gift"] as? Int
        
        obj.recipent_name = jsonDic["recipent_name"] as? String
        obj.recipent_phone = jsonDic["recipent_phone"] as? String
        obj.recipent_note = jsonDic["recipent_note"] as? String
        let data = jsonDic.value(forKey:"product") as? NSArray
        if data != nil
        {
            for (_, item) in data!.enumerated()
            {
                let dic = item as? NSDictionary
                obj.product.append(Product().parseDataFromDictionary(dic!))
            }
        }
        
        let locationsArray = jsonDic.value(forKey:"locations") as? NSArray
        if locationsArray != nil
        {
            for (_, item) in locationsArray!.enumerated()
            {
                let dic = item as? NSDictionary
                obj.locations.append(GiftingLocation().parseDataFromDictionary(dic!))
            }
        }
        

        obj.deliveryTime.delivery_day = jsonDic["delivery_day"] as? Int
        obj.deliveryTime.delivery_month = jsonDic["delivery_month"] as? Int
        obj.deliveryTime.delivery_year = jsonDic["delivery_year"] as? Int
        
        return obj
        
    }
    
}

class DeliveryTime : NSObject
{
    var delivery_day : Int?
    var delivery_month :Int?
    var delivery_year : Int?
    func parseDataFromDictionary(_ jsonDic : NSDictionary )->DeliveryTime
    {
        let obj = DeliveryTime()
        obj.delivery_day = jsonDic["delivery_day"] as? Int
        obj.delivery_month = jsonDic["delivery_month"] as? Int
        obj.delivery_year = jsonDic["delivery_year"] as? Int
        return obj
    }
}



class PaymentNganLuong : NSObject
{
    var payment_name : String?
    var payment_code :String?
    var payment_data : [Bank] = []
    func parseDataFromDictionary(_ jsonDic : NSDictionary )->PaymentNganLuong
    {
        let obj = PaymentNganLuong()
        obj.payment_name = jsonDic["payment_name"] as? String
        obj.payment_code = jsonDic["payment_code"] as? String
        let arr = jsonDic.value(forKey:"payment_data") as? NSArray
        if arr != nil
        {
            for (_, item) in arr!.enumerated()
            {
                let dic = item as? NSDictionary
                obj.payment_data.append(Bank().parseDataFromDictionary(dic!))
            }
        }

        
        return obj
    }
}

class Bank : NSObject
{
    var bank_name : String?
    var bank_code = ""
    var bank_image : String?
    func parseDataFromDictionary(_ jsonDic : NSDictionary )->Bank
    {
        let obj = Bank()
        obj.bank_name = jsonDic["bank_name"] as? String
        obj.bank_code = jsonDic["bank_code"] as! String
        obj.bank_image = jsonDic["bank_image"] as? String
        return obj
    }
}


class Time : NSObject
{
    var minute = 0
    var hour  = 0
    var day  = 0
    var month = 0
    var year = 0
}

