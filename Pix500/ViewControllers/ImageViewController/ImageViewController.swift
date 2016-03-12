//
//  ViewController.swift
//  Pix500
//
//  Created by Nishant on 2016-03-09.
//  Copyright © 2016 Pix500. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var pagingView: PagingView!
    var imageUrl:NSURL?
    var currentPosition = 0
    var images = [GridViewModel]()
    var previousPosition = -1
    var nextPostition = -1
    var initialPosition = 0
    
    var previtem = -1
    var prevexpectedpos = 0
    var nextexpectedpos = 0
    
    
    // this is a convenient way to create this view controller without a imageURL
    
    init(currentPosition:Int, images:[GridViewModel]) {
        super.init(nibName: nil, bundle: nil)
        self.images = images
        self.currentPosition = currentPosition
        self.initialPosition = currentPosition
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        pagingView.dataSource = self
        pagingView.delegate = self
        pagingView.pagingMargin = 0
        pagingView.pagingInset = 0
        pagingView.showsHorizontalScrollIndicator = false
        
        let nib = UINib(nibName: "ImageViewCell", bundle: nil)
        pagingView.registerNib(nib, forCellWithReuseIdentifier: "RegisterNibCell")
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.hidden = false
//                self.navigationController?.navigationBar.translucent = true

        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = true
        self.navigationController!.view.backgroundColor = UIColor.clearColor()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ImageViewController: PagingViewDataSource, PagingViewDelegate, UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var width = self.view.bounds.width
        var contentOffset = scrollView.contentOffset.x
        
        
        // Scrolling Left
        if((width - contentOffset) < 0)
        {
            
        }
        // Scrolling Right
        else if ((width - contentOffset) > 0)
        {
            
        }
        // Middle
        else
        {
            
        }
        if let centerCell = pagingView.visibleCenterCell() {
            let imageName = images[centerCell.indexPath.item]
//            title = "\(imageName.highResolutionUrl)"
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        var width = self.view.bounds.width
        var contentOffset = scrollView.contentOffset.x
        
        
        // Scrolling Left
        if((width - contentOffset) < 0)
        {
            print("1")
        }
            // Scrolling Right
        else if ((width - contentOffset) > 0)
        {
            print("2")
        }
            // Middle
        else
        {
            print("3")
        }
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        var width = self.view.bounds.width
        var contentOffset = scrollView.contentOffset.x
        // Scrolling Left
        if((width - contentOffset) < 0)
        {
            print("4")
        }
            // Scrolling Right
        else if ((width - contentOffset) > 0)
        {
            print("5")
        }
            // Middle
        else
        {
            print("6")
        }
    }
    
    func pagingView(pagingView: PagingView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func pagingView(pagingView: PagingView, cellForItemAtIndexPath indexPath: NSIndexPath) -> PagingViewCell {
        
//        if previousPosition == -1 
//        {
//            previousPosition = indexPath.item
//        }
//        else if previousPosition < indexPath.item // Next
//        {
//            currentPosition = currentPosition + 1
//            
//            previousPosition = indexPath.item
//        }
//        else if previousPosition > indexPath.item // Previous
//        {
//            currentPosition = currentPosition - 1
//            
//            previousPosition = indexPath.item
//        }

//        print("Current - \(currentPosition)")
//        print("Prev - \(previousPosition)")
//        print("Item - \(indexPath.item)")
        
//        if previousPosition == -1
//        {
//            previousPosition = indexPath.item
//        }
//        else if previousPosition < indexPath.item // Next
//        {
//            currentPosition = currentPosition + 1
//            
//            previousPosition = indexPath.item
//        }
//        else if previousPosition > indexPath.item // Previous
//        {
//            currentPosition = currentPosition - 1
//            
//            previousPosition = indexPath.item
//        }
//        print("_____")
//        
//        print("Current1 - \(currentPosition)")
//        print("Prev1 - \(previousPosition)")
//        print("Item1 - \(indexPath.item)")
//        print("Initial1 - \(initialPosition)")
//        
//        print("\n")
        
//        if initialPosition == 0
//        {
//            currentPosition = indexPath.item
//        }
//        else
//        {
//            
//            if previousPosition == -1
//            {
//                previousPosition = indexPath.item
//            }
//            else if previousPosition < indexPath.item // Next
//            {
//                // Moving Forward
//                
//                currentPosition = indexPath.item + initialPosition
//            }
//            else if previousPosition > indexPath.item // Previous
//            {
//                currentPosition = abs(images.count - indexPath.item)
//            }

            
//            // Moving Forward
//            
//            currentPosition = indexPath.item + initialPosition
//            
//            // Moving Backwards
//            
//            if indexPath.item > 0 && currentPosition > 0
//            {
//                currentPosition = currentPosition - 1
//            }
            
//        }
        
        print("_____")
        
        print("Current0 - \(currentPosition)")
        print("Prev0 - \(previtem)")
        print("PrevEx0 - \(prevexpectedpos)")
        print("NextEx0 - \(nextexpectedpos)")
        print("Item0 - \(indexPath.item)")
        print("Initial0 - \(initialPosition)")
        
        print("\n")
        
        if(previtem == -1)
        {
            previtem = indexPath.item
            prevexpectedpos = images.count - 1
            nextexpectedpos = previtem + 1
        }
        else if(indexPath.item == prevexpectedpos)
        {
            var calcback = 0
            if(previtem == 0)
            {
                calcback = abs(indexPath.item - images.count)
                currentPosition = (initialPosition - calcback)
            }
            else
            {
                calcback = abs(indexPath.item - previtem)
                currentPosition = (currentPosition - calcback)
            }
            
            nextexpectedpos = previtem
            previtem = indexPath.item
            prevexpectedpos = previtem - 1
        }
        else if(indexPath.item == nextexpectedpos)
        {
//            var itemPos = indexPath.item
//            if(itemPos == 0)
//            {
//                itemPos = indexPath.item + 1
//            }
//            else
//            {
//                itemPos = abs(previtem - prevexpectedpos)
//            }
            currentPosition = currentPosition + 1
            prevexpectedpos = previtem
            previtem = indexPath.item
            nextexpectedpos = previtem + 1
        }
        
        print("_____")
        
        print("Current1 - \(currentPosition)")
        print("Prev1 - \(previtem)")
        print("PrevEx1 - \(prevexpectedpos)")
        print("NextEx1 - \(nextexpectedpos)")
        print("Item1 - \(indexPath.item)")
        print("Initial1 - \(initialPosition)")
        
        print("\n")
        
//        previousPosition = indexPath.item
        
        

        if currentPosition > 0
        {
            pagingView.infinite = true
        }
        else
        {
            pagingView.infinite = false
        }
        let cell = pagingView.dequeueReusableCellWithReuseIdentifier("RegisterNibCell")
        if let cell = cell as? ImageViewCell {
            let imageUrl = images[currentPosition].highResolutionUrl
            cell.imageView.kf_setImageWithURL(imageUrl)
        }
        
        return cell
    }
    
    func pagingView(pagingView: PagingView, willDisplayCell cell: PagingViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
//        print("will - \(indexPath.item)")
//        print(cell.position)
    }
    
    func pagingView(pagingView: PagingView, didEndDisplayingCell cell: PagingViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
//        print("did")
//        print(cell.position)
    }
}


