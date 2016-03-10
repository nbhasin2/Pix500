//
//  ServerConnectionHelper.swift
//  Pix500
//
//  Created by Nishant on 2016-03-10.
//  Copyright © 2016 Pix500. All rights reserved.
//

import Foundation

@objc protocol pxServerConnectionDelegate: NSObjectProtocol
{
    optional func didEndFetchingPhotos()
}

class ServerConnectionHelper {
    
    var photos = [GridViewModel]()
    weak var serverConnectionDelegate: pxServerConnectionDelegate?
    
    func fetchPhotos()
    {
        var currentPage = 0;
        var totalPages = 0;
        
        request(Method.GET, pxServerFetch)
            .responseJSON { response in
            if let jsonData = response.data
            {
                
                if let jsonDict = jsonData.json
                {
                    var jsonDictItem = jsonDict as [String: AnyObject]
                    var a = jsonDictItem["photos"]
                    print(a?.count)
                    for image in a as! [Dictionary<String, AnyObject>]
                    {
                        // Full image urls
                        var imageURl = image["image_url"]?.stringValue
                        
                        var thumbnailPhoto = ""
                        var highresolutionPhoto = ""
                        
                        for imageSize4 in image["images"] as! [Dictionary<String, AnyObject>]
                        {
                            
                            var imageSize = imageSize4["size"]?.intValue
                            var images4 = imageSize4.stringValue("https_url")
                            if imageSize == 440
                            {
                                thumbnailPhoto = images4
                            }
                            if imageSize == 2048
                            {
                                highresolutionPhoto = images4
                            }
                        }
                        
                        self.photos.append(GridViewModel(thumbnail: thumbnailPhoto, highresolution: highresolutionPhoto))
                    }
                    
                }
                
                self.serverConnectionDelegate?.didEndFetchingPhotos?()
                
                if let jsonArray = jsonData.jsonArray
                {
                    print(jsonArray)
                }
            }

        }
    }
}