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

    // this is a convenient way to create this view controller without a imageURL
    
    init(currentPosition:Int, images:[GridViewModel]) {
        super.init(nibName: nil, bundle: nil)
        self.images = images
        self.currentPosition = currentPosition
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ImageViewController: PagingViewDataSource, PagingViewDelegate, UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if let centerCell = pagingView.visibleCenterCell() {
            let imageName = images[centerCell.indexPath.item]
            title = "\(imageName.highResolutionUrl)"
        }
    }
    
    func pagingView(pagingView: PagingView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func pagingView(pagingView: PagingView, cellForItemAtIndexPath indexPath: NSIndexPath) -> PagingViewCell {
        let cell = pagingView.dequeueReusableCellWithReuseIdentifier("RegisterNibCell")
        if let cell = cell as? ImageViewCell {
            let imageUrl = images[currentPosition].highResolutionUrl
            cell.imageView.kf_setImageWithURL(imageUrl)
        }
        
        return cell
    }
}


