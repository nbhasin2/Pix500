//
//  GridViewController.swift
//  Pix500
//
//  Created by Nishant on 2016-03-09.
//  Copyright © 2016 Pix500. All rights reserved.
//

import Foundation
import UIKit

class GridViewController : UICollectionViewController, PXServerConnectionDelegate, PXImageViewControllerDelegate
{
    //  Cell Identifiers
    
    private let reuseIdentifier = "GridViewBasicCell"
    
    //  Constants 
    
    let gridLayoutCellWidth = CGFloat(200)
    let gridLayoutCellHeight = CGFloat(200)
    let transitionDelegate: TransitioningDelegate = TransitioningDelegate()
    
    //  Variables
    
    var imageViewContoller: ImageViewController?
    
    var galleryItemsLayout: GalleryItemsLayout?

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
        ServerConnectionHelper.sharedInstance.serverConnectionDelegate = self
        self.initializeView()
        ServerConnectionHelper.sharedInstance.fetchFirstPhotoPage()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.hidden = true
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        //This is necessary for the layout to honor "itemsPerRow"
        self.collectionView!.collectionViewLayout.invalidateLayout()
        
    }
    
    //  MARK: - Initializer
    
    private func initializeView()
    {
        // Gallery Items Layout 
        self.galleryItemsLayout = GalleryItemsLayout()
        
        // Setup CollectionView
        self.collectionView?.registerNib((UINib(nibName: "GridViewCell", bundle: nil)), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.setCollectionViewLayout(self.galleryItemsLayout!, animated: true)
        self.collectionView?.scrollEnabled = true
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
    }
    
    //  MARK: - Server Connection Delegate method
    
    func didEndFetchingPhotos()
    {
        self.collectionView?.reloadData()
    }
    
    //  MARK: - ImageView Controller Delegate
    
    func didDismissImageViewController(indexLocation:Int)
    {
        // Reload Data
        
        if (self.collectionView?.numberOfItemsInSection(0) < ServerConnectionHelper.sharedInstance.photos.count)
        {
            self.collectionView?.reloadData()
        }
        
        // Check if cell is visible in the view
        
        let visisbleIndexPathList = self.collectionView?.indexPathsForVisibleItems()
        if (visisbleIndexPathList?.contains(NSIndexPath(forItem: indexLocation, inSection: 0)) == false)
        {
            self.collectionView?.scrollToItemAtIndexPath(NSIndexPath(forItem: indexLocation, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.CenteredVertically, animated: false)
        }
        
        // Update the Opening Frame for transitioning delegate
        
        let attributes = self.collectionView?.layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: indexLocation, inSection: 0))
        let attributesFrame = attributes!.frame
        let frameToOpenFrom = collectionView!.convertRect(attributesFrame, toView: self.collectionView!.superview)
        transitionDelegate.openingFrame = frameToOpenFrom
        self.imageViewContoller?.transitioningDelegate = transitionDelegate
    }
    
}

//  MARK: - Collection Datasoure | Delegate | Flowlayout 

// GridViewController Extension with UICollectionViewDelegateFlowLayout, Collection Datasource and Collection Delegate related methods methods

extension GridViewController : UICollectionViewDelegateFlowLayout
{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
//        if(self.imageSizes.count > 0 && self.imageSizes.count < (indexPath.item + 1))
//        {
//            if(self.imageSizes[indexPath.row - 1] != nil)
//            {
//                return self.imageSizes[indexPath.item - 1]!
//            }
//        }
        
        return CGSizeMake(gridLayoutCellWidth, gridLayoutCellHeight)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        print(self.collectionView?.frame.size)
        // Setup server connection delegate
        ServerConnectionHelper.sharedInstance.serverConnectionDelegate = self
    }

    //  MARK: - Collection View Delegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let attributes = collectionView.layoutAttributesForItemAtIndexPath(indexPath)
        let attributesFrame = attributes?.frame
        let frameToOpenFrom = collectionView.convertRect(attributesFrame!, toView: collectionView.superview)
        transitionDelegate.openingFrame = frameToOpenFrom
        
        self.imageViewContoller = ImageViewController(nibName: "ImageViewController", bundle: nil)
        imageViewContoller!.scrollItemPosition = indexPath.item
        imageViewContoller!.transitioningDelegate = transitionDelegate
        imageViewContoller!.modalPresentationStyle = .Custom
        imageViewContoller!.imageViewControllerDelegate = self
        presentViewController(imageViewContoller!, animated: true, completion: nil)
    }

    //  MARK: - Collection View Datasource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return ServerConnectionHelper.sharedInstance.photos.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        // Fetch more content
        
        if(indexPath.item == ((ServerConnectionHelper.sharedInstance.photos.count) - 1))
        {
            ServerConnectionHelper.sharedInstance.fetchNextPhotoPage()
        }
        
        // Configure cell
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! GridViewCell
        cell.thumbnailImage.kf_setImageWithURL((ServerConnectionHelper.sharedInstance.photos[indexPath.row].thumbnailUrl))
        KingfisherManager.sharedManager.retrieveImageWithURL(ServerConnectionHelper.sharedInstance.photos[indexPath.row].thumbnailUrl, optionsInfo: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) -> () in
            print(image?.size)

            var imgSize = image?.size
            var aspectRatio = (imgSize?.width)! / (imgSize?.height)!
            var frame = cell.thumbnailImage.frame
            if(200 / aspectRatio <= 100)
            {
                frame.size.width = 100
                frame.size.height = frame.size.width / aspectRatio
            }
            else
            {
                frame.size.height = 100
                frame.size.width = frame.size.height / aspectRatio
            }
//            self.imageSizes.append(CGSize(width: frame.size.width, height: frame.size.height))
            self.galleryItemsLayout?.imageSizes.append(sizeImage(width: frame.size.width, height: frame.size.height))
            self.collectionView?.collectionViewLayout.invalidateLayout()
//            cell.thumbnailImage.image = image
        })
        
        cell.backgroundColor = UIColor.blackColor()
        
        return cell

    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
}