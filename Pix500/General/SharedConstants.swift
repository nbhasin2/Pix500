//
//  SharedConstants.swift
//  Pix500
//
//  Created by Nishant on 2016-03-10.
//  Copyright © 2016 Pix500. All rights reserved.
//

import Foundation

//  This is used for fetching photos based on different type.
enum scopeType: String
{
    case popular = "feature=popular"
}

let pxServerFetch = "https://api.500px.com/v1/photos?feature=popular&consumer_key=gqRvsm0MwGPteqRO5VetBW8QN0gJNZwHFimqOJX9&image_size[]=440&image_size[]=2048"