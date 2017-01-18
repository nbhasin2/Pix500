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
    @objc optional func didDismissImageViewController(indexLocation:Int)
}

class ImageViewController: UICollectionViewController, PXServerConnectionDelegate
{
    //  Cell Identifiers
    
    fileprivate let reuseIdentifier = "ImageViewBasicCell"
    
    // Variables
    
    var scrollItemPosition = 0
    var didScrollOnce = false
    var currentIndexPosition = 0
    
    // Delegate
    
    var imageViewControllerDelegate: PXImageViewControllerDelegate?
    
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
        
        // Update delegate for server connection helper
        
        ServerConnectionHelper.sharedInstance.serverConnectionDelegate = self
        
        // View Initialization
        
        self.initializeView()
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    //  MARK: - Initializer
    
    private func initializeView()
    {
        self.collectionView?.register((UINib(nibName: "ImageViewCell", bundle: nil)), forCellWithReuseIdentifier: reuseIdentifier)
        
        // Flow Layout Setup
        
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        flowlayout.minimumInteritemSpacing = 0
        flowlayout.minimumLineSpacing = 0
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.collectionView?.setCollectionViewLayout(flowlayout, animated: true)
        self.collectionView?.isPagingEnabled = true
        self.collectionView?.isScrollEnabled = true
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
     
        // Dismiss Button
        
        let button   = UIButton(type: UIButtonType.system) as UIButton
        button.frame = CGRect(x: 0, y: 0, width: 70, height: 50)
        button.tintColor = UIColor.white
        button.setTitle("Done", for: UIControlState.normal)
        button.addTarget(self, action: "doneAction:", for: UIControlEvents.touchUpInside)
        
        self.view.addSubview(button)

    }
    
    // Done Action
    
    func doneAction(sender:UIButton!)
    {
        self.imageViewControllerDelegate?.didDismissImageViewController?(indexLocation: self.currentIndexPosition)
        self.dismiss(animated: true, completion: { () -> Void in
        })
    }
    
    // Server Connection Delegate methods
    
    func didEndFetchingPhotos()
    {
        self.collectionView?.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        //This is necessary for the layout to honor "itemsPerRow"
        self.collectionView!.collectionViewLayout.invalidateLayout()
    }
    
//    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
//        
//        //This is necessary for the layout to honor "itemsPerRow"
//        self.collectionView!.collectionViewLayout.invalidateLayout()
//        
//    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if(self.didScrollOnce == false)
        {
            self.currentIndexPosition = self.scrollItemPosition
            var indexPath = IndexPath(item: self.scrollItemPosition, section: 0)
            self.collectionView?.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
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
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return ServerConnectionHelper.sharedInstance.photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // If its last cell fetch more data
        
        if(indexPath.item == ((ServerConnectionHelper.sharedInstance.photos.count) - 1))
        {
            ServerConnectionHelper.sharedInstance.fetchNextPhotoPage()
        }
        
        // Setting current index position 
        
        self.currentIndexPosition = indexPath.item
    
        // Configure cell
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageViewCell
        
        let url = ServerConnectionHelper.sharedInstance.photos[indexPath.item].highResolutionUrl!
        
        cell.imageView.kf.setImage(with: url)
        
//        cell.imageView.kf.setImage(with: <#T##Resource?#>)
//        
//            cell.imageView.kf_setImageWithURL((ServerConnectionHelper.sharedInstance.photos[indexPath.item].highResolutionUrl))
        cell.backgroundColor = UIColor.black
        
        return cell
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}


