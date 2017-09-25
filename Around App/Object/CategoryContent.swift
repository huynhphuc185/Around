import Foundation
class CategoryContent: NSObject {
    var type : String?
    var listProduct : [Product] = []
    var listCategory : [CategoryItem] = []
    func parseDataFromDictionary(_ jsonDic : NSDictionary )->CategoryContent
    {
        let obj = CategoryContent()
        obj.type = jsonDic["type"] as? String
        if obj.type == "category"
        {
            let data = jsonDic.value(forKey:"data") as! NSArray
            for (_, item) in data.enumerated()
            {
                let dic = item as? NSDictionary
                obj.listCategory.append(CategoryItem().parseDataFromDictionary(dic!))
                
            }
        }
        else if obj.type == "product"
        {
            let data = jsonDic.value(forKey:"data") as! NSArray
            for (_, item) in data.enumerated()
            {
                let dic = item as? NSDictionary
                obj.listProduct.append(Product().parseDataFromDictionary(dic!))
            }
        }
        
        return obj
        
    }
    
}
