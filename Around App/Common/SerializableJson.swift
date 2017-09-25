//
//  SerializableJson.swift
//  Around
//
//  Created by phuc.huynh on 10/4/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

protocol JSONRepresentable {
    var JSONRepresentation: AnyObject { get }
}
protocol JSONSerializable: JSONRepresentable {
}
extension JSONSerializable {
    var JSONRepresentation: AnyObject {
        var representation = [String: AnyObject]()
        
        for case let (label?, value) in Mirror(reflecting: self).children {
            switch value {
            case let value as JSONRepresentable:
                representation[label] = value.JSONRepresentation
                
            case let value as NSObject:
                representation[label] = value
                
            default:
                // Ignore any unserializable properties
                break
            }
        }
        
        return representation as AnyObject
    }
}
extension JSONSerializable {
    func toJSON() -> String? {
        let representation = JSONRepresentation
        
        guard JSONSerialization.isValidJSONObject(representation) else {
            return nil
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: representation, options: [])
            return String(data: data, encoding: String.Encoding.utf8)
        } catch {
            return nil
        }
    }
}

