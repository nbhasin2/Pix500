//
//  GridViewController.swift
//  Pix500
//
//  Created by Nishant on 2016-03-09.
//  Copyright © 2016 Pix500. All rights reserved.
//

import Foundation
import UIKit

class GridViewController : UICollectionViewController, pxServerConnectionDelegate
{
    //  Cell Identifiers
    
    private let reuseIdentifier = "GridViewBasicCell"
    
    //  Constants 
    
    let gridLayoutCellWidth = CGFloat(150)
    let gridLayoutCellHeight = CGFloat(150)

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
    
    //  MARK: - Initializer
    
    private func initializeView()
    {
        self.collectionView?.registerNib((UINib(nibName: "GridViewCell", bundle: nil)), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.scrollEnabled = true
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
    }
    
    func didEndFetchingPhotos()
    {
        self.collectionView?.reloadData()
    }
    
}

//  MARK: - Collection Datasoure | Delegate | Flowlayout 

// GridViewController Extension with UICollectionViewDelegateFlowLayout, Collection Datasource and Collection Delegate related methods methods

extension GridViewController : UICollectionViewDelegateFlowLayout
{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(gridLayoutCellWidth, gridLayoutCellHeight)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Setup server connection delegate
        ServerConnectionHelper.sharedInstance.serverConnectionDelegate = self
    }

    //  MARK: - Collection View Delegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let imageViewContoller: ImageViewController = ImageViewController(nibName: "ImageViewController", bundle: nil)
//        imageViewContoller.useLayoutToLayoutNavigationTransitions = true
        imageViewContoller.scrollItemPosition = indexPath.item
        self.navigationController?.pushViewController(imageViewContoller, animated: true)
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
        cell.backgroundColor = UIColor.blackColor()
        
        return cell

    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
}