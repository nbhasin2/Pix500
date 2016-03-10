//
//  GridViewController.swift
//  Pix500
//
//  Created by Nishant on 2016-03-09.
//  Copyright © 2016 Pix500. All rights reserved.
//

import Foundation
import UIKit

class GridViewModel
{
    // Saves image url 
    
    var imageUrl = ""
    
    init(imageurl:String)
    {
        self.imageUrl = imageurl
    }
}

class GridViewController : UIViewController
{
    
    // MARK: - Dummy Data 
    
    var mutlableImageList = [GridViewModel]()
    
    //  View Constants
    
    let viewTitle = "Pix500"
    
    let searchController = UISearchController(searchResultsController: nil)
    
    //  Cell Identifiers
    
    private let reuseIdentifier = "GridViewBasicCell"
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
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
        self.initializeView()
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
        
        let g1 = GridViewModel(imageurl: "1")
        let g2 = GridViewModel(imageurl: "2")
        let g3 = GridViewModel(imageurl: "3")
        
        self.mutlableImageList.append(g1)
        self.mutlableImageList.append(g2)
        self.mutlableImageList.append(g3)
    }
    
}

extension GridViewController : UICollectionViewDelegate
{
    //  MARK: - Collection View Delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        print(indexPath.row)
    }
}

extension GridViewController : UICollectionViewDataSource
{
    //  MARK: - Collection View Datasource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return mutlableImageList.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! GridViewCell

        cell.backgroundColor = UIColor.blackColor()
        // Configure the cell
        return cell

    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
}