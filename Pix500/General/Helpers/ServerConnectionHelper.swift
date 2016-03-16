//
//  ServerConnectionHelper.swift
//  Pix500
//
//  Created by Nishant on 2016-03-10.
//  Copyright © 2016 Pix500. All rights reserved.
//

import Foundation

@objc protocol PXServerConnectionDelegate: NSObjectProtocol
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
    
    weak var serverConnectionDelegate: PXServerConnectionDelegate?
    
    // Number of current and total pages
    // Initially set to 0
    
    var currentPage = -1;
    var totalPages = -1;
    
    // This method will fetch all the pages begining from 0
    // To total number of pages
    
    func fetchAllPages()
    {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.fetchPhotos(0, parseInfinitely: true, block: nil)
        }
    }
    
    // Fetches contents of next page
    // Returns false if there are no pages available to be fetched
    
    func fetchNextPhotoPage()->Bool
    {
        if(currentPage != 0)
        {
            return fetchPhotos(currentPage+1, block: nil)
        }
        
        return false
    }
    
    // Fetches the first photo page
    // Calls fetchPhotos that takes in the initial page number (0)
    // Returns false if there are no pages available to fetch
    
    func fetchFirstPhotoPage()->Bool
    {
        return self.fetchPhotos(0, block: nil)
    }
    
    // Fetches photo page and updates the photos array.
    // Takes in the page number to fetch from server.
    // parseInfinitely fetches and parses the json recursively
    
    func fetchPhotos(page:Int, parseInfinitely:Bool = false, block: ((totalExpectedItems:Int) -> Void)?)->Bool
    {
        // Check if reached total pages 
        
        if(page >= self.totalPages && self.totalPages > 0)
        {
            return false
        }
        
        // Fetch next page 
        
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
                    self.totalPages = jsonDictionaryItem.intValue("total_pages")
                    
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
                
                if let totalItems = block{
                    
                    totalItems(totalExpectedItems: self.photos.count)
                }
                
                // Finished fetching photo data. Send delegate call back. 
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.serverConnectionDelegate?.didEndFetchingPhotos?()
                }
                
                // Infinitely parse items until the value is true.
                
                if (parseInfinitely)
                {
                    self.fetchPhotos(self.currentPage+1, parseInfinitely: true, block: nil)
                }
                
                if let jsonArray = jsonData.jsonArray
                {
                    print(jsonArray)
                }
            }
        }
        
        return true
    }
}