//
//  GetProfile.swift
//  Around App
//
//  Created by phuc.huynh on 8/16/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import Foundation
class Profile: NSObject {
    var avatar : String?
    var fullname : String?
    var phone: String?
    var email: String?
    var birthday: String?
    func parseDataFromDictionary(_ jsonDic : NSDictionary )->Profile
    {
        let obj = Profile()
        obj.avatar = jsonDic["avatar"] as? String
        obj.fullname = jsonDic["fullname"] as? String
        obj.phone = jsonDic["phone"] as? String
        obj.email = jsonDic["email"] as? String
        obj.birthday = jsonDic["birthday"] as? String
        return obj
        
    }

}
