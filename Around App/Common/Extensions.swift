//
//  Extensions.swift
//  Soroeru
//
//  Created by Taha Doğan Güneş on 03/08/15.
//  Copyright (c) 2015 Suncomed. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
extension String {
    var length: Int {
        return self.characters.count
    }  // Swift 1.2
}

extension UIView {
    
    func setRound() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    func setShadowBorder() {
        self.layer.masksToBounds = false
        // self.clipsToBounds = true
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 3
        self.layer.borderWidth = 3
    }
    
}
extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}
extension UIView {
    func applyCircleShadow(shadowRadius: CGFloat = 2,
                           shadowOpacity: Float = 1,
                           shadowColor: CGColor = UIColor.black.cgColor,
                           shadowOffset: CGSize = CGSize.zero) {
        layer.cornerRadius = frame.size.height / 2
        layer.masksToBounds = false
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
    }
}
extension UIImageView {
    override func applyCircleShadow(shadowRadius: CGFloat = 2,
                                    shadowOpacity: Float = 1,
                                    shadowColor: CGColor = UIColor.black.cgColor,
                                    shadowOffset: CGSize = CGSize.zero) {
        
        // Use UIImageView.hashvalue as background view tag (should be unique)
        let background: UIView = superview?.viewWithTag(hashValue) ?? UIView()
        background.frame = frame
        background.backgroundColor = backgroundColor
        background.tag = hashValue
        background.applyCircleShadow(shadowRadius: shadowRadius, shadowOpacity: shadowOpacity, shadowColor: shadowColor, shadowOffset: shadowOffset)
        layer.cornerRadius = background.layer.cornerRadius
        layer.masksToBounds = true
        superview?.insertSubview(background, belowSubview: self)
    }
}
extension Float {
    func roundToInt() -> Int{
        let value = Int(self)
        let f = self - Float(value)
        if f < 0.5{
            return value
        } else {
            return value + 1
        }
    }
}
extension UIImage {
    
    func circularImage(size: CGSize?) -> UIImage {
        let newSize = size ?? self.size
        
        let minEdge = min(newSize.height, newSize.width)
        let size = CGSize(width: minEdge, height: minEdge)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        
        self.draw(in: CGRect(origin: CGPoint.zero, size: size), blendMode: .copy, alpha: 1.0)
        
        context!.setBlendMode(.copy)
        context!.setFillColor(UIColor.clear.cgColor)
        
        let rectPath = UIBezierPath(rect: CGRect(origin: CGPoint.zero, size: size))
        let circlePath = UIBezierPath(ovalIn: CGRect(origin: CGPoint.zero, size: size))
        rectPath.append(circlePath)
        rectPath.usesEvenOddFillRule = true
        rectPath.fill()
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result!
    }
    
}
extension UIImage {
    var isPortrait:  Bool    { return size.height > size.width }
    var isLandscape: Bool    { return size.width > size.height }
    var breadth:     CGFloat { return min(size.width, size.height) }
    var breadthSize: CGSize  { return CGSize(width: breadth, height: breadth) }
    var breadthRect: CGRect  { return CGRect(origin: .zero, size: breadthSize) }
    var circleMasked: UIImage? {
        UIGraphicsBeginImageContextWithOptions(breadthSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        guard let cgImage = cgImage?.cropping(to: CGRect(origin: CGPoint(x: isLandscape ? floor((size.width - size.height) / 2) : 0, y: isPortrait  ? floor((size.height - size.width) / 2) : 0), size: breadthSize)) else { return nil }
        UIBezierPath(ovalIn: breadthRect).addClip()
        UIImage(cgImage: cgImage).draw(in: breadthRect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
extension String {
    
    func contains(_ find: String) -> Bool{
        return self.range(of: find) != nil
    }
    
    /// Truncates the string to length number of characters and
    /// appends optional trailing string if longer
    func truncate(_ length: Int, trailing: String? = "...") -> String {
        if self.characters.count > length {
            return self.substring(to: self.characters.index(self.startIndex, offsetBy: length)) + (trailing ?? "")
        } else {
            return self
        }
    }
}

extension UIView {
    @IBInspectable var borderColor: UIColor? {
        get { return layer.borderColor.map(UIColor.init) }
        set { layer.borderColor = newValue?.cgColor }
    }
    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            
            // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
            if shadow == false {
                self.layer.masksToBounds = true
            }
        }
    }
    
    
    func addShadow(shadowColor: CGColor = UIColor.black.cgColor,
                   shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0),
                   shadowOpacity: Float = 0.3,
                   shadowRadius: CGFloat = 3.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
}
extension CAGradientLayer {
    class func gradientLayerForBounds(bounds: CGRect, colors: [CGColor],startPoint: CGPoint?, endPoint: CGPoint?) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = bounds
        layer.colors = colors
        if startPoint != nil && endPoint != nil
        {
            layer.startPoint = startPoint!
            layer.endPoint = endPoint!
        }
        return layer
        
    }
}
extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
extension String
{
    func fromBase64() -> String
    {
        let data = Data(base64Encoded: self, options: NSData.Base64DecodingOptions(rawValue: 0))
        return String(data: data!, encoding: String.Encoding.utf8)!
    }
    
    func toBase64() -> String
    {
        let data = self.data(using: String.Encoding.utf8)
        return data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
    }
}

func -(left: Timestamp, right: Timestamp) -> Double {
    return left.value - right.value
}

struct Timestamp {
    let value:Double
    init() {
        self.value = Double(CACurrentMediaTime())
    }
    
    
}


extension NSObject{
    convenience init(jsonStr:String) {
        self.init()
        
        if let jsonData = jsonStr.data(using: String.Encoding.utf8, allowLossyConversion: false)
        {
            do {
                let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: AnyObject]
                
                // Loop
                for (key, value) in json {
                    let keyName = key as String
                    let keyValue: String = value as! String
                    
                    // If property exists
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.setValue(keyValue, forKey: keyName)
                    }
                }
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        else
        {
            print("json is of wrong format!")
        }
    }
}

extension CALayer {
    func pause() {
        if self.isPaused() == false {
            let pausedTime: CFTimeInterval = self.convertTime(CACurrentMediaTime(), from: nil)
            self.speed = 0.0
            self.timeOffset = pausedTime
        }
    }
    
    func isPaused() -> Bool {
        return self.speed == 0.0
    }
    
    func resume() {
        let pausedTime: CFTimeInterval = self.timeOffset
        self.speed = 1.0
        self.timeOffset = 0.0
        self.beginTime = 0.0
        let timeSincePause: CFTimeInterval = self.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        self.beginTime = timeSincePause
    }
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UITextField {
    func setLeftIcon(image: UIImage,size : CGSize) {
        self.leftViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        self.leftView = imageView
    }
    func removeLeftIcon()
    {
        self.leftViewMode = .always
        let imageArrow = UIImageView(frame: CGRect(x: 0, y: 0, width: 16, height: 20))
        imageArrow.image = UIImage()
        self.leftView = imageArrow
    }
    
    func removeRightIcon()
    {
        self.rightViewMode = .always
        let imageArrow = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        imageArrow.image = UIImage()
        self.rightView = imageArrow
    }
    
    
    func insertImageLeft(image: UIImage,size: CGSize)
    {
        self.leftViewMode = .always
        let imageArrow = UIImageView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        imageArrow.contentMode = .scaleAspectFit
        imageArrow.image = image
        self.leftView = imageArrow
    }
    
    
    func insertImageRight(image: UIImage,size: CGSize)
    {
        self.rightViewMode = .always
        let imageArrow = UIImageView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        imageArrow.image = image
        imageArrow.contentMode = .scaleAspectFit
        self.rightView = imageArrow
    }
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//        if self.keyboardType == .numberPad
//        {
//            if action == #selector(copy(_:)) || action == #selector(cut(_:)) || action == #selector(selectAll(_:))   {
//                return true
//            }
//        }
//        else
//        {
//            if action == #selector(copy(_:)) || action == #selector(paste(_:)) || action == #selector(cut(_:)) || action == #selector(selectAll(_:))   {
//                return true
//            }
//          
//        }
        
        if action == #selector(copy(_:)) || action == #selector(paste(_:)) || action == #selector(cut(_:)) || action == #selector(selectAll(_:))   {
            return true
        }
        return false
    }
}


extension UILabel {
    
    func countLabelLines() -> Int {
        // Call self.layoutIfNeeded() if your view is uses auto layout
        let myText = self.text! as NSString
        let attributes = [NSFontAttributeName : self.font]
        
        let labelSize = myText.boundingRect(with: CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil)
        return Int(ceil(CGFloat(labelSize.height) / self.font.lineHeight))
    }
    
    func isTruncated() -> Bool {
        
        if (self.countLabelLines() > self.numberOfLines) {
            return true
        }
        return false
    }
}

struct Number {
    static let formatterWithSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = "."
        formatter.numberStyle = .decimal
        return formatter
    }()
}
extension String {
    
    //To check text field or String is blank or not
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
    
    //Validate Email
    
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    //validate Password
    var isValidPassword: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z_0-9\\-_,;.:#+*?=!§$%&/()@]+$", options: .caseInsensitive)
            if(regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil){
                
                if(self.characters.count>=6 && self.characters.count<=20){
                    return true
                }else{
                    return false
                }
            }else{
                return false
            }
        } catch {
            return false
        }
    }
}
extension Integer {
    var stringFormattedWithSeparator: String {
        return Number.formatterWithSeparator.string(from: self as! NSNumber) ?? ""
    }
}
extension String  {
    var isNumber : Bool {
        get{
            return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        }
    }
}
extension UIViewController {
    func topMostViewController() -> UIViewController {
        // Handling Modal views
        if let presentedViewController = self.presentedViewController {
            return presentedViewController.topMostViewController()
        }
            // Handling UIViewController's added as subviews to some other views.
        else {
            for view in self.view.subviews
            {
                // Key property which most of us are unaware of / rarely use.
                if let subViewController = view.next {
                    if subViewController is UIViewController {
                        let viewController = subViewController as! UIViewController
                        return viewController.topMostViewController()
                    }
                }
            }
            return self
        }
    }
}
private let characterEntities : [ String : Character ] = [
    // XML predefined entities:
    "&quot;"    : "\"",
    "&amp;"     : "&",
    "&apos;"    : "'",
    "&lt;"      : "<",
    "&gt;"      : ">",
    "\u{e2}"    : " ",
    // HTML character entity references:
    "&nbsp;"    : "\u{00a0}",
    // ...
    "&diams;"   : "♦",
]
extension String {
    
    init?(htmlEncodedString: String) {
        
        guard let data = htmlEncodedString.data(using: .utf8) else {
            return nil
        }
        
        let options: [String: Any] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return nil
        }
        
        self.init(attributedString.string)
    }
    
}

extension String {
    
    /// Returns a new string made by replacing in the `String`
    /// all HTML character entity references with the corresponding
    /// character.
    var stringByDecodingHTMLEntities : String {
        
        // ===== Utility functions =====
        
        // Convert the number in the string to the corresponding
        // Unicode character, e.g.
        //    decodeNumeric("64", 10)   --> "@"
        //    decodeNumeric("20ac", 16) --> "€"
        func decodeNumeric(_ string : String, base : Int) -> Character? {
            guard let code = UInt32(string, radix: base),
                let uniScalar = UnicodeScalar(code) else { return nil }
            return Character(uniScalar)
        }
        
        // Decode the HTML character entity to the corresponding
        // Unicode character, return `nil` for invalid input.
        //     decode("&#64;")    --> "@"
        //     decode("&#x20ac;") --> "€"
        //     decode("&lt;")     --> "<"
        //     decode("&foo;")    --> nil
        func decode(_ entity : String) -> Character? {
            
            if entity.hasPrefix("&#x") || entity.hasPrefix("&#X"){
                return decodeNumeric(entity.substring(with: entity.index(entity.startIndex, offsetBy: 3) ..< entity.index(entity.endIndex, offsetBy: -1)), base: 16)
            } else if entity.hasPrefix("&#") {
                return decodeNumeric(entity.substring(with: entity.index(entity.startIndex, offsetBy: 2) ..< entity.index(entity.endIndex, offsetBy: -1)), base: 10)
            } else {
                return characterEntities[entity]
            }
        }
        
        // ===== Method starts here =====
        
        var result = ""
        var position = startIndex
        
        // Find the next '&' and copy the characters preceding it to `result`:
        while let ampRange = self.range(of: "&", range: position ..< endIndex) {
            result.append(self[position ..< ampRange.lowerBound])
            position = ampRange.lowerBound
            
            // Find the next ';' and copy everything from '&' to ';' into `entity`
            if let semiRange = self.range(of: ";", range: position ..< endIndex) {
                let entity = self[position ..< semiRange.upperBound]
                position = semiRange.upperBound
                
                if let decoded = decode(entity) {
                    // Replace by decoded character:
                    result.append(decoded)
                } else {
                    // Invalid entity, copy verbatim:
                    result.append(entity)
                }
            } else {
                // No matching ';'.
                break
            }
        }
        // Copy remaining characters to `result`:
        result.append(self[position ..< endIndex])
        return result
    }
}

extension UISegmentedControl {
    func removeBorders() {
        setBackgroundImage(imageWithColor(color: backgroundColor!), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: tintColor!), for: .selected, barMetrics: .default)
        setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    // create a 1x1 image with this color
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
}
extension Array where Element: Equatable {
    
    public func uniq() -> [Element] {
        var arrayCopy = self
        arrayCopy.uniqInPlace()
        return arrayCopy
    }
    
    mutating public func uniqInPlace() {
        var seen = [Element]()
        var index = 0
        for element in self {
            if seen.contains(element) {
                remove(at: index)
            } else {
                seen.append(element)
                index += 1
            }
        }
    }
}



extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
}

extension String {
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func substring(_ from: Int) -> String {
        return self.substring(from: self.characters.index(self.startIndex, offsetBy: from))
    }
    
    
}

extension UIColor {
    
    convenience init(hex: String) {
        self.init(hex: hex, alpha:1)
    }
    
    convenience init(hex: String, alpha: CGFloat) {
        var hexWithoutSymbol = hex
        if hexWithoutSymbol.hasPrefix("#") {
            hexWithoutSymbol = hex.substring(1)
        }
        
        let scanner = Scanner(string: hexWithoutSymbol)
        var hexInt:UInt32 = 0x0
        scanner.scanHexInt32(&hexInt)
        
        var r:UInt32!, g:UInt32!, b:UInt32!
        switch (hexWithoutSymbol.length) {
        case 3: // #RGB
            r = ((hexInt >> 4) & 0xf0 | (hexInt >> 8) & 0x0f)
            g = ((hexInt >> 0) & 0xf0 | (hexInt >> 4) & 0x0f)
            b = ((hexInt << 4) & 0xf0 | hexInt & 0x0f)
            break;
        case 6: // #RRGGBB
            r = (hexInt >> 16) & 0xff
            g = (hexInt >> 8) & 0xff
            b = hexInt & 0xff
            break;
        default:
            // TODO:ERROR
            break;
        }
        
        self.init(
            red: (CGFloat(r)/255),
            green: (CGFloat(g)/255),
            blue: (CGFloat(b)/255),
            alpha:alpha)
    }
}


extension NSLayoutConstraint {
    
    func setMultiplier(_ multiplier:CGFloat) -> NSLayoutConstraint {
        
        let newConstraint = NSLayoutConstraint(
            item: firstItem,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        newConstraint.isActive = true
        
        NSLayoutConstraint.deactivate([self])
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}
extension NSDate {
    var month: Int {
        return NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!.component(.month, from: self as Date)
    }
    var year: Int {
        return NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!.component(.month, from: self as Date)
    }
}
extension UIImageView {
    
    public func sd_setImageWithURLWithFade(_ url: URL?, placeholderImage placeholder: UIImage!)
    {
        // refreshCached
        
        self.sd_setImage(with: url  , placeholderImage: placeholder,
                         options: [.continueInBackground, .lowPriority]){ (image, error, cacheType, url) in
                            if let downLoadedImage = image
                            {
                                if cacheType == .none
                                {
                                    self.alpha = 0
                                    UIView.transition(with: self, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve, animations: { () -> Void in
                                        self.image = downLoadedImage
                                        self.alpha = 1
                                    }, completion: nil)
                                    
                                }
                            }
                            
                            
        }
    }
    
}
extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}


extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        if MCLocalization.sharedInstance().language == "vi"
        {
            dateFormatter.locale = Locale(identifier: "vi_VN")
        }
        else
        {
            dateFormatter.locale = Locale(identifier: "en_US")
        }
        return dateFormatter.string(from: self).capitalized
        // or capitalized(with: locale)
    }
    func dayOfWeekFullOrder() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        if MCLocalization.sharedInstance().language == "vi"
        {
            dateFormatter.locale = Locale(identifier: "vi_VN")
        }
        else
        {
            dateFormatter.locale = Locale(identifier: "en_US")
        }
        return dateFormatter.string(from: self).capitalized
        // or capitalized(with: locale)
    }
}



// Month Name
extension Date {
    func monthName() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        if MCLocalization.sharedInstance().language == "vi"
        {
            dateFormatter.locale = Locale(identifier: "vi_VN")
        }
        else
        {
            dateFormatter.locale = Locale(identifier: "en_US")
        }
        return dateFormatter.string(from: self).capitalized
        // or capitalized(with: locale)
    }
}

extension Date {
    func yearName() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        if MCLocalization.sharedInstance().language == "vi"
        {
            dateFormatter.locale = Locale(identifier: "vi_VN")
        }
        else
        {
            dateFormatter.locale = Locale(identifier: "en_US")
        }
        return dateFormatter.string(from: self).capitalized
        // or capitalized(with: locale)
    }
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}
public extension Array {
    mutating func swap(ind1: Int, _ ind2: Int){
        var temp: Element
        temp = self[ind1]
        self[ind1] = self[ind2]
        self[ind2] = temp
    }
}
extension Date {
    func getNextMonth() -> Date?{
        return Calendar.current.date(byAdding: DateComponents(month: 1), to: self)!
    }
    
    func getPreviousMonth() -> Date?{
        return Calendar.current.date(byAdding: DateComponents(month: -1), to: self)!
    }
}
extension UICollectionView {
    func reloadData(completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
        { _ in completion() }
    }
}
extension UITableView {
    func reloadData(completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
        { _ in completion() }
    }
}
private var kAssociationKeyNextField: UInt8 = 0

extension UITextField {
    @IBOutlet var nextField: UITextField? {
        get {
            return objc_getAssociatedObject(self, &kAssociationKeyNextField) as? UITextField
        }
        set(newField) {
            objc_setAssociatedObject(self, &kAssociationKeyNextField, newField, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

extension DispatchQueue {
    
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
    
}
extension UILabel {
    public var substituteFontName : String {
        get {
            return self.font.fontName;
        }
        set {
            let fontNameToTest = self.font.fontName.lowercased();
            var fontName = newValue;
            if fontNameToTest.range(of: "bold") != nil {
                fontName += "-Bold";
            } else if fontNameToTest.range(of: "medium") != nil {
                fontName += "-Medium";
            } else if fontNameToTest.range(of: "light") != nil {
                fontName += "-Light";
            } else if fontNameToTest.range(of: "ultralight") != nil {
                fontName += "-UltraLight";
            }
            else if fontNameToTest.range(of: ".sfuitext") != nil {
                fontName += "-Regular";
            }
            else if fontNameToTest.range(of: ".sfuitext-semibold") != nil {
                fontName += "-Bold";
            }
            self.font = UIFont(name: "OpenSans-Bold", size: self.font.pointSize)
        }
    }
}

extension UITextView {
    public var substituteFontName : String {
        get {
            return self.font?.fontName ?? "";
        }
        set {
            let fontNameToTest = self.font?.fontName.lowercased() ?? "";
            var fontName = newValue;
            if fontNameToTest.range(of: "bold") != nil {
                fontName += "-Bold";
            } else if fontNameToTest.range(of: "medium") != nil {
                fontName += "-Medium";
            } else if fontNameToTest.range(of: "light") != nil {
                fontName += "-Light";
            } else if fontNameToTest.range(of: "ultralight") != nil {
                fontName += "-UltraLight";
            }
            else if fontNameToTest.range(of: ".sfuitext") != nil {
                fontName += "-Regular";
            }
            else if fontNameToTest.range(of: ".sfuitext-semibold") != nil {
                fontName += "-Bold";
            }
            
            self.font = UIFont(name: fontName, size: self.font?.pointSize ?? 17)
        }
    }
}

extension UITextField {
    public var substituteFontName : String {
        get {
            return self.font?.fontName ?? "";
        }
        set {
            let fontNameToTest = self.font?.fontName.lowercased() ?? "";
            var fontName = newValue;
            if fontNameToTest.range(of: "bold") != nil {
                fontName += "-Bold";
            } else if fontNameToTest.range(of: "medium") != nil {
                fontName += "-Medium";
            } else if fontNameToTest.range(of: "light") != nil {
                fontName += "-Light";
            } else if fontNameToTest.range(of: "ultralight") != nil {
                fontName += "-UltraLight";
            }
            else if fontNameToTest.range(of: ".sfuitext") != nil {
                fontName += "-Regular";
            }
            else if fontNameToTest.range(of: ".sfuitext-semibold") != nil {
                fontName += "-Bold";
            }
            
            self.font = UIFont(name: fontName, size: self.font?.pointSize ?? 17)
        }
    }
}
// localize
extension UITextField {
    
    @IBInspectable var localizedPlaceholder: String {
        get { return "" }
        set {
            self.placeholder = MCLocalization.string(forKey: newValue)
        }
    }
    
    @IBInspectable var localizedText: String {
        get { return "" }
        set {
            self.text = MCLocalization.string(forKey: newValue)
        }
    }
}


extension UITextView {
    
    @IBInspectable var localizedText: String {
        get { return "" }
        set {
            self.text = MCLocalization.string(forKey: newValue)
        }
    }
}

extension UILabel {
    
    @IBInspectable var localizedText: String {
        get { return "" }
        set {
            self.text = MCLocalization.string(forKey: newValue)
        }
    }
}
extension UIBarItem {
    
    @IBInspectable var localizedTitle: String {
        get { return "" }
        set {
            self.title = MCLocalization.string(forKey: newValue)
        }
    }
}

extension UIImageView {
    
    @IBInspectable var localizedTextName: String {
        get { return "" }
        set {
            //self.text = MCLocalization.string(forKey: newValue)
            self.image = UIImage(named: MCLocalization.string(forKey: newValue))
        }
    }
}

extension UINavigationItem {
    
    @IBInspectable var localizedTitle: String {
        get { return "" }
        set {
            self.title = MCLocalization.string(forKey: newValue)
        }
    }
}

extension UIButton {
    
    @IBInspectable var localizedTitle: String {
        get { return "" }
        set {
            self.setTitle(MCLocalization.string(forKey: newValue), for: UIControlState.normal)
        }
    }
    @IBInspectable var localizedImageName: String {
        get { return "" }
        set {
            self.setImage(UIImage(named :MCLocalization.string(forKey: newValue) ), for: UIControlState.normal)
        }
    }
    @IBInspectable var localizedSelectedImageName: String {
        get { return "" }
        set {
            self.setImage(UIImage(named :MCLocalization.string(forKey: newValue) ), for: UIControlState.selected)
        }
    }
}

extension UISearchBar {
    
    @IBInspectable var localizedPrompt: String {
        get { return "" }
        set {
            self.prompt = MCLocalization.string(forKey: newValue)
        }
    }
    
    @IBInspectable var localizedPlaceholder: String {
        get { return "" }
        set {
            self.placeholder = MCLocalization.string(forKey: newValue)
        }
    }
}
extension UISearchBar {
    
    private func getViewElement<T>(type: T.Type) -> T? {
        
        let svs = subviews.flatMap { $0.subviews }
        guard let element = (svs.filter { $0 is T }).first as? T else { return nil }
        return element
    }
    
    func getSearchBarTextField() -> UITextField? {
        
        return getViewElement(type: UITextField.self)
    }
    
    func setTextColor(color: UIColor) {
        
        if let textField = getSearchBarTextField() {
            textField.textColor = color
        }
    }
    
    func setTextFieldColor(color: UIColor) {
        
        if let textField = getViewElement(type: UITextField.self) {
            switch searchBarStyle {
            case .minimal:
                textField.layer.backgroundColor = color.cgColor
                textField.layer.cornerRadius = 6
                
            case .prominent, .default:
                textField.backgroundColor = color
            }
        }
    }
    
    func setPlaceholderTextColor(color: UIColor) {
        
        if let textField = getSearchBarTextField() {
            textField.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: [NSForegroundColorAttributeName: color])
        }
    }
    
    func setTextFieldClearButtonColor(color: UIColor) {
        
        if let textField = getSearchBarTextField() {
            
            let button = textField.value(forKey: "clearButton") as! UIButton
            if let image = button.imageView?.image {
                button.setImage(image.transform(withNewColor: color), for: .normal)
            }
        }
    }
    
    func setSearchImageColor(color: UIColor) {
        
        if let imageView = getSearchBarTextField()?.leftView as? UIImageView {
            imageView.image = imageView.image?.transform(withNewColor: color)
        }
    }
}
extension UIImage {
    
    func transform(withNewColor color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(.normal)
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context.clip(to: rect, mask: cgImage!)
        
        color.setFill()
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
extension UIWindow {
    
    /// Fix for http://stackoverflow.com/a/27153956/849645
    func set(rootViewController newRootViewController: UIViewController, withTransition transition: CATransition? = nil) {
        
        let previousViewController = rootViewController
        
        if let transition = transition {
            // Add the transition
            layer.add(transition, forKey: kCATransition)
        }
        
        rootViewController = newRootViewController
        
        // Update status bar appearance using the new view controllers appearance - animate if needed
        if UIView.areAnimationsEnabled {
            UIView.animate(withDuration: CATransaction.animationDuration()) {
                newRootViewController.setNeedsStatusBarAppearanceUpdate()
            }
        } else {
            newRootViewController.setNeedsStatusBarAppearanceUpdate()
        }
        
        /// The presenting view controllers view doesn't get removed from the window as its currently transistioning and presenting a view controller
        if let transitionViewClass = NSClassFromString("UITransitionView") {
            for subview in subviews where subview.isKind(of: transitionViewClass) {
                subview.removeFromSuperview()
            }
        }
        if let previousViewController = previousViewController {
            // Allow the view controller to be deallocated
            previousViewController.dismiss(animated: false) {
                // Remove the root view in case its still showing
                previousViewController.view.removeFromSuperview()
            }
        }
    }
}
extension UIView {
    func snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
}

extension UIWindow {
    func replaceRootViewControllerWith(_ replacementController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        let snapshotImageView = UIImageView(image: self.snapshot())
        self.addSubview(snapshotImageView)
        
        let dismissCompletion = { () -> Void in // dismiss all modal view controllers
            self.rootViewController = replacementController
            self.bringSubview(toFront: snapshotImageView)
            if animated {
                UIView.animate(withDuration: 0.4, animations: { () -> Void in
                    snapshotImageView.alpha = 0
                }, completion: { (success) -> Void in
                    snapshotImageView.removeFromSuperview()
                    completion?()
                })
            }
            else {
                snapshotImageView.removeFromSuperview()
                completion?()
            }
        }
        if self.rootViewController!.presentedViewController != nil {
            self.rootViewController!.dismiss(animated: false, completion: dismissCompletion)
        }
        else {
            dismissCompletion()
        }
    }
}
extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
    func fadeIn() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}

extension UIViewController {
    func registerForKeyboardDidShowNotification(scrollView: UIScrollView, usingBlock block: ((NSNotification) -> Void)? = nil) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardDidShow, object: nil, queue: nil, using: { (notification) -> Void in
            let userInfo = notification.userInfo!
            let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as AnyObject).cgRectValue.size
            let contentInsets = UIEdgeInsetsMake(scrollView.contentInset.top, scrollView.contentInset.left, keyboardSize.height, scrollView.contentInset.right)
            
            scrollView.isScrollEnabled = true
            scrollView.setContentInsetAndScrollIndicatorInsets(edgeInsets: contentInsets)
            block?(notification as NSNotification)
        })
    }
    
    func registerForKeyboardWillHideNotification(scrollView: UIScrollView, usingBlock block: ((NSNotification) -> Void)? = nil) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: nil, using: { (notification) -> Void in
            let contentInsets = UIEdgeInsetsMake(scrollView.contentInset.top, scrollView.contentInset.left, 0, scrollView.contentInset.right)
            scrollView.setContentInsetAndScrollIndicatorInsets(edgeInsets: contentInsets)
            scrollView.isScrollEnabled = false
            block?(notification as NSNotification)
        })
    }
}

extension UIScrollView {
    func setContentInsetAndScrollIndicatorInsets(edgeInsets: UIEdgeInsets) {
        self.contentInset = edgeInsets
        self.scrollIndicatorInsets = edgeInsets
    }
}
extension Collection where Indices.Iterator.Element == Index {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
extension String {
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSFontAttributeName: font]
        let size = self.size(attributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSFontAttributeName: font]
        let size = self.size(attributes: fontAttributes)
        return size.height
    }
}
extension UIView {
    func addDashedBorder() {
        let color = UIColor.red.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
}
extension UIWindow {
    
    /// Fix for http://stackoverflow.com/a/27153956/849645
    func setRoot(rootViewController newRootViewController: UIViewController, withTransition transition: CATransition? = nil) {
        
        let previousViewController = rootViewController
        
        if let transition = transition {
            // Add the transition
            layer.add(transition, forKey: kCATransition)
        }
        
        rootViewController = newRootViewController
        
        // Update status bar appearance using the new view controllers appearance - animate if needed
        if UIView.areAnimationsEnabled {
            UIView.animate(withDuration: CATransaction.animationDuration()) {
                newRootViewController.setNeedsStatusBarAppearanceUpdate()
            }
        } else {
            newRootViewController.setNeedsStatusBarAppearanceUpdate()
        }
        
        /// The presenting view controllers view doesn't get removed from the window as its currently transistioning and presenting a view controller
        if let transitionViewClass = NSClassFromString("UITransitionView") {
            for subview in subviews where subview.isKind(of: transitionViewClass) {
                subview.removeFromSuperview()
            }
        }
        if let previousViewController = previousViewController {
            // Allow the view controller to be deallocated
            previousViewController.dismiss(animated: false) {
                // Remove the root view in case its still showing
                previousViewController.view.removeFromSuperview()
            }
        }
    }
}
extension UITextField{
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        doneToolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        doneToolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}


extension Alamofire.SessionManager{
    @discardableResult
    open func requestWithoutCache(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil)
        -> DataRequest
    {
        do {
            var urlRequest = try URLRequest(url: url, method: method, headers: headers)
            urlRequest.cachePolicy = .reloadIgnoringCacheData // <<== Cache disabled
            let encodedURLRequest = try encoding.encode(urlRequest, with: parameters)
            return request(encodedURLRequest)
        } catch {
            print(error)
            return request(URLRequest(url: URL(string: "http://example.com/wrong_request")!))
        }
    }
}


