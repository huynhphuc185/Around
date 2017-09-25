

import UIKit
import Alamofire
import Foundation
import GooglePlaces
import GoogleMaps
class DataConnect: NSObject {
    static var mainURL = ""
    static let registerURL = mainURL + "/user/register"
    static let loginURL = mainURL + "/user/login"
    static let verifyOTPURL = mainURL + "/user/verify"
    static let updateProfileURL = mainURL + "/user/update_profile"
    static let getProfileInfo = mainURL + "/user/get_profile"
    static let verifyProfile = mainURL + "/user/verify_profile"
    static let getPayment = mainURL + "/user/get_payment"
    static let updatePayment = mainURL + "/user/update_payment"
    static let estimateCost = mainURL + "/user/estimate_cost"
    static let getOrderInfo = mainURL + "/user/get_order_info"
    static let getListShop = "http://api.mapp.vn/api/getlistShop"
    static let getListShopItem = "http://api.mapp.vn/api/getlistItem"
    static let logOutURL =  mainURL + "/user/logout"
    static let checkReconnect = mainURL + "/user/check_reconnect_journey"
    static let signUpToShip = mainURL + "/user/signup_to_ship"
    //static let getErrorConfig = mainURL + "/user/get_error_config"
    static let getAppConfig = mainURL + "/user/get_app_config"
    static let getEvent = mainURL + "/user/get_event"
    static let getMainCategory = mainURL + "/gifting/get_main_category"
    static let getCategoryContent = mainURL + "/gifting/get_category_content"
    static let getProductDetail = mainURL + "/gifting/get_product_detail"
    static let addProductToCard = mainURL + "/gifting/add_product_to_cart"
    static let removeProductToCard = mainURL + "/gifting/remove_product_from_cart"
    static let getNumberOfproductInCart = mainURL + "/gifting/get_number_product_in_cart"
    static let getCart = mainURL + "/gifting/get_cart"
    static let searchProduct = mainURL + "/gifting/search_product"
    static let clearProduct = mainURL + "/gifting/clear_product_from_cart"
    static let pickGifting = mainURL + "/gifting/update_delivery_info"
    static let getNganLuongBank = mainURL + "/user/get_nganluong_payment"
    static let getNganLuongURL = mainURL + "/user/get_nganluong_url"
    static let checkPayment = mainURL + "/user/check_nganluong_payment"
    static let getDetailProduct = mainURL + "/gifting/get_product_detail"
    static let updatePromotion = mainURL + "/user/update_promo_code"
    static let getPromotion = mainURL + "/user/get_promo_code"
    static let likeProduct = mainURL + "/gifting/like_product"
    static let getComment = mainURL + "/gifting/get_product_comment"
    static let updateDeliveryInfo = mainURL + "/gifting/update_drop_info"
    static let getNotification = mainURL + "/user/get_notification"
    static let getNotificationDetail = mainURL + "/user/get_notification_detail"
    static let getRelatedProduct = mainURL + "/gifting/get_related_product"
    static let rateAndCommentUrl = mainURL + "/gifting/rate_comment_product"
    static let getRatingReason = mainURL + "/user/get_rating_reason"
    static let sendLoginInfo = mainURL + "/user/send_login_info"
    static let updateGiftProduct = mainURL + "/gifting/update_gift_product"
    static let updateGiftCart = mainURL + "/gifting/update_gift_cart"
    static let getFullOrderURL = mainURL + "/user/get_full_order"
    static let updatePaymentType_ = mainURL + "/user/change_order_payment"
    static let getShipperPosition = mainURL + "/user/get_shipper_position"
    static let getGoogleKey = mainURL + "/user/get_google_key"
    static let sendActionInfo = mainURL + "/user/send_action_info"
    static let getOrderNumber = mainURL + "/user/get_number_new_info_menu"
    static let get1PayURL = mainURL + "/user/get_1pay_url"
    static let check1Pay = mainURL + "/user/check_1pay_payment"
    static let sendDeviceToken = mainURL + "/user/update_device_token"
    static let getOrderStatus = mainURL + "/user/get_order_status"
    static let getAroundPay = mainURL + "/user/get_around_pay"
    static let getAroundPayURL = mainURL + "/user/get_around_pay_url"
    static let checkAroudPay = mainURL + "/user/check_around_pay_payment"
    static let ratingURL = mainURL + "/user/rating"
    static let listBanner = mainURL + "/user/get_banner"
    static let getBannerDetail = mainURL + "/user/get_banner_detail"
    static let tobeSupplier = mainURL + "/user/signup_to_supplier"
    static let requestOrderID = mainURL + "/user/get_request_order_id"
    
   // static let checkConfig = "http://config.around.vn/config/info.json"
    static let checkConfig = "http://config.around.vn/dev/info.json"
    typealias onSuccess = (_ result : AnyObject?)->()
    typealias onFailed = (_ error: AnyObject) -> ()
    class func convertCoordinatesToAddress(_ url : String,onsuccess : @escaping onSuccess, onFailure : @escaping onFailed) {
        Alamofire.request(url).responseJSON { response in
            switch response.result {
            case .success:
                onsuccess(response.result.value! as AnyObject?)
            case .failure(let error):
                print(error)
                onFailure(0 as AnyObject)
            }
        }
        
    }
    class func getDirection(_ url : String,onsuccess : @escaping onSuccess, onFailure : @escaping onFailed) {
        Alamofire.request( url).responseJSON { response in
            switch response.result {
            case .success:
                onsuccess(response.result.value! as AnyObject?)
            case .failure(let error):
                print(error)
                onFailure(0 as AnyObject)
            }
            
        }
    }
    class func registerByPhoneNumber (_ numberPhone : String ,country_code : String,token : String, fullname:String, email:String, avatar: String, view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        let parameters = [
            "country_code": country_code,
            "token": token,
            "phone": numberPhone,
            "deviceid": deviceID(),
            "devicetoken": defaults.value(forKey: "deviceToken") as! String,
            "fullname": fullname,
            "email": email,
            "avatar": avatar,
            "os" : "IOS"
        ]
        
        Alamofire.request(registerURL, method: .post, parameters: parameters).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value as? NSDictionary
                {
                    
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        onsuccess(nil)
                    }
                    else
                    {
                        onFailure(JSON.value(forKey: "code") as AnyObject)
                    }
                    hideProgressHub()
                }
            case .failure(let error):
                print(error)
                onFailure(0 as AnyObject)
                hideProgressHub()
            }
            
            
            
            
            
        }
        
        
        
    }
    
    
    class func login (_ numberPhone : String ,country_code : String, view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        let deviceTOken = defaults.value(forKey: "deviceToken") as! String
        let parameters = [
            "country_code": country_code,
            "phone": numberPhone,
            "deviceid": deviceID(),
            "devicetoken": deviceTOken ,
            "os" : "IOS"
        ]
        Alamofire.request(loginURL, method: .post, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value as? NSDictionary
                {
                    
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        onsuccess(nil)
                    }
                    else
                    {
                        onFailure(JSON.value(forKey: "code") as AnyObject)
                    }
                    hideProgressHub()
                }
            case .failure(let error):
                print(error)
                onFailure(0 as AnyObject)
                hideProgressHub()
            }
            
            
            
            
            
        }
        
        
        
    }
    
    class func updateProfile (_ numberPhone : String ,token : String,country_code : String, new_email : String,new_fullname: String, new_avatar: String,birthday:String,view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        let parameters = [
            "country_code": country_code,
            "phone": numberPhone,
            "deviceid": deviceID(),
            "token": token,
            "new_fullname" : new_fullname,
            "new_avatar" : new_avatar,
            "new_email" : new_email,
            "birthday" : birthday
        ]
        Alamofire.request(updateProfileURL,method: .post , parameters:parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        onsuccess("success" as AnyObject?)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject)
                    }
                    hideProgressHub()
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
                hideProgressHub()
            }
            
            
            
            
            
        }
    }
    
    
    class func getUserInfo (_ token : String,country_code : String, phone:String,isNeedShowProcess: Bool,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        if isNeedShowProcess
        {
            showProgressHub()
        }
        
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code
        ]
        
        Alamofire.request(getProfileInfo , method: .get , parameters:parameters ).responseJSON { response in
            //  hideProgressHub()
            switch response.result {
            case .success:
                if let JSON = response.result.value as? NSDictionary
                {
                    if JSON.value(forKey:"code") as! Int == 1
                    {
                        let profile = Profile()
                        profile.phone = JSON.value(forKey: "phone") as? String
                        profile.fullname = JSON.value(forKey: "fullname") as? String
                        profile.avatar = JSON.value(forKey: "avatar") as? String
                        profile.email = JSON.value(forKey: "email") as? String
                        profile.birthday = JSON.value(forKey: "birthday") as? String
                        onsuccess(profile)
                    }
                    else{
                        onFailure(JSON.value(forKey:"code") as AnyObject )
                    }
                    if isNeedShowProcess
                    {
                         hideProgressHub()
                    }
                   
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
                if isNeedShowProcess
                {
                    hideProgressHub()
                }
            }
            
        }
    }
    
    
    
    class func verifyOTP (_ numberPhone : String ,otpCode : String,country_code : String ,view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        let parameters = [
            "phone": numberPhone,
            "otp" : otpCode,
            "deviceid": deviceID(),
            "devicetoken":  defaults.value(forKey: "deviceToken") as! String,
            "country_code": country_code,
            "os" : "IOS"
        ]
        
        Alamofire.request(verifyOTPURL ,method: .post , parameters:parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        defaults.set(JSON.value(forKey: "token") as! String , forKey: "token")
                        token_API = defaults.value(forKey: "token") as! String
                        onsuccess("success" as AnyObject?)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code")  as AnyObject )
                    }
                    hideProgressHub()
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
                hideProgressHub()
            }
            
        }
    }
    
    
    
    
    
    
    class func verifyProfile (_ numberPhone : String ,otpCode : String,country_code : String,token : String,new_phone: String ,view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        let parameters = [
            "phone": numberPhone,
            "otp" : otpCode,
            "deviceid": deviceID(),
            "token": token,
            "country_code": country_code,
            "new_phone": new_phone
        ]
        
        Alamofire.request(verifyProfile , method: .post , parameters:parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        defaults.setValue(JSON.value(forKey: "token") as! String , forKey: "token")
                        onsuccess("success" as AnyObject?)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code")  as AnyObject )
                    }
                    hideProgressHub()
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
                hideProgressHub()
            }
            
        }
    }
    
    
    
    
    class func getPayment (_ token : String,country_code : String, phone:String,view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code
        ]
        
        Alamofire.request(getPayment , method: .get, parameters:parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                        
                    {
                        let paymentObj = PaymentObject()
                        paymentObj.payment_type = JSON.value(forKey:"payment_type") as? String
                        onsuccess(paymentObj)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    hideProgressHub()
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
                hideProgressHub()
            }
            
        }
    }
    
    class func updatePayment (_ paymentInfo : PaymentObject,numberPhone : String  ,country_code : String,token : String ,view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        let parameters = [
            "phone": numberPhone,
            "deviceid": deviceID(),
            "token": token,
            "country_code": country_code,
            "payment_type": paymentInfo.payment_type!
        ]
        
        Alamofire.request(updatePayment , method: .post , parameters: parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                        
                    {
                        onsuccess("success" as AnyObject?)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    hideProgressHub()
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
                hideProgressHub()
            }
            
        }
    }
    
    
    
    class func getOrderHistory (_ token : String,country_code : String, phone:String, type: String ,view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        
        showProgressHub()
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code,
            "type" : type
        ]
        
        Alamofire.request(getOrderInfo , method : .get ,  parameters:parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
//                        let data = JSON.value(forKey:"data") as! NSArray
//                        var listData : [HistoryObject] = []
//                        for (_, item) in data.enumerated()
//                        {
//                            let dic = item as? NSDictionary
//                            listData.append(HistoryObject().parseDataFromDictionary(dic!))
//                        }
//                        onsuccess(listData as AnyObject?)
                        
                        let jsonData = try! JSONSerialization.data(withJSONObject: JSON)
                        let jSonString = String(data: jsonData, encoding: .utf8)!
                        let obj = ListHistoryObject(JSONString: jSonString)
                        onsuccess(obj as AnyObject?)

                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    hideProgressHub()
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
                hideProgressHub()
            }
            
        }
    }
    
    
    
    class func estimationCost (_ numberPhone : String  ,country_code : String,token : String , locations : NSString , minute: Int,hour: Int,day: Int,month: Int,year: Int,
                               returntopickup: Bool,view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        let parameters = [
            "phone": numberPhone,
            "deviceid": deviceID(),
            "token": token,
            "country_code": country_code,
            "minute": minute,
            "hour": hour,
            "day": day,
            "month": month,
            "year": year,
            "return_to_pickup": returntopickup,
            "locations" : locations
            ] as [String : Any]
        Alamofire.request(estimateCost , method: .post , parameters: parameters  ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        let obj = EstimateObject().parseDataFromDictionary(JSON)
                        onsuccess(obj as AnyObject?)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    hideProgressHub()
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
                hideProgressHub()
            }
            
        }
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    class func logoutAPI(_ country_code:String,view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed)
    {
        showProgressHub()
        let parameters = [
            "country_code": country_code,
            "phone":userPhone_API,
            "deviceid":deviceID(),
            "token":token_API
        ]
        
        Alamofire.request(logOutURL , method: .post, parameters: parameters  ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        
                        onsuccess(nil)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    hideProgressHub()
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
                hideProgressHub()
            }
            
        }
        
    }
    
    
    
    class func checkReconnect(_ country_code:String,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed)
    {
        
        let parameters = [
            "country_code": country_code,
            "phone":userPhone_API,
            "deviceid":deviceID(),
            "token":token_API
        ]
        
        Alamofire.request(checkReconnect ,method:.get, parameters: parameters  ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        
                        onsuccess(nil)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
            }
            
        }
        
    }
    
    
    
    class func signUpToShip(_ country_code:String, dict: NSMutableDictionary , view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed)
    {
        showProgressHub()
        let parameters = [
            "country_code": country_code,
            "phone":userPhone_API,
            "deviceid":deviceID(),
            "token":token_API,
            "fullname": dict.value(forKey: "fullname") as! String,
            "id_no":dict.value(forKey: "id_no") as! String,
            "address":dict.value(forKey: "address") as! String,
            "phone_no":dict.value(forKey: "phone_no") as! String,
            "avatar":dict.value(forKey: "avatar") as! String
        ]
        Alamofire.request(signUpToShip ,method: .post, parameters: parameters  ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        onsuccess(nil)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    hideProgressHub()
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
                hideProgressHub()
            }
            
        }
        
    }
    
    
    
    
    
    
    
    class func getMainCategogy (_ token : String,country_code : String, phone:String,view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code
        ]
        
        
        Alamofire.request(getMainCategory , method : .get ,  parameters:parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        let data = JSON.value(forKey:"data") as! NSArray
                        var listData : [MainCategory] = []
                        for (_, item) in data.enumerated()
                        {
                            let dic = item as? NSDictionary
                            listData.append(MainCategory().parseDataFromDictionary(dic!))
                        }
                        onsuccess(listData as AnyObject?)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    hideProgressHub()
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
                hideProgressHub()
            }
            
        }
    }
    
    
    class func getCategoryContent (_ token : String,country_code : String, phone:String,id_category:Int,page:Int,tab: String,view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        
        showProgressHub()
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code,
            "id_category" : id_category,
            "page" : page,
            "tab": tab
            ] as [String : Any]
        
        Alamofire.request(getCategoryContent , method : .get ,  parameters:parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        let categoryContent = CategoryContent().parseDataFromDictionary(JSON)
                        onsuccess(categoryContent as AnyObject?)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    hideProgressHub()
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
                hideProgressHub()
            }
            
        }
        
    }
    
    class func addItemToCart (_ token : String,country_code : String, phone:String,id_product:Int, attributes:String,view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code,
            "id_product" : id_product,
            "number" : 1,
            "attributes" : attributes
            ] as [String : Any]
        
        
        
        
        Alamofire.request(addProductToCard , method : .post ,  parameters:parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        onsuccess(nil)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    hideProgressHub()
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
                hideProgressHub()
            }
            
        }
        
    }
    
    class func removeProductToCard (_ token : String,country_code : String, phone:String,id_product:Int,view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code,
            "id_product" : id_product,
            ] as [String : Any]
        
        
        
        
        Alamofire.request(removeProductToCard , method : .post ,  parameters:parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        onsuccess(nil)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    hideProgressHub()
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
                hideProgressHub()
            }
            
        }
        
    }
    
    
    
    
    
    class func getNumberProductnCart (_ token : String,country_code : String, phone:String,view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code
        ]
        Alamofire.request(getNumberOfproductInCart , method : .get ,  parameters:parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        let data = JSON.value(forKey:"data") as! NSDictionary
                        let number = data.value(forKey: "number")
                        onsuccess(number as AnyObject?)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
            }
            
        }
        
    }
    
    
    
    
    
    class func getCart (_ token : String,country_code : String, phone:String,view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        
        showProgressHub()
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code
        ]
        Alamofire.request(getCart , method : .get ,  parameters:parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        let data = JSON.value(forKey:"data") as! NSDictionary
                        let cart = Cart().parseDataFromDictionary(data)
                        onsuccess(cart as AnyObject?)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    hideProgressHub()
                }
            case .failure(let error):
                onFailure(0 as AnyObject)
                print(error)
                hideProgressHub()
            }
            
        }
        
    }
    
    
    class func searchProduct (_ token : String,country_code : String, phone:String,  keyword: String, page: Int , view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code,
            "keyword" : keyword,
            "page" : page
            ] as [String : Any]
        Alamofire.request(searchProduct , method : .get ,  parameters:parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        
                        let data = JSON.value(forKey:"data") as! NSArray
                        var listData : [Product] = []
                        for (_, item) in data.enumerated()
                        {
                            let dic = item as? NSDictionary
                            listData.append(Product().parseDataFromDictionary(dic!))
                        }
                        onsuccess(listData as AnyObject?)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    hideProgressHub()
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
                hideProgressHub()
            }
            
        }
        
    }
    
    class func clearProduct (_ token : String,country_code : String, phone:String, id_product: Int , view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code,
            "id_product" : id_product,
            ] as [String : Any]
        Alamofire.request(clearProduct , method : .post ,  parameters:parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        let data = JSON.value(forKey:"data") as! NSDictionary
                        let number = data.value(forKey: "number_in_cart")
                        onsuccess(number as AnyObject?)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    hideProgressHub()
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
                hideProgressHub()
            }
            
        }
        
    }
    
    class func pickGifting (_ token : String,country_code : String, phone:String, locations: String , view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code,
            "locations" : locations,
            "type" : "LOCATION"
        ]
        Alamofire.request(pickGifting , method : .post ,  parameters:parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        onsuccess(nil)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    hideProgressHub()
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
                hideProgressHub()
            }
            
        }
        
    }
    
    
    class func putDeliveryTime (_ token : String,country_code : String, phone:String ,delivery_day:Int ,delivery_month:Int, delivery_year:Int,  view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code,
            "type" : "DELIVERY_TIME",
            "delivery_day" : delivery_day,
            "delivery_month" : delivery_month,
            "delivery_year" : delivery_year
            ] as [String : Any]
        Alamofire.request(pickGifting , method : .post ,  parameters:parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        onsuccess(nil)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    hideProgressHub()
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
                hideProgressHub()
            }
            
        }
        
    }
    
    
    
    class func getNganLuongBank (_ token : String,country_code : String, phone:String ,  view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        Alamofire.request(getNganLuongBank , method : .get ,  parameters: nil ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        let data = JSON.value(forKey:"data") as! NSArray
                        var listPayment :[PaymentNganLuong] = []
                        for item in data.enumerated()
                        {
                            let dic = item.element as? NSDictionary
                            let payment = PaymentNganLuong().parseDataFromDictionary(dic!)
                            listPayment.append(payment)
                            
                        }
                        onsuccess(listPayment as AnyObject?)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    hideProgressHub()
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
                hideProgressHub()
            }
            
        }
        
    }
    
    
    class func getNganLuongURL (_ token : String,country_code : String, phone:String ,order_id: Int,payment_code: String , bank_code: String  , view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code,
            "order_id" : order_id,
            "payment_code" : payment_code,
            "bank_code" : bank_code,
            ] as [String : Any]
        
        
        Alamofire.request(getNganLuongURL , method : .get ,  parameters: parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        let data = JSON.value(forKey:"data") as! NSDictionary
                        let url = data.value(forKey: "url") as! String
                        onsuccess(url as AnyObject?)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    hideProgressHub()
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
                hideProgressHub()
            }
            
        }
        
    }
    
    
    
    class func get1PayURL (_ token : String,country_code : String, phone:String ,order_id: Int , type:String,view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code,
            "order_id" : order_id,
            "type" : type
            ] as [String : Any]
        
        
        Alamofire.request(get1PayURL , method : .get ,  parameters: parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        let data = JSON.value(forKey:"data") as! NSDictionary
                        let url = data.value(forKey: "url") as! String
                        onsuccess(url as AnyObject?)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    hideProgressHub()
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
                hideProgressHub()
            }
            
        }
        
    }
    
    
    class func check1Pay_ (_ token : String,country_code : String, phone:String ,order_id: Int , view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code,
            "order_id" : order_id
            ] as [String : Any]
        
        
        Alamofire.request(check1Pay , method : .get ,  parameters: parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        onsuccess(nil)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    hideProgressHub()
                }
                
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
                hideProgressHub()
            }
            
        }
        
    }
    
    class func checkPayment (_ token : String,country_code : String, phone:String ,id: String, view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code,
            "id" : id
            ] as [String : Any]
        
        
        Alamofire.request(checkPayment , method : .get ,  parameters: parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        onsuccess(nil)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    hideProgressHub()
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
                hideProgressHub()
            }
            
        }
        
    }
    
    
    class func getDetailProduct (_ token : String,country_code : String, phone:String ,id_product: Int, view: UIView?,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code,
            "id_product" : id_product,
            ] as [String : Any]
        
        
        Alamofire.request(getDetailProduct , method : .get ,  parameters: parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        let data = JSON.value(forKey:"data") as! NSDictionary
                        let jsonData = try! JSONSerialization.data(withJSONObject: data)
                        let jSonString = String(data: jsonData, encoding: .utf8)!
                        let obj = DetailProduct(JSONString: jSonString)
                        onsuccess(obj as AnyObject?)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    hideProgressHub()
                    view?.isHidden = true
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
                hideProgressHub()
                 view?.isHidden = true
            }
            
        }
        
    }
    
    
    class func getPromotion (_ token : String,country_code : String, phone:String , view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code
            ] as [String : Any]
        
        
        Alamofire.request(getPromotion , method : .get ,  parameters: parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        let data = JSON.value(forKey:"data") as! NSDictionary
                        onsuccess(data.value(forKey: "promo_code") as AnyObject?)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    hideProgressHub()
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
                hideProgressHub()
            }
            
        }
        
    }
    
    
    
    class func updatePromotion (_ token : String,country_code : String, phone:String ,promo_code: String, view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code,
            "promo_code" : promo_code,
            ] as [String : Any]
        
        
        Alamofire.request(updatePromotion , method : .post ,  parameters: parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        let data = JSON.value(forKey:"data") as! NSDictionary
                        onsuccess(data.value(forKey: "value") as AnyObject?)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    hideProgressHub()
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
                hideProgressHub()
            }
            
        }
        
    }
    
    
    
    class func likeProduct (_ token : String,country_code : String, phone:String ,id_product: Int, view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code,
            "id_product" : id_product,
            ] as [String : Any]
        
        
        Alamofire.request(likeProduct , method : .post ,  parameters: parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        onsuccess(1 as AnyObject?)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    hideProgressHub()
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
                hideProgressHub()
            }
            
        }
        
    }
    
    
    
    class func getComment (_ token : String,country_code : String, phone:String ,id_product: Int,page: Int, view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code,
            "id_product" : id_product,
            "page" : page
            ] as [String : Any]
        
        
        Alamofire.request(getComment , method : .get ,  parameters: parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        let data = JSON.value(forKey:"data") as! NSDictionary
                        let jsonData = try! JSONSerialization.data(withJSONObject: data)
                        let jSonString = String(data: jsonData, encoding: .utf8)!
                        let obj = TotalComments(JSONString: jSonString)
                        onsuccess(obj as AnyObject?)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    hideProgressHub()
                    
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
                hideProgressHub()
            }
            
        }
        
    }
    
    class func getRelateProduct (_ token : String,country_code : String, phone:String ,id_product: Int,page: Int, view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code,
            "id_product" : id_product,
            "page" : page
            ] as [String : Any]
        
        
        Alamofire.request(getRelatedProduct , method : .get ,  parameters: parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        let data = JSON.value(forKey:"data") as! NSDictionary
                        let proc = data.value(forKey:"products") as! NSArray
                        var listData : [Product] = []
                        for (_, item) in proc.enumerated()
                        {
                            let dic = item as? NSDictionary
                            listData.append(Product().parseDataFromDictionary(dic!))
                        }
                        onsuccess(listData as AnyObject?)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    hideProgressHub()
                    
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
                hideProgressHub()
            }
            
        }
        
    }
    
    
    
    class func rateAndComment (_ token : String,country_code : String, phone:String ,id_product: Int,star: Int,comment: String, view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code,
            "id_product" : id_product,
            "star" : star,
            "comment" : comment,
            ] as [String : Any]
        
        
        Alamofire.request(rateAndCommentUrl , method : .post ,  parameters: parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        onsuccess(nil)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    hideProgressHub()
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
                hideProgressHub()
            }
            
        }
        
    }
    
    
    class func getRatingReason (_ token : String,country_code : String, phone:String , view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code,
            ] as [String : Any]
        
        
        Alamofire.request(getRatingReason , method : .get ,  parameters: parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        
                        let data = JSON.value(forKey:"data") as! NSDictionary
                        let jsonData = try! JSONSerialization.data(withJSONObject: data)
                        let jSonString = String(data: jsonData, encoding: .utf8)!
                        let obj = RatingReason(JSONString: jSonString)
                        onsuccess(obj as AnyObject)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    hideProgressHub()
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
                hideProgressHub()
            }
            
        }
        
    }
    
    
    class func updateGiftProduct (_ token : String,country_code : String, phone:String ,id_product: Int,status: Int, view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code,
            "id_product" : id_product,
            "status" : status,
            ] as [String : Any]
        
        
        Alamofire.request(updateGiftProduct , method : .post ,  parameters: parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        onsuccess(nil)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    hideProgressHub()
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
                hideProgressHub()
            }
            
        }
        
    }
    
    class func updateGiftCart (_ token : String,country_code : String, phone:String ,status: Int, view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code,
            "status" : status,
            ] as [String : Any]
        
        
        Alamofire.request(updateGiftCart , method : .post ,  parameters: parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        onsuccess(nil)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    hideProgressHub()
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
                hideProgressHub()
            }
            
        }
        
    }
    
    
//    class func configIP (onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
//    {
//        let url = checkConfig + "?version=" + (randomStringWithLength(8) as String)
//        Alamofire.request(url , method : .get ,  parameters: nil ).responseJSON { response in
//            
//            switch response.result {
//            case .success:
//                if let JSON = response.result.value  as? NSArray
//                {
//                    let version = kVersion
//                    for item in JSON.enumerated()
//                    {
//                        let data = item.element as! NSDictionary
//                        if version == data.value(forKey: "version") as? String
//                        {
//                            let ip = data.value(forKey: "restful_ip") as? String
//                            let port = data.value(forKey: "restful_port") as? Int
//                            
//                            mainURL = ip! + ":" + String(format: "%d", port!)
//                            
//                            ConfigIP.sharedInstance.smartfox_ip = data.value(forKey: "smartfox_ip") as? String
//                            ConfigIP.sharedInstance.smartfox_port = data.value(forKey: "smartfox_port") as? Int
//                            
//                        }
//                    }
//                    onsuccess(nil)
//                }
//            case .failure(let error):
//                
//                onFailure(0 as AnyObject)
//                print(error)
//            }
//        }
//        
//    }
    
    class func configIP (onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        let url = checkConfig + "?version=" + (randomStringWithLength(8) as String)
        print(url)
        Alamofire.SessionManager.default.requestWithoutCache(url).responseJSON { (response) in
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSArray
                {
                    let version = kVersion
                    for item in JSON.enumerated()
                    {
                        let data = item.element as! NSDictionary
                        if version == data.value(forKey: "version") as? String
                        {
                            let ip = data.value(forKey: "restful_ip") as? String
                            let port = data.value(forKey: "restful_port") as? Int
                            
                            mainURL = ip! + ":" + String(format: "%d", port!)
                            
                            ConfigIP.sharedInstance.smartfox_ip = data.value(forKey: "smartfox_ip") as? String
                            ConfigIP.sharedInstance.smartfox_port = data.value(forKey: "smartfox_port") as? Int
                            
                        }
                    }
                    onsuccess(nil)
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
            }
        }
    }

    
    
    
    
    class func getFullOrder (_ token : String,country_code : String, phone:String ,id_order: Int, view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code,
            "id_order" : id_order,
            ] as [String : Any]
        Alamofire.request(getFullOrderURL , method : .get ,  parameters: parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        let data = JSON.value(forKey:"data") as! NSDictionary
                        let jsonData = try! JSONSerialization.data(withJSONObject: data)
                        let jSonString = String(data: jsonData, encoding: .utf8)!
                        let obj = FullOrder(JSONString: jSonString)
                        onsuccess(obj as AnyObject)
                        
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    hideProgressHub()
                    view.isHidden = true
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
                view.isHidden = true
                hideProgressHub()
            }
            
        }
        
    }
    
    
    class func updatePaymentType (_ token : String,country_code : String, phone:String ,id_order: Int,payment_type: String, view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code,
            "id_order" : id_order,
            "payment_type" : payment_type,
            ] as [String : Any]
        
        
        Alamofire.request(updatePaymentType_ , method : .post ,  parameters: parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        onsuccess(nil)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    hideProgressHub()
                }
            case .failure(let error):
                onFailure(0 as AnyObject)
                print(error)
                hideProgressHub()
            }
            
        }
        
    }
    
    
    class func getListShipperPosition (_ token : String,country_code : String, phone:String ,id_order: Int, view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code,
            "id_order" : id_order
            ] as [String : Any]
        
        
        Alamofire.request(getShipperPosition , method : .get ,  parameters: parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        let data = JSON.value(forKey:"data") as! NSDictionary
                        let jsonData = try! JSONSerialization.data(withJSONObject: data)
                        let jSonString = String(data: jsonData, encoding: .utf8)!
                        let obj = ListShipperPosition(JSONString: jSonString)
                        onsuccess(obj as AnyObject)
                        
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    hideProgressHub()
                }
            case .failure(let error):
                onFailure(0 as AnyObject)
                print(error)
                hideProgressHub()
            }
            
        }
        
    }
    
    
    class func sendLoginInfo (_ token : String,country_code : String, phone:String ,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        
        
        let version = kVersion
        //        if let version_ = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
        //            version = version_
        //        }
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code,
            "devicetoken" : defaults.value(forKey: "deviceToken") as! String,
            "os" : "IOS",
            "version" : version,
            ] as [String : Any]
        
        
        Alamofire.request(sendLoginInfo , method : .post ,  parameters: parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        onsuccess(nil)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
            }
        }
        
    }
    class func getAppConfig(_  error_version : Int,    onsuccess : @escaping onSuccess , onFailure: @escaping onFailed)
    {
        let version = kVersion
        //        if let version_ = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
        //            version = version_
        //        }
        let parameters = [
            "error_version": error_version,
            "app_os": "IOS",
            "app_version" : version] as [String : Any]
        
        Alamofire.request(getAppConfig ,method: .get, parameters: parameters  ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        
                        let data = JSON.value(forKey:"data") as! NSDictionary
                        let jsonData = try! JSONSerialization.data(withJSONObject: data)
                        let jSonString = String(data: jsonData, encoding: .utf8)!
                        let obj = DataConfig(JSONString: jSonString)
                        var arrayEnglish = [NSMutableDictionary]()
                        var arrayVN = [NSMutableDictionary]()
                        if obj?.error?.content?.count != 0
                        {
                            for i in 0...(obj?.error?.content?.count)! - 1
                            {
                                let dicEN = NSMutableDictionary()
                                dicEN.setValue(obj?.error?.content?[i].description, forKey:  String(format: "%d", (obj?.error?.content?[i].id)!))
                                arrayEnglish.append(dicEN)
                                let dicVN = NSMutableDictionary()
                                dicVN.setValue(obj?.error?.vn_content?[i].description, forKey:  String(format: "%d", (obj?.error?.vn_content?[i].id)!))
                                arrayVN.append(dicVN)
                            }
                            if obj?.error?.status == 1
                            {
                                NSKeyedArchiver.archiveRootObject(arrayEnglish, toFile: filePathEnglish)
                                NSKeyedArchiver.archiveRootObject(arrayVN, toFile: filePathVietNamese)
                                defaults.setValue(obj?.error?.version, forKey: "versionconfig")
                            }
                        }
                        
                        
                        onsuccess(obj as AnyObject)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
            }
            
        }
        
    }
    
    class func sendTracking (_ token : String,country_code : String, phone:String ,action: String,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code,
            "action" : action
        ]
        
        
        Alamofire.request(sendActionInfo , method : .post ,  parameters: parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        onsuccess(nil)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
            }
        }
        
    }
    class func getOrderNumber (_ token : String,country_code : String, phone:String,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code
        ]
        
        
        Alamofire.request(getOrderNumber , method : .get ,  parameters: parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        let data = JSON.value(forKey:"data") as! NSDictionary
                        let jsonData = try! JSONSerialization.data(withJSONObject: data)
                        let jSonString = String(data: jsonData, encoding: .utf8)!
                        let obj = NumberLeftMenu(JSONString: jSonString)
                        onsuccess(obj as AnyObject)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
            }
        }
        
    }
    
    
    
    
    
    
    class func getOrderStatus (_ token : String,country_code : String, phone:String, id_order: Int,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code,
            "id_order" : id_order
            ] as [String : Any]
        
        
        Alamofire.request(getOrderStatus , method : .get ,  parameters: parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        let data = JSON.value(forKey:"data") as! NSDictionary
                        let jsonData = try! JSONSerialization.data(withJSONObject: data)
                        let jSonString = String(data: jsonData, encoding: .utf8)!
                        let obj = CheckOrderStatusObject(JSONString: jSonString)
                        onsuccess(obj as AnyObject)
                        
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
            }
        }
        
    }
    
    class func sendDevicetoken (_ devicetoken : String,country_code : String, phone:String,firebase_devicetoken:String ,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        
        
        
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "devicetoken": devicetoken,
            "country_code" : country_code,
            "firebase_devicetoken" : firebase_devicetoken
        ]
        
        
        
        
        Alamofire.request(sendDeviceToken , method : .post ,  parameters: parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    print(JSON.value(forKey: "code") as! Int)
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        onsuccess(nil)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
            }
        }
        
    }
    
    
    
    class func getAroundPay_ (_ token : String,country_code : String, phone:String,view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code
        ]
        
        Alamofire.request(getAroundPay , method : .get ,  parameters: parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        let data = JSON.value(forKey:"data") as! NSDictionary
                        let aroundPay = data.value(forKey: "around_pay")
                        onsuccess(aroundPay as AnyObject?)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
            }
        }
        
    }
    
    
    class func getAroundPay_URL(_ token : String,country_code : String, phone:String,value:Double,type:String,view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code,
            "value" : value,
            "type" : type
            ] as [String : Any]
        
        Alamofire.request(getAroundPayURL , method : .get ,  parameters: parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        let data = JSON.value(forKey:"data") as! NSDictionary
                        let jsonData = try! JSONSerialization.data(withJSONObject: data)
                        let jSonString = String(data: jsonData, encoding: .utf8)!
                        let obj = PaymentURL(JSONString: jSonString)
                        onsuccess(obj as AnyObject)
                        
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
            }
            hideProgressHub()
        }
        
    }
    class func checkAroundPay (_ token : String,country_code : String, phone:String,trans_ref:String,view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code,
            "trans_ref" : trans_ref
            ] as [String : Any]
        
        Alamofire.request(checkAroudPay , method : .get ,  parameters: parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        onsuccess(nil)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
            }
            hideProgressHub()
        }
        
    }
    
    class func rating_ (_ token : String,country_code : String, phone:String,id_reason:Int,star:Int,id_order:Int,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code,
            "id_reason" : id_reason,
            "star" : star,
            "id_order" : id_order
            ] as [String : Any]
        
        Alamofire.request(ratingURL , method : .post ,  parameters: parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        onsuccess(nil)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
            }
            hideProgressHub()
        }
        
    }
    
    
    
    class func tobeSupplier (_ numberPhone : String ,country_code : String,token : String,  fullname: String, shopname: String,address: String,phone_number: String,email: String,product: String,type: String,website:String,facebook:String,arrImage: NSMutableArray, view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
         showProgressHub()
        let parameters = [
            "country_code": country_code,
            "token": token,
            "phone": numberPhone,
            "deviceid": deviceID(),
            "supplier_fullname": fullname,
            "supplier_shopname": shopname,
            "supplier_address": address,
            "supplier_phone": phone_number,
            "supplier_email": email,
            "supplier_website": website,
            "supplier_facebook": facebook,
            "supplier_product": product,
            "supplier_type": type]
        
        
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for item in arrImage.enumerated()
            {
                if let imageData = UIImageJPEGRepresentation(item.element as! UIImage, 1) {
                    multipartFormData.append(imageData, withName: "file" + String(item.offset), fileName: String(format: "file%d.jpeg", item.offset), mimeType: "image/jpeg")
                }
                
            }
            for (key, value) in parameters {
                multipartFormData.append((value as String).data(using: .utf8)!, withName: key)
            }}, to: tobeSupplier, method: .post, headers: ["Authorization": "auth_token"],
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.uploadProgress(closure: { (progress) in
                            print(progress)
                        })
                        
                        upload.responseJSON { response in
                            if let JSON = response.result.value as? NSDictionary
                            {
                                
                                if JSON.value(forKey: "code") as! Int == 1
                                {
                                    onsuccess(nil)
                                }
                                else
                                {
                                    onFailure(JSON.value(forKey: "code") as AnyObject)
                                }
                            }
                             hideProgressHub()
                        }
                    case .failure(let error):
                        print(error)
                        onFailure(0 as AnyObject)
                        hideProgressHub()
                    }
                    
        })
    
    }
    
    class func updateDeliveryInfo (_ token : String,country_code : String, phone:String,recipent_name:String,recipent_phone:String,recipent_note:String,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code,
            "recipent_name" : recipent_name,
            "recipent_phone" : recipent_phone.removingWhitespaces(),
            "recipent_note" : recipent_note
            ] 
        
        Alamofire.request(updateDeliveryInfo , method : .post ,  parameters: parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        onsuccess(nil)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
            }
            hideProgressHub()
        }
        
    }
    
    
    class func getNotification(_ token : String,country_code : String, phone:String,page:Int,view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code,
            "page" : page
            ] as [String : Any]
        
        Alamofire.request(getNotification , method : .get ,  parameters: parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        let jsonData = try! JSONSerialization.data(withJSONObject: JSON)
                        let jSonString = String(data: jsonData, encoding: .utf8)!
                        let obj = ListNotificationObject(JSONString: jSonString)
                        onsuccess(obj as AnyObject)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
            }
            hideProgressHub()
        }
        
    }

    
    class func getNotificationDetail(_ token : String,country_code : String, phone:String,id:Int,view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code,
            "id" : id
            ] as [String : Any]
        
        Alamofire.request(getNotificationDetail , method : .get ,  parameters: parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
//                        let data = JSON.value(forKey:"data") as! NSDictionary
//                        let detail = data.value(forKey: "detail") as? String
                        
                        let data = JSON.value(forKey:"data") as! NSDictionary
                        let jsonData = try! JSONSerialization.data(withJSONObject: data)
                        let jSonString = String(data: jsonData, encoding: .utf8)!
                        let obj = NotificationDetail(JSONString: jSonString)

                        
                        onsuccess(obj as AnyObject)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
            }
            hideProgressHub()
        }
        
    }
    
    
    class func getEvent(_ token : String,country_code : String, phone:String,page:Int,view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code,
            "page" : page
            ] as [String : Any]
        Alamofire.request(getEvent , method : .get ,  parameters: parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        let jsonData = try! JSONSerialization.data(withJSONObject: JSON)
                        let jSonString = String(data: jsonData, encoding: .utf8)!
                        let obj = ListEventObject(JSONString: jSonString)
                        onsuccess(obj as AnyObject)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
            }
            hideProgressHub()
        }
        
    }

    
    class func getListBanner(_ token : String,country_code : String, phone:String,position:Int,view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code,
            "position" : position
            ] as [String : Any]
        
        Alamofire.request(listBanner , method : .get ,  parameters: parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        let jsonData = try! JSONSerialization.data(withJSONObject: JSON)
                        let jSonString = String(data: jsonData, encoding: .utf8)!
                        let obj = ListBanner(JSONString: jSonString)
                        onsuccess(obj as AnyObject)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
            }
     
        }
        
    }
    
    
    
    
    class func getBannerDetail(_ token : String,country_code : String, phone:String,id:Int,view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code,
            "id" : id
            ] as [String : Any]
        
        Alamofire.request(getBannerDetail , method : .get ,  parameters: parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        let jsonData = try! JSONSerialization.data(withJSONObject: JSON)
                        let jSonString = String(data: jsonData, encoding: .utf8)!
                        let obj = BannerDetail(JSONString: jSonString)
                        onsuccess(obj as AnyObject)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
            }
            hideProgressHub()
        }
        
    }

    
    
    class func getRequestOrderID(_ token : String,country_code : String, phone:String,view: UIView,onsuccess : @escaping onSuccess , onFailure: @escaping onFailed )
    {
        showProgressHub()
        let parameters = [
            "deviceid": deviceID(),
            "phone": phone,
            "token": token,
            "country_code" : country_code,
            ]
        
        Alamofire.request(requestOrderID , method : .get ,  parameters: parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value  as? NSDictionary
                {
                    if JSON.value(forKey: "code") as! Int == 1
                    {
                        let data = JSON.value(forKey:"data") as! NSDictionary
                        let id_request = data.value(forKey: "id_request")
                        onsuccess(id_request as AnyObject?)
                    }
                    else{
                        onFailure(JSON.value(forKey: "code") as AnyObject )
                    }
                    
                }
            case .failure(let error):
                
                onFailure(0 as AnyObject)
                print(error)
            }
            hideProgressHub()
        }
        
    }

    
}


