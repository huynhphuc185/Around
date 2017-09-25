import Foundation
class CategoryItem: NSObject {
    var id : Int?
    var name : String?
    var image: String?
    var vn_name : String?
    var vn_image: String?
    var recommendation: Int?
    var type: String?
    func parseDataFromDictionary(_ jsonDic : NSDictionary )->CategoryItem
    {
        let obj = CategoryItem()
        obj.id = jsonDic["id"] as? Int
        obj.name = jsonDic["name"] as? String
        obj.image = jsonDic["image"] as? String
        obj.vn_name = jsonDic["vn_name"] as? String
        obj.vn_image = jsonDic["vn_image"] as? String
        obj.recommendation = jsonDic["recommendation"] as? Int
        obj.type = jsonDic["type"] as? String
        return obj
        
    }
    
}
class Product: NSObject {
    var id : Int?
    var name : String?
    var image: String?
    var price: Int?
    var rating: Int?
    var shop_name: String?
    var shop_address: String?
    var in_cart: Int?
    var number: Int?
    var is_gift: Int?
    var old_price: Int?
    var save_percent: Int?
    var is_new: Bool?
    func parseDataFromDictionary(_ jsonDic : NSDictionary )->Product
    {
        let obj = Product()
        obj.id = jsonDic["id"] as? Int
        obj.name = jsonDic["name"] as? String
        obj.image = jsonDic["image"] as? String
        obj.price = jsonDic["price"] as? Int
        obj.rating = jsonDic["rating"] as? Int
        obj.shop_name = jsonDic["shop_name"] as? String
        obj.shop_address = jsonDic["shop_address"] as? String
        obj.in_cart = jsonDic["in_cart"] as? Int
        obj.is_gift = jsonDic["is_gift"] as? Int
        obj.old_price = jsonDic["old_price"] as? Int
        obj.save_percent = jsonDic["save_percent"] as? Int
        obj.is_new = jsonDic["is_new"] as? Bool
        if jsonDic["number"] != nil
        {
            obj.number = jsonDic["number"] as? Int
        }
        return obj
        
    }
    
}
