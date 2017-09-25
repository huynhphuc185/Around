//
//  EstimateObject.swift
//  Around
//
//  Created by phuc.huynh on 10/21/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import Foundation
class EstimateObject: NSObject {
    var distance : Double?
    var duration : Double?
    var shipping_fee : Int?
    var service_fee : Int?
    var return_to_pickup_fee : Int?
    var item_cost : Int?
    var total: Int?
    func parseDataFromDictionary(_ jsonDic : NSDictionary )->EstimateObject
    {
        let obj = EstimateObject()
        obj.distance = jsonDic["distance"] as? Double
        obj.duration = jsonDic["duration"] as? Double
        obj.shipping_fee = jsonDic["shipping_fee"] as? Int
        obj.service_fee = jsonDic["service_fee"] as? Int
        obj.return_to_pickup_fee = jsonDic["return_to_pickup_fee"] as? Int
        obj.item_cost = jsonDic["item_cost"] as? Int
        obj.total = jsonDic["total"] as? Int
        return obj
        
    }
}
