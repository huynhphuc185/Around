//
//  Function.swift
//  Soroeru
//
//  Created by Phuc Huynh on 3/21/16.
//  Copyright © 2016 soroeru.inc. All rights reserved.
//

import Foundation
import CoreLocation
import SystemConfiguration
import SDWebImage
func clearCache()
{
    SDImageCache.shared().clearMemory()
    SDImageCache.shared().clearDisk()
}
func setStatusBarBackgroundColor(_ color: UIColor) {
    
    guard  let statusBar = (UIApplication.shared.value(forKey: "statusBarWindow") as AnyObject).value(forKey: "statusBar") as? UIView else {
        return
    }
    statusBar.backgroundColor = color
}

func sortCaseInsensitive(_ values:[Int]) -> [Int]{
    
    let sortedValues = values.sorted(by: { (value1, value2) -> Bool in
        
        if (value1 < value2) {
            return true
        } else {
            return false
        }
    })
    return sortedValues
}
func convertFromStringToFloat(_ string: String) -> Float
{
    let numberFormatter = NumberFormatter()
    let number = numberFormatter.number(from: string)
    let numberFloatValue = number!.floatValue
    return numberFloatValue
}
func findKeyForValueArray(_ value: String, dictionary: [String: [String]]) ->String?
{
    for (key, array) in dictionary
    {
        if (array.contains(value))
        {
            return key
        }
    }
    
    return nil
}

func findKeyForValueString(_ value: String, dictionary: [String: String]) ->String?
{
    for (key, element) in dictionary
    {
        if element == value{
            return key
        }
    }
    
    return nil
}


func convertStringToDictionary ( _ text : String) -> [String:AnyObject]? {
    if let data = text.data(using: String.Encoding.utf8) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
            return json
        } catch {
            print("Something went wrong")
        }
    }
    return nil
}



func cropToBounds(_ image: UIImage, width: Double, height: Double) -> UIImage {
    
    let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
    
    let contextSize: CGSize = contextImage.size
    
    var posX: CGFloat = 0.0
    var posY: CGFloat = 0.0
    var cgwidth: CGFloat = CGFloat(width)
    var cgheight: CGFloat = CGFloat(height)
    
    // See what size is longer and create the center off of that
    if contextSize.width > contextSize.height {
        posX = ((contextSize.width - contextSize.height) / 2)
        posY = 0
        cgwidth = contextSize.height
        cgheight = contextSize.height
    } else {
        posX = 0
        posY = ((contextSize.height - contextSize.width) / 2)
        cgwidth = contextSize.width
        cgheight = contextSize.width
    }
    
    let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
    
    // Create bitmap image from context using the rect
    let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
    
    // Create a new image based on the imageRef and rotate back to the original orientation
    let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
    return image
}


func convertCurrentDateWithOutDay() -> String {
    let currentDate = Date()
    //Get date
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY/MM/dd"
    let dateString = dateFormatter.string(from: currentDate)
    let dateComponent = dateString.components(separatedBy: "/")
    let str1 = dateComponent[0]+"年"
    let str2 = dateComponent[1]+"月"
    let str3 = dateComponent[2]+"日"
    
    return str1 + str2 + str3
}
func validatePhone(value: String) -> Bool {
    let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
    let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
    let result =  phoneTest.evaluate(with: value)
    return result
}
func covertToJapanDate(_ time : String) -> String
{
    let toArray = time.components(separatedBy: "-")
    let str1 = toArray[0]+"年"
    let str2 = toArray[1]+"月"
    let str3 = toArray[2]+"日"
    let str4 = str1+str2+str3
    return str4
}
extension String
{
    func toDateTime(dateFormatStr : String) -> Date
    {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = dateFormatStr
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        //Parse into NSDate
        let dateFromString  = dateFormatter.date(from: self)!
        
        //Return Parsed Date
        return dateFromString
    }
    
    
    func toDateTimeWithTime(time:Time) -> Date
    {
        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)
        var date_components =  DateComponents()
        date_components.hour = time.hour
        date_components.minute = time.minute
        date_components.month = time.month
        date_components.day = time.day
        date_components.year = time.year
        date_components.second = 0
        let newDate = calendar?.date(from: date_components)!
        return newDate!
    }

}




func deviceID() ->String
{
    let device : UIDevice = UIDevice.current
    return (device.identifierForVendor?.uuidString)!
    //return "7DEEAFBB-5FDC-4455-9887-55F9C551ACF4"
}

func formatDate(day: Int, month: Int, year: Int) -> String
{
    
    let morningOfChristmasComponents = NSDateComponents()
    morningOfChristmasComponents.year = year
    morningOfChristmasComponents.month = month
    morningOfChristmasComponents.day = day
    let morningOfChristmas = Calendar.current.date(from: morningOfChristmasComponents as DateComponents)
    let formatter = DateFormatter()
    if MCLocalization.sharedInstance().language == "vi"
    {
        formatter.locale = Locale(identifier: "vi_VN")
    }
    else
    {
        formatter.locale = Locale(identifier: "en_US")
    }
    formatter.dateFormat = "dd MMMM, yyyy"
    
    let dateString = formatter.string(from: morningOfChristmas!)
    let fullDate = (morningOfChristmas?.dayOfWeek())! + ", " + dateString
    return fullDate
}

func formatTime(min: Int, hour: Int) -> String
{
    let morningOfChristmasComponents = NSDateComponents()
    morningOfChristmasComponents.minute = min
    morningOfChristmasComponents.hour = hour
    let morningOfChristmas = Calendar.current.date(from: morningOfChristmasComponents as DateComponents)
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    formatter.amSymbol = "AM"
    formatter.pmSymbol = "PM"
    let timeString = formatter.string(from: morningOfChristmas!)
    return timeString
}


func attributeForTitleTV(_ titleText : String) -> NSAttributedString{
    let style = NSMutableParagraphStyle()
    style.lineSpacing = 6
    style.lineBreakMode = .byTruncatingTail
    let attribute = [NSParagraphStyleAttributeName : style]
    
    return NSAttributedString(string: titleText, attributes: attribute)
}


func uniq<S: Sequence, E: Hashable>(_ source: S) -> [E] where E==S.Iterator.Element {
    var seen: [E:Bool] = [:]
    return source.filter({ (v) -> Bool in
        return seen.updateValue(true, forKey: v) == nil
    })
}



func isCheckControllerAlreadyOnNavigationStack(_ views : [UIViewController] , vc : AnyClass) -> Bool
{
    
    for i in 0...views.count - 1   {
        if (views[i].isKind(of: vc))
        {
            return true
        }
        
        
    }
    
    return false
    
}

func paddingLeft(_ textField: UITextField)
{
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: textField.frame.height))
    textField.leftView = paddingView
    textField.leftViewMode = UITextFieldViewMode.always
}

func showAlert(_ title : String, message : String, sender : UIViewController) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    sender.present(alert, animated: true, completion: nil)
}


extension Array {
    func chunk(_ chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map({ (startIndex) -> [Element] in
            let endIndex = (startIndex.advanced(by: chunkSize) > self.count) ? self.count-startIndex : chunkSize
            return Array(self[startIndex..<startIndex.advanced(by: endIndex)])
        })
    }}


func showErrorMessage(error : Int, vc: UIViewController)
{
    if error == -1
    {
        customAlertView(vc, title: getErrorStringConfig(code: String(describing: error))! , btnTitleNameNormal: name_confirm_Button_Normal,titleButton: "OK",  blockCallback: { (result) in
            appDelegate.setRootViewWhenInvalidToken()
        })
    }
    else
    {
        
        customAlertView(vc, title: getErrorStringConfig(code: String(describing: error))! , btnTitleNameNormal: name_confirm_Button_Normal,titleButton: "OK",  blockCallback: { (result) in
        })
        
    }
    
}



func formatDateWithFormat(day: Int, month: Int, year: Int,formatString:String) -> String
{
    
    let morningOfChristmasComponents = NSDateComponents()
    morningOfChristmasComponents.year = year
    morningOfChristmasComponents.month = month
    morningOfChristmasComponents.day = day
    let morningOfChristmas = Calendar.current.date(from: morningOfChristmasComponents as DateComponents)
    let formatter = DateFormatter()
    if MCLocalization.sharedInstance().language == "vi"
    {
        formatter.locale = Locale(identifier: "vi_VN")
    }
    else
    {
        formatter.locale = Locale(identifier: "en_US")
    }
    formatter.dateFormat = formatString
   
    let dateString = formatter.string(from: morningOfChristmas!)
    let fullDate = (morningOfChristmas?.dayOfWeekFullOrder())! + ", " + dateString
    return fullDate
}

func formatTimeWithFormat(min: Int, hour: Int,formatString:String) -> String
{
    let morningOfChristmasComponents = NSDateComponents()
    morningOfChristmasComponents.minute = min
    morningOfChristmasComponents.hour = hour
    let morningOfChristmas = Calendar.current.date(from: morningOfChristmasComponents as DateComponents)
    let formatter = DateFormatter()
    formatter.dateFormat =  formatString
    formatter.amSymbol = "AM"
    formatter.pmSymbol = "PM"
    let timeString = formatter.string(from: morningOfChristmas!)
    return timeString
}
func isValidEmail(testStr:String) -> Bool {
    // print("validate calendar: \(testStr)")
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}
func setCommaforNumber(_ value: Int) -> String
{
    let fomartter = NumberFormatter()
    fomartter.numberStyle = NumberFormatter.Style.decimal
    
    let strTotal = fomartter.string(from: NSNumber(integerLiteral:value))!
    let result = strTotal.characters.split(separator: ",").joined(separator: ["."])
    return String(result)
    
}

func customAlertView(_ vc: UIViewController, title: String, btnTitleNameNormal: String, titleButton: String,blockCallback: @escaping callBack)
{
    let myAlert: AlertViewController = pickUpStoryBoard.instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
    myAlert.titleMessage = title
    myAlert.btnimageName = btnTitleNameNormal
    myAlert.titleButton = titleButton
    myAlert.blockCallBack = blockCallback
    myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
    myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    vc.present(myAlert, animated: false, completion: nil)
}


func showTutorial(_ vc: UIViewController,imageName:String)
{
    let myAlert = pickUpStoryBoard.instantiateViewController(withIdentifier: "TurtorioFirstViewController") as! TurtorioFirstViewController
    myAlert.imageName = imageName
    myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
    myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    vc.present(myAlert, animated: false, completion: nil)
}



func customAlertViewWithCancelButtonWithCloseButton(_ vc: UIViewController, title: String, btnTitleNameNormal: String, btnCancelNameNormal: String,titleOrangeButton:String, titleGreyButton: String ,isClose:Bool, blockCallback: @escaping callBack, blockCallbackCancel: @escaping callBack,blockCallbackClose: @escaping callBack)
{
    let myAlert = pickUpStoryBoard.instantiateViewController(withIdentifier: "AlertWithCancelButtonViewController") as! AlertWithCancelButtonViewController
    myAlert.titleMessage = title
    myAlert.btnimageName = btnTitleNameNormal
    myAlert.btnimageNameCancel = btnCancelNameNormal
    myAlert.titleOrangeButton = titleOrangeButton
    myAlert.titleGreyButton = titleGreyButton
    myAlert.blockCallBack = blockCallback
    myAlert.blockCallBackCancel = blockCallbackCancel
    myAlert.blockCallBackClose = blockCallbackClose
    myAlert.isCLoseButton = isClose
    myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
    myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    vc.present(myAlert, animated: false, completion: nil)
}

func customAlertViewWithCancelButton(_ vc: UIViewController, title: String, btnTitleNameNormal: String, btnCancelNameNormal: String,titleOrangeButton:String, titleGreyButton: String ,isClose:Bool, blockCallback: @escaping callBack, blockCallbackCancel: @escaping callBack)
{
    let myAlert = pickUpStoryBoard.instantiateViewController(withIdentifier: "AlertWithCancelButtonViewController") as! AlertWithCancelButtonViewController
    myAlert.titleMessage = title
    myAlert.btnimageName = btnTitleNameNormal
    myAlert.btnimageNameCancel = btnCancelNameNormal
    myAlert.titleOrangeButton = titleOrangeButton
    myAlert.titleGreyButton = titleGreyButton
    myAlert.blockCallBack = blockCallback
    myAlert.blockCallBackCancel = blockCallbackCancel
    myAlert.isCLoseButton = isClose
    myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
    myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    vc.present(myAlert, animated: false, completion: nil)
}


func customAlertViewWithTextField(_ vc: UIViewController, typeTextfield : String, title: String, btnTitleNameNormal: String, btnCancelNameNormal: String,titleOrangeButton:String, titleGreyButton: String ,blockCallback: @escaping callBack, blockCallbackCancel: @escaping callBack)
{
    let myAlert = pickUpStoryBoard.instantiateViewController(withIdentifier: "AlertWithTextFieldViewController") as! AlertWithTextFieldViewController
    myAlert.titleMessage = title
    myAlert.btnimageName = btnTitleNameNormal
    myAlert.btnimageNameCancel = btnCancelNameNormal
    myAlert.titleOrangeButton = titleOrangeButton
    myAlert.titleGreyButton = titleGreyButton
    myAlert.blockCallBack = blockCallback
    myAlert.blockCallBackCancel = blockCallbackCancel
    myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
    myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    vc.present(myAlert, animated: false, completion: nil)
}

func connectedToNetwork() -> Bool {
    
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            SCNetworkReachabilityCreateWithAddress(nil, $0)
        }
    }) else {
        return false
    }
    
    var flags: SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
        return false
    }
    
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    
    return (isReachable && !needsConnection)
}
func convertToDictionary(text: String) -> [String: Any]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}


func isNotNull(_ object:AnyObject?) -> Bool {
    guard let object = object else {
        return false
    }
    return (isNotNSNull(object) && isNotStringNull(object))
}
func addDoneButtonOnNumpad(_ textField: UITextField,vc:UIViewController) {
    let keyboardToolbar = UIToolbar()
    keyboardToolbar.sizeToFit()
    let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil, action: nil)
    let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                        target: vc.view, action: #selector(UIView.endEditing(_:)))
    keyboardToolbar.items = [flexBarButton, doneBarButton]
    textField.inputAccessoryView = keyboardToolbar
    
}

func isNotNSNull(_ object:AnyObject) -> Bool {
    return object.classForCoder != NSNull.classForCoder()
}

func isNotStringNull(_ object:AnyObject) -> Bool {
    if let object = object as? String , object.uppercased() == "NULL" {
        return false
    }
    return true
}

func callNumber(_ phoneNumber:String,block: callBack) {
    if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
        if #available(iOS 10, *) {
            UIApplication.shared.open(url)
            block(nil)
        } else {
            UIApplication.shared.openURL(url)
            block(nil)
        }
    }
}
func randomStringWithLength (_ len : Int) -> NSString {
    
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    
    let randomString : NSMutableString = NSMutableString(capacity: len)
    
    for _ in 0 ..< len {
        let length = UInt32 (letters.length)
        let rand = arc4random_uniform(length)
        randomString.appendFormat("%C", letters.character(at: Int(rand)))
    }
    
    return randomString
}

func imageWithImage(_ image:UIImage,size:CGSize) -> UIImage
{
    if (UIScreen.main.responds(to: #selector(NSDecimalNumberBehaviors.scale))) {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
    }
    else
    {
        UIGraphicsBeginImageContext(size)
    }
    image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage!
}
func imageWithImage (_ image:UIImage, width:CGFloat,height:CGFloat)->UIImage
{
    let oldWidth = image.size.width
    let oldHeight = image.size.height
    let scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight
    let newHeight = oldHeight*scaleFactor
    let newWidth = oldWidth*scaleFactor
    let newSize = CGSize(width: newWidth, height: newHeight)
    return imageWithImage(image, size: newSize)
}

func dismissAllViewController(_ vc: UIViewController)
{
    vc.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
}
func showProgressHub()
{
    if appDelegate.isShowProgress == false
    {
        appDelegate.isShowProgress = true
        let startColor = UIColor(hex: "#fc8301")
        let endColor = UIColor(hex: "#f7bf00")
        KRProgressHUD.set(activityIndicatorStyle: .color(startColor, endColor))
        KRProgressHUD.show()
    }

}

func hideProgressHub()
{
    if appDelegate.isShowProgress == true
    {
        appDelegate.isShowProgress = false
        KRProgressHUD.dismiss()
    }

    
}



func setGradian(bounds: CGRect, colors: [CGColor],startPoint: CGPoint?, endPoint: CGPoint?) -> UIImage
{
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = bounds
    gradientLayer.colors =  colors
    if startPoint != nil && endPoint != nil
    {
        gradientLayer.startPoint = startPoint!
        gradientLayer.endPoint = endPoint!
    }
    UIGraphicsBeginImageContext(gradientLayer.bounds.size)
    gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
    
    
    
    
    
}
func dashedBorderLayerWithColor(color:CGColor,selectView: UIView) -> CAShapeLayer {
    
    let  borderLayer = CAShapeLayer()
    borderLayer.name  = "borderLayer"
    let frameSize = selectView.frame.size
    let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
    borderLayer.bounds=shapeRect
    borderLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
    borderLayer.fillColor = UIColor.clear.cgColor
    borderLayer.strokeColor = color
    borderLayer.lineWidth=1
    borderLayer.lineJoin=kCALineJoinRound
    borderLayer.lineDashPattern = NSArray(array: [NSNumber(value: 8),NSNumber(value:4)]) as? [NSNumber]
    
    let path = UIBezierPath.init(roundedRect: shapeRect, cornerRadius: 0)
    
    borderLayer.path = path.cgPath
    
    return borderLayer
    
}
func getTotalDayinMonth(month: Int, year: Int) -> Int
{
    let dateComponents = DateComponents(year: year, month: month)
    let calendar = Calendar.current
    let date = calendar.date(from: dateComponents)!
    
    let range = calendar.range(of: .day, in: .month, for: date)!
    return range.count
}
func loginToZone()
{
    let param = SFSObject.newInstance()
    param?.putInt("type", value: kUserRole)
    param?.putUtfString("deviceid", value: deviceID())
    param?.putUtfString("devicetoken", value: defaults.value(forKey: "deviceToken") as! String)
    param?.putUtfString("token", value: token_API)
    param?.putUtfString("version", value: kVersion)
    param?.putUtfString("country_code", value: kCountryCode)
    param?.putUtfString("os", value: "IOS")
    SmartFoxObject.sharedInstance.login(userPhone_API, password: "", zone: kzoneSmartfox, params: param!)
}
func calculateDistanse(_ listPoint:[PointLocation])->Double
{
    var sum = 0.0
    for item in (listPoint.enumerated()) {
        sum = sum + item.element.distance
    }
    return sum
}


func getFileURL(fileName: String) -> NSURL {
    let documents = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    return documents.appendingPathComponent(fileName) as NSURL
    
    
}
func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        completion()
    }
}
func getErrorStringConfig(code: String) -> String?
{
    var arrayDicConfig : [NSDictionary] = []
    
    if MCLocalization.sharedInstance().language == "en"
    {
        arrayDicConfig = NSKeyedUnarchiver.unarchiveObject(withFile: filePathEnglish) as! [NSDictionary]
        
    }
    else if MCLocalization.sharedInstance().language == "vi"
    {
        arrayDicConfig = NSKeyedUnarchiver.unarchiveObject(withFile: filePathVietNamese) as! [NSDictionary]
        
    }
    if let result = arrayDicConfig.flatMap({$0[code]}).first{
        return String(describing: result)//->title of the other
    } else {
        return "Missing error code"
    }
}
func maskRoundedImage(image: UIImage, radius: CGFloat) -> UIImage {
    let imageView: UIImageView = UIImageView(image: image)
    var layer: CALayer = CALayer()
    layer = imageView.layer
    
    layer.masksToBounds = true
    layer.cornerRadius = CGFloat(radius)
    
    UIGraphicsBeginImageContext(imageView.bounds.size)
    layer.render(in: UIGraphicsGetCurrentContext()!)
    let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return roundedImage!
}
func parseOjbectToListJson(list:[JSONSerializable]) -> String
{
    let listJsonArray = NSMutableArray()
    for item in (list.enumerated())
    {
        if let json = item.element.toJSON() {
            listJsonArray.add(convertStringToDictionary(json)!)
        }
    }
    
    return arrayDictToJSON(dictionaryOrArray: listJsonArray)!
}
func convertImageToBase64(image: UIImage) -> String {
    let resizeImage = imageWithImage(image, width: 200, height: 200)
    let imageData = UIImagePNGRepresentation(resizeImage)
    // let imageData = UIImageJPEGRepresentation(resizeImage, 80)
    let base64String = imageData?.base64EncodedString(options: .lineLength64Characters)
    return base64String!
    
}
func convertBase64ToImage(base64String: String) -> UIImage {
    
    let decodedData = Data(base64Encoded: base64String, options: .init(rawValue: 0) )
    
    let decodedimage = UIImage(data: decodedData!)
    
    return decodedimage!
    
}// end conve

func getFirstDayOfMonth() ->  Date
{
    let components = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date()))!
    return components
}
func arrayDictToJSON(dictionaryOrArray:AnyObject) -> String?
{
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: dictionaryOrArray, options: JSONSerialization.WritingOptions.prettyPrinted)
        return String(data: jsonData, encoding: String.Encoding.utf8)
    } catch {
        print("parse Json Error")
        return nil
    }
}

extension Date
{
    
    func dateAt(hours: Int, minutes: Int) -> Date
    {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        
        //get the month/day/year componentsfor today's date.
        
        
        var date_components = calendar.components(
            [NSCalendar.Unit.year,
             NSCalendar.Unit.month,
             NSCalendar.Unit.day],
            from: self)
        
        //Create an NSDate for the specified time today.
        date_components.hour = hours
        date_components.minute = minutes
        date_components.second = 0
        
        let newDate = calendar.date(from: date_components)!
        return newDate
    }
}

func tracking(actionKey: String)
{

    DataConnect.sendTracking(token_API, country_code: kCountryCode, phone: userPhone_API, action: actionKey, onsuccess: { (result) in
    }) { (error) in
    }
    
}

extension String {
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound - r.lowerBound)
        return self[Range(start ..< end)]
    }
}
extension String {
    
    // formatting text for currency textField
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        if #available(iOS 9.0, *) {
            formatter.numberStyle = .currencyAccounting
        } else {
            // Fallback on earlier versions
        }
        formatter.currencySymbol = "VND"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
}
func loadDataByGCD(url: URL, onsuccess : @escaping callBack) {
    var data: Data? = nil
    
    DispatchQueue.global().async {
        do {
            try data = Data(contentsOf: url)
        } catch {
            print("Failed")
        }
        DispatchQueue.main.async(execute: {
            if data != nil {
                onsuccess(data as AnyObject)
            }
            else
            {
                onsuccess(nil)
            }
        })
    }
}



func getCountryPhonceCode (_ country : String) -> String
{
    var countryDictionary  = ["AF":"93",
                              "AL":"355",
                              "DZ":"213",
                              "AS":"1",
                              "AD":"376",
                              "AO":"244",
                              "AI":"1",
                              "AG":"1",
                              "AR":"54",
                              "AM":"374",
                              "AW":"297",
                              "AU":"61",
                              "AT":"43",
                              "AZ":"994",
                              "BS":"1",
                              "BH":"973",
                              "BD":"880",
                              "BB":"1",
                              "BY":"375",
                              "BE":"32",
                              "BZ":"501",
                              "BJ":"229",
                              "BM":"1",
                              "BT":"975",
                              "BA":"387",
                              "BW":"267",
                              "BR":"55",
                              "IO":"246",
                              "BG":"359",
                              "BF":"226",
                              "BI":"257",
                              "KH":"855",
                              "CM":"237",
                              "CA":"1",
                              "CV":"238",
                              "KY":"345",
                              "CF":"236",
                              "TD":"235",
                              "CL":"56",
                              "CN":"86",
                              "CX":"61",
                              "CO":"57",
                              "KM":"269",
                              "CG":"242",
                              "CK":"682",
                              "CR":"506",
                              "HR":"385",
                              "CU":"53",
                              "CY":"537",
                              "CZ":"420",
                              "DK":"45",
                              "DJ":"253",
                              "DM":"1",
                              "DO":"1",
                              "EC":"593",
                              "EG":"20",
                              "SV":"503",
                              "GQ":"240",
                              "ER":"291",
                              "EE":"372",
                              "ET":"251",
                              "FO":"298",
                              "FJ":"679",
                              "FI":"358",
                              "FR":"33",
                              "GF":"594",
                              "PF":"689",
                              "GA":"241",
                              "GM":"220",
                              "GE":"995",
                              "DE":"49",
                              "GH":"233",
                              "GI":"350",
                              "GR":"30",
                              "GL":"299",
                              "GD":"1",
                              "GP":"590",
                              "GU":"1",
                              "GT":"502",
                              "GN":"224",
                              "GW":"245",
                              "GY":"595",
                              "HT":"509",
                              "HN":"504",
                              "HU":"36",
                              "IS":"354",
                              "IN":"91",
                              "ID":"62",
                              "IQ":"964",
                              "IE":"353",
                              "IL":"972",
                              "IT":"39",
                              "JM":"1",
                              "JP":"81",
                              "JO":"962",
                              "KZ":"77",
                              "KE":"254",
                              "KI":"686",
                              "KW":"965",
                              "KG":"996",
                              "LV":"371",
                              "LB":"961",
                              "LS":"266",
                              "LR":"231",
                              "LI":"423",
                              "LT":"370",
                              "LU":"352",
                              "MG":"261",
                              "MW":"265",
                              "MY":"60",
                              "MV":"960",
                              "ML":"223",
                              "MT":"356",
                              "MH":"692",
                              "MQ":"596",
                              "MR":"222",
                              "MU":"230",
                              "YT":"262",
                              "MX":"52",
                              "MC":"377",
                              "MN":"976",
                              "ME":"382",
                              "MS":"1",
                              "MA":"212",
                              "MM":"95",
                              "NA":"264",
                              "NR":"674",
                              "NP":"977",
                              "NL":"31",
                              "AN":"599",
                              "NC":"687",
                              "NZ":"64",
                              "NI":"505",
                              "NE":"227",
                              "NG":"234",
                              "NU":"683",
                              "NF":"672",
                              "MP":"1",
                              "NO":"47",
                              "OM":"968",
                              "PK":"92",
                              "PW":"680",
                              "PA":"507",
                              "PG":"675",
                              "PY":"595",
                              "PE":"51",
                              "PH":"63",
                              "PL":"48",
                              "PT":"351",
                              "PR":"1",
                              "QA":"974",
                              "RO":"40",
                              "RW":"250",
                              "WS":"685",
                              "SM":"378",
                              "SA":"966",
                              "SN":"221",
                              "RS":"381",
                              "SC":"248",
                              "SL":"232",
                              "SG":"65",
                              "SK":"421",
                              "SI":"386",
                              "SB":"677",
                              "ZA":"27",
                              "GS":"500",
                              "ES":"34",
                              "LK":"94",
                              "SD":"249",
                              "SR":"597",
                              "SZ":"268",
                              "SE":"46",
                              "CH":"41",
                              "TJ":"992",
                              "TH":"66",
                              "TG":"228",
                              "TK":"690",
                              "TO":"676",
                              "TT":"1",
                              "TN":"216",
                              "TR":"90",
                              "TM":"993",
                              "TC":"1",
                              "TV":"688",
                              "UG":"256",
                              "UA":"380",
                              "AE":"971",
                              "GB":"44",
                              "US":"1",
                              "UY":"598",
                              "UZ":"998",
                              "VU":"678",
                              "WF":"681",
                              "YE":"967",
                              "ZM":"260",
                              "ZW":"263",
                              "BO":"591",
                              "BN":"673",
                              "CC":"61",
                              "CD":"243",
                              "CI":"225",
                              "FK":"500",
                              "GG":"44",
                              "VA":"379",
                              "HK":"852",
                              "IR":"98",
                              "IM":"44",
                              "JE":"44",
                              "KP":"850",
                              "KR":"82",
                              "LA":"856",
                              "LY":"218",
                              "MO":"853",
                              "MK":"389",
                              "FM":"691",
                              "MD":"373",
                              "MZ":"258",
                              "PS":"970",
                              "PN":"872",
                              "RE":"262",
                              "RU":"7",
                              "BL":"590",
                              "SH":"290",
                              "KN":"1",
                              "LC":"1",
                              "MF":"590",
                              "PM":"508",
                              "VC":"1",
                              "ST":"239",
                              "SO":"252",
                              "SJ":"47",
                              "SY":"963",
                              "TW":"886",
                              "TZ":"255",
                              "TL":"670",
                              "VE":"58",
                              "VN":"84",
                              "VG":"284",
                              "VI":"340"]
    if countryDictionary[country] != nil {
        return countryDictionary[country]!
    }
        
    else {
        return ""
    }
    
}

func changeFormatTime(timeString: String,oldFormat: String, newFormat: String) -> String
{
    let dateFormatter = DateFormatter()
    if MCLocalization.sharedInstance().language == "vi"
    {
        dateFormatter.locale = Locale(identifier: "vi_VN")
    }
    else
    {
        dateFormatter.locale = Locale(identifier: "en_US")
    }
    dateFormatter.dateFormat = oldFormat
    let date = dateFormatter.date(from: timeString)!
    dateFormatter.dateFormat = newFormat
    dateFormatter.amSymbol = "AM"
    dateFormatter.pmSymbol = "PM"
    return dateFormatter.string(from: date)
}

extension UIImage {
    
    class func dottedLine(radius: CGFloat, space: CGFloat, numberOfPattern: CGFloat) -> UIImage {
        
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: radius/2, y: radius/2))
        path.addLine(to: CGPoint(x: (numberOfPattern)*(space+1)*radius, y: radius/2))
        path.lineWidth = radius
        
        let dashes: [CGFloat] = [path.lineWidth * 0, path.lineWidth * (space+1)]
        path.setLineDash(dashes, count: dashes.count, phase: 0)
        path.lineCapStyle = CGLineCap.round
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: (numberOfPattern)*(space+1)*radius, height: radius), false, 1)
        UIColor.black.setStroke()
        path.stroke()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
        
    }
}
