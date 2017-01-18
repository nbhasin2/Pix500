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
    
    fileprivate let reuseIdentifier = "GridViewBasicCell"
    
    //  Constants 
    
    let gridLayoutCellWidth = CGFloat(40)
    let gridLayoutCellHeight = CGFloat(40)
    let transitionDelegate: TransitioningDelegate = TransitioningDelegate()
    
    //  Variables
    
    var imageViewContoller: ImageViewController?

    //  MARK: - Constructors
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!)
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
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        // This line fixes a bug related to collectionview not having correct frame. Even though the view frame is correct but collectionview
        // has incorrect frame values. This is why we make sure the frame is correct to handle view rotations.
        
        self.collectionView?.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: size.width, height: size.height)
            
        // This is necessary for the layout to honor "itemsPerRow"
        self.collectionView!.collectionViewLayout.invalidateLayout()
    }
    
//    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
//        
//        // This line fixes a bug related to collectionview not having correct frame. Even though the view frame is correct but collectionview
//        // has incorrect frame values. This is why we make sure the frame is correct to handle view rotations.
//        
//        self.collectionView?.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, size.width, size.height)
//        
//        // This is necessary for the layout to honor "itemsPerRow"
//        self.collectionView!.collectionViewLayout.invalidateLayout()
//        
//    }
//    
    //  MARK: - Initializer
    
    private func initializeView()
    {
        self.collectionView?.register((UINib(nibName: "GridViewCell", bundle: nil)), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.isScrollEnabled = true
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
        
        if ((self.collectionView?.numberOfItems(inSection: 0))! < ServerConnectionHelper.sharedInstance.photos.count)
        {
            self.collectionView?.reloadData()
        }
        
        // Check if cell is visible in the view
        
        let visisbleIndexPathList = self.collectionView?.indexPathsForVisibleItems
        
        if(visisbleIndexPathList?.contains(IndexPath(item: indexLocation, section: 0)))! {
            self.collectionView?.scrollToItem(at: IndexPath(item: indexLocation, section: 0), at: UICollectionViewScrollPosition.centeredVertically, animated: false)
        }
        
        // Update the Opening Frame for transitioning delegate
        
        let attributes = self.collectionView?.layoutAttributesForItem(at: IndexPath(item: indexLocation, section: 0))
        
        let attributesFrame = attributes!.frame
        
        let frameToOpenFrom = collectionView!.convert(attributesFrame, to: self.collectionView!.superview)
        transitionDelegate.openingFrame = frameToOpenFrom
        self.imageViewContoller?.transitioningDelegate = transitionDelegate
    }
    
}

//  MARK: - Collection Datasoure | Delegate | Flowlayout 

// GridViewController Extension with UICollectionViewDelegateFlowLayout, Collection Datasource and Collection Delegate related methods methods

extension GridViewController : UICollectionViewDelegateFlowLayout
{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
       
        return CGSize(width: gridLayoutCellWidth, height: gridLayoutCellHeight)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Setup server connection delegate
        ServerConnectionHelper.sharedInstance.serverConnectionDelegate = self
    }

    //  MARK: - Collection View Delegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let attributes = collectionView.layoutAttributesForItem(at: indexPath as IndexPath)
        let attributesFrame = attributes?.frame
        let frameToOpenFrom = collectionView.convert(attributesFrame!, to: collectionView.superview)
        transitionDelegate.openingFrame = frameToOpenFrom
        
        self.imageViewContoller = ImageViewController(nibName: "ImageViewController", bundle: nil)
        imageViewContoller!.scrollItemPosition = indexPath.item
        imageViewContoller!.transitioningDelegate = transitionDelegate
        imageViewContoller!.modalPresentationStyle = .custom
        imageViewContoller!.imageViewControllerDelegate = self
        present(imageViewContoller!, animated: true, completion: nil)
    }

    //  MARK: - Collection View Datasource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return ServerConnectionHelper.sharedInstance.photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Fetch more content
        
        if(indexPath.item == ((ServerConnectionHelper.sharedInstance.photos.count) - 1))
        {
            ServerConnectionHelper.sharedInstance.fetchNextPhotoPage()
        }
        
        // Configure cell
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! GridViewCell
        
        cell.thumbnailImage.kf.setImage(with: ServerConnectionHelper.sharedInstance.photos[indexPath.row].thumbnailUrl)
        
//        cell.thumbnailImage.kf_setImageWithURL((ServerConnectionHelper.sharedInstance.photos[indexPath.row].thumbnailUrl))
        
//        Uncomment the following line to show the imageview in staggred view with ratio in place
//        If you won't uncomment the line then grid will be in aspect fill state where images will 
//        be cropped out. 
//        Another solution to have full images shown proportinally would be to have fixed height and scale overall image based on that. 
//        This solution is being worked on another branch called StaggredView. 
        
//        cell.thumbnailImage.contentMode = UIViewContentMode.ScaleAspectFit
        
        cell.backgroundColor = UIColor.black
        
        return cell

    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}
