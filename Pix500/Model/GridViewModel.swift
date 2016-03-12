//
//  GridViewModel.swift
//  Pix500
//
//  Created by Nishant on 2016-03-12.
//  Copyright © 2016 Pix500. All rights reserved.
//

import Foundation

class GridViewModel
{
    // Saves image url
    
    var thumbnailUrl = NSURL()
    var highResolutionUrl = NSURL()
    
    convenience init(thumbnail:String, highresolution:String)
    {
        self.init()
        thumbnailUrl = NSURL(string: thumbnail)!
        highResolutionUrl = NSURL(string: highresolution)!
    }
}