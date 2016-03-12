//
//  ImageViewCell.swift
//  Pix500
//
//  Created by Nishant on 2016-03-10.
//  Copyright © 2016 Pix500. All rights reserved.
//

import UIKit

class ImageViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}
