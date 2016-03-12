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
    
    // Singleton Class
    static let sharedInstance = ServerConnectionHelper()

    // Array of GridViewModel objects to store 
    // Thumbnail and High resolution photos
    
    var photos = [GridViewModel]()
    
    // Delegate method to notify changes in the model
    
    weak var serverConnectionDelegate: pxServerConnectionDelegate?
    
    // Number of current and total pages
    // Initially set to 0
    
    var currentPage = 0;
    var totalPages = 0;
    
    
    // Fetches contents of next page
    
    func fetchNextPhotoPage()
    {
        if(currentPage != 0)
        {
            fetchPhotos(currentPage+1)
        }
    }
    
    // Fetches the first photo page
    // Calls fetchPhotos that takes in the initial page number (0)
    
    func fetchFirstPhotoPage()
    {
        self.fetchPhotos(0)
    }
    
    // Fetches photo page and updates the photos array.
    // Takes in the page number to fetch from server.
    
    func fetchPhotos(page:Int)
    {
        var specificPage = specificPageParam + "\(page)"
        if page < 2
        {
            specificPage = ""
        }
        
        // Creating request to fetch the page
        
        request(Method.GET, pxServerFetch + specificPage)
            .responseJSON { response in
            if let jsonData = response.data
            {
                
                if let jsonDictionary = jsonData.json
                {
                    let jsonDictionaryItem = jsonDictionary as [String: AnyObject]
                    self.currentPage = jsonDictionaryItem.intValue("current_page")
                    self.totalPages = jsonDictionaryItem.intValue("current_page")
                    
                    let photoListData = jsonDictionaryItem["photos"]

                    for photo in photoListData as! [Dictionary<String, AnyObject>]
                    {
                        var thumbnailPhoto = ""
                        var highresolutionPhoto = ""
            
                        for imageSize in photo["images"] as! [Dictionary<String, AnyObject>]
                        {
                            let size = imageSize["size"]?.intValue
                            let httpUrl = imageSize.stringValue("https_url")
                            
                            // Checking if image size equals 440
                            
                            if (size == 440)
                            {
                                thumbnailPhoto = httpUrl
                            }
                            if (size == 2048)
                            {
                                highresolutionPhoto = httpUrl
                            }
                        }
                        
                        // Update the photos array and add thumbnail and highresolution photo data.
                        
                        self.photos.append(GridViewModel(thumbnail: thumbnailPhoto, highresolution: highresolutionPhoto))
                    }
                    
                }
                
                // Finished fetching photo data. Send delegate call back. 
                
                self.serverConnectionDelegate?.didEndFetchingPhotos?()
                
                if let jsonArray = jsonData.jsonArray
                {
                    print(jsonArray)
                }
            }
        }
    }
}