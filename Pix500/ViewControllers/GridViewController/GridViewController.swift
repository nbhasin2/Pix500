//
//  GridViewController.swift
//  Pix500
//
//  Created by Nishant on 2016-03-09.
//  Copyright © 2016 Pix500. All rights reserved.
//

import Foundation
import UIKit

//TODO: - Get Photo list
//https://api.500px.com/v1/photos?feature=popular&consumer_key=gqRvsm0MwGPteqRO5VetBW8QN0gJNZwHFimqOJX9

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

class GridViewController : UIViewController, pxServerConnectionDelegate
{
    
    // MARK: - Dummy Data 
    
    var mutlableImageList = [GridViewModel]()
    
    //  View Constants
    
    let viewTitle = "Pix500"
    
    let searchController = UISearchController(searchResultsController: nil)
    
    //  Cell Identifiers
    
    private let reuseIdentifier = "GridViewBasicCell"
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    // Variables
    private var serverConnectionHelper: ServerConnectionHelper?
    private var imagePreviewer: ImageViewer!
    
    //  View Outlets
    
    
    @IBOutlet weak var gridCollectionView: UICollectionView!
    
    //  MARK: - Constructors
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    //  MARK: - Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.serverConnectionHelper = ServerConnectionHelper()
        self.serverConnectionHelper?.serverConnectionDelegate = self
        self.initializeView()
        self.serverConnectionHelper?.fetchPhotos()
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
    }
    
    //  MARK: - Initializer
    
    private func initializeView()
    {
        self.gridCollectionView.registerNib((UINib(nibName: "GridViewCell", bundle: nil)), forCellWithReuseIdentifier: reuseIdentifier)
        self.gridCollectionView.scrollEnabled = true
        self.gridCollectionView.delegate = self
        self.gridCollectionView.dataSource = self
        
        // Adding Dummy Data

    }
    
    func didEndFetchingPhotos()
    {
        self.gridCollectionView.reloadData()
    }
    
}

extension GridViewController : UICollectionViewDelegate
{
    //  MARK: - Collection View Delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        var cell : UICollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath)!
        
        print(indexPath.row)
        let imageViewContoller: ImageViewController = ImageViewController(currentPosition: indexPath.item, images: (self.serverConnectionHelper?.photos)!)
        self.navigationController?.pushViewController(imageViewContoller, animated: true)
        
//        var url = self.serverConnectionHelper?.photos[indexPath.row].highResolutionUrl

//        let size = self.view.bounds.size
//        
//        let buttonsAssets = CloseButtonAssets(normal: UIImage(named: "close_normal")!, highlighted: UIImage(named: "close_highlighted")!)
//        
//        let configuration = ImageViewerConfiguration(imageSize: size, closeButtonAssets: buttonsAssets)
//        self.imagePreviewer = ImageViewer(imageUrl: url!, configuration: configuration, displacedView: cell)
//        self.presentImageViewer(self.imagePreviewer)
    }
}

extension GridViewController : UICollectionViewDataSource
{
    //  MARK: - Collection View Datasource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if(serverConnectionHelper != nil)
        {
            return serverConnectionHelper!.photos.count
        }
        return 0
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! GridViewCell
        var rowItem = indexPath.row
        cell.thumbnailImage.kf_setImageWithURL((self.serverConnectionHelper?.photos[rowItem].thumbnailUrl)!)
        cell.backgroundColor = UIColor.blackColor()
        // Configure the cell
        return cell

    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
}