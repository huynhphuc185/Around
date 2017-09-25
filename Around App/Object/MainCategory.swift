import Foundation
class MainCategory: NSObject {
    var id : Int?
    var name : String?
    var image: String?
    var vn_name : String?
    var vn_image: String?
    var sort_order: Int?
     var type: String?
    func parseDataFromDictionary(_ jsonDic : NSDictionary )->MainCategory
    {
        let obj = MainCategory()
        obj.id = jsonDic["id"] as? Int
        obj.name = jsonDic["name"] as? String
        obj.image = jsonDic["image"] as? String
        obj.vn_name = jsonDic["vn_name"] as? String
        obj.vn_image = jsonDic["vn_image"] as? String
         obj.type = jsonDic["type"] as? String
        obj.sort_order = jsonDic["sort_order"] as? Int
        return obj
        
    }

}
