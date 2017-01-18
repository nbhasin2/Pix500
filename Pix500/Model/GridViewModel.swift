//
//  GridViewModel.swift
//  Pix500
//
//  Created by Nishant on 2016-03-12.
//  Copyright © 2016 Pix500. All rights reserved.
//

import Foundation
import Alamofire

class GridViewModel
{
    // Saves image url
    var thumbnailUrl:URL?
    var highResolutionUrl:URL?
    
    convenience init(thumbnail:String, highresolution:String)
    {
        self.init()
        thumbnailUrl = URL(string: thumbnail)!
        highResolutionUrl = URL(string: highresolution)!
    }
}
