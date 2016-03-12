//
//  ViewController.swift
//  Pix500
//
//  Created by Nishant on 2016-03-09.
//  Copyright © 2016 Pix500. All rights reserved.
//

import UIKit

/// Protocol of `ImageDownloader`.
@objc public protocol PXImageViewControllerDelegate
{
    optional func didDismissImageViewController(indexLocation:Int)
}

class ImageViewController: UICollectionViewController, PXServerConnectionDelegate
{
    //  Cell Identifiers
    
    private let reuseIdentifier = "ImageViewBasicCell"
    
    // Variables
    
    var scrollItemPosition = 0
    var didScrollOnce = false
    var currentIndexPosition = 0
    
    // Delegate
    
    var imageViewControllerDelegate: PXImageViewControllerDelegate?
    
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
     
        // Dismiss Button
        
        let button   = UIButton(type: UIButtonType.System) as UIButton
        button.frame = CGRectMake(0, 0, 70, 50)
        button.tintColor = UIColor.whiteColor()
        button.setTitle("Done", forState: UIControlState.Normal)
        button.addTarget(self, action: "doneAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(button)

    }
    
    // Done Action
    
    func doneAction(sender:UIButton!)
    {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.imageViewControllerDelegate?.didDismissImageViewController?(self.currentIndexPosition)
        })
    }
    
    // Server Connection Delegate methods
    
    func didEndFetchingPhotos()
    {
        self.collectionView?.reloadData()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        //This is necessary for the layout to honor "itemsPerRow"
        self.collectionView!.collectionViewLayout.invalidateLayout()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if(self.didScrollOnce == false)
        {
            self.currentIndexPosition = self.scrollItemPosition
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
        
        // Setting current index position 
        
        self.currentIndexPosition = indexPath.item
    
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


