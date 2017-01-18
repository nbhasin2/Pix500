//
//  PXDictionaryExtension.swift
//  Pix500
//
//  Created by Nishant on 2016-03-10.
//  Copyright © 2016 Pix500. All rights reserved.
//

import Foundation

extension Dictionary {
    
    
    /// Returns a string representation of a dictionary as pretty printed JSON
    var jsonString: String {
        do
        {
            
            
            let stringData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            if let string = String(data: stringData, encoding: String.Encoding.utf8)
            {
                return string
            }
        }
        catch _ { }
        return ""
    }
    
    
    //  MARK: - Resolving Types
    
    /**
    Returns a integer value for the given key item pair in the dictionary.
    
    - parameter key: The key for the object you want to try and cast
    
    - returns: -1 if the item is not found or can't be casted to an integer
    */
    func intValue(key: Key) -> Int
    {
        return self[key] as? Int ?? -1
    }
    
    /**
     Returns a string value for the given key item pair in the dictionary.
     
     - parameter key: The key for the object you want to try and cast
     
     - returns: an empty string if the item is not found or can't be casted to an string
     */
    func stringValue(key: Key) -> String
    {
        return self[key] as? String ?? ""
    }
    
    /**
     Returns a Boolean value for the given key item pair in the dictionary.
     
     - parameter key: The key for the object you want to try and cast
     
     - returns: false if the item is not found or can't be casted to an Boolean
     */
    func boolValue(key: Key) -> Bool
    {
        return self[key] as? Bool ?? false
    }
    
    /**
     Returns a double value for the given key item pair in the dictionary.
     
     - parameter key: The key for the object you want to try and cast
     
     - returns: -1.0 if the item is not found or can't be casted to an double
     */
    func doubleValue(key: Key) -> Double
    {
        return self[key] as? Double ?? -1.0
    }
    
    /**
     Returns a dictionary value for the given key item pair in the dictionary.
     
     - parameter key: The key for the object you want to try and cast
     
     - returns: an empty dictionary if the item is not found or can't be casted to a dictionary with a string key
     */
    func dictionaryValue(key: Key) -> [String: AnyObject]
    {
        return self[key] as? [String: AnyObject] ?? [:]
    }
    
    /**
     Returns a array value for the given key item pair in the dictionary.
     
     - parameter key: The key for the object you want to try and cast
     
     - returns: an empty array of dictionaries if the item is not found or can't be casted to an array of dictionaries
     */
    func dictionaryArrayValue(key: Key) -> [[String: AnyObject]]
    {
        return self[key] as? [[String: AnyObject]] ?? [[:]]
    }
    
    /**
     Returns a array value for the given key item pair in the dictionary.
     
     - parameter key: The key for the object you want to try and cast
     
     - returns: an empty array of AnyObjects if the item is not found or can't be casted to an array of AnyObject
     */
    func arrayValue(key: Key) -> [AnyObject]
    {
        return self[key] as? [AnyObject] ?? []
    }
}
