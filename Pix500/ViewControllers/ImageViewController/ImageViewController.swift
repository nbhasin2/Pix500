//
//  ViewController.swift
//  Pix500
//
//  Created by Nishant on 2016-03-09.
//  Copyright © 2016 Pix500. All rights reserved.
//

import UIKit

class ImageViewController: UICollectionViewController, pxServerConnectionDelegate {    
    //  Cell Identifiers
    
    private let reuseIdentifier = "GridViewBasicCell"
    
    // Variables
    var scrollItemPosition = 0
    var didScrollOnce = false
    
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
        
        // Update delegate for server connection helper
        
        ServerConnectionHelper.sharedInstance.serverConnectionDelegate = self
        
        // View Initialization
        self.initializeView()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.hidden = false
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    //  MARK: - Initializer
    
    private func initializeView()
    {
        self.collectionView?.registerNib((UINib(nibName: "ImageViewCell", bundle: nil)), forCellWithReuseIdentifier: reuseIdentifier)
        
        // Flow Layout Setup
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        flowlayout.minimumInteritemSpacing = 0
        flowlayout.minimumLineSpacing = 0
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.collectionView?.setCollectionViewLayout(flowlayout, animated: true)
        self.collectionView?.pagingEnabled = true
        self.collectionView?.scrollEnabled = true
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        
    }
    
    func didEndFetchingPhotos()
    {
        self.collectionView?.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if(self.didScrollOnce == false)
        {
            self.collectionView?.scrollToItemAtIndexPath(NSIndexPath(forItem: self.scrollItemPosition, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: false)
            self.didScrollOnce = true
        }
    }
}

//  MARK: - Collection Datasoure | Delegate | Flowlayout

// ImageViewController Extension with UICollectionViewDelegateFlowLayout, Collection Datasource and Collection Delegate related methods methods

extension ImageViewController : UICollectionViewDelegateFlowLayout
{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return (self.collectionView?.frame.size)!
    }


    //  MARK: - Collection View Datasource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return ServerConnectionHelper.sharedInstance.photos.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        
        // If its last cell fetch more data
        
        if(indexPath.item == ((ServerConnectionHelper.sharedInstance.photos.count) - 1))
        {
            ServerConnectionHelper.sharedInstance.fetchNextPhotoPage()
        }
        
        // Configure cell
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ImageViewCell
        cell.imageView.kf_setImageWithURL((ServerConnectionHelper.sharedInstance.photos[indexPath.item].highResolutionUrl))
        cell.backgroundColor = UIColor.blackColor()
        
        return cell
        
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
}


