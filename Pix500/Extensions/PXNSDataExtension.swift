//
//  PXNSDataExtension.swift
//  Pix500
//
//  Created by Nishant on 2016-03-10.
//  Copyright © 2016 Pix500. All rights reserved.
//

import Foundation

extension NSData {
    
    /// Attempts to parse data into an array of JSON dictionaries.
    var jsonArray: [[String: AnyObject]]? {
        do
        {
            if let parsed = try NSJSONSerialization.JSONObjectWithData(self, options: NSJSONReadingOptions.AllowFragments) as? [[String: AnyObject]]
            {
                return parsed
            }
        }
        catch let error as NSError
        {
            print("Failed to parse JSON data into array:\n \(error)")
        }
        
        return nil
    }
    
    /// Attempts to parse data into a JSON dictionary.
    var json: [String: AnyObject]? {
        do
        {
            if let parsed = try NSJSONSerialization.JSONObjectWithData(self, options: NSJSONReadingOptions.AllowFragments) as? [String: AnyObject]
            {
                return parsed
            }
        }
        catch let error as NSError
        {
            print("Failed to parse JSON data into dictionary:\n \(error)")
        }
        
        return nil
    }
}
