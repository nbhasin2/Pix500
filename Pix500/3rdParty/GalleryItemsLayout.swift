//
//  GalleryItemsLayout.swift
//  UICollectionView_p1_Swift
//  http://swiftiostutorials.com/tutorial-creating-custom-layouts-uicollectionview/
//
//  Created by Olga Dalton on 28/02/15.
//  Copyright (c) 2015 Olga Dalton. All rights reserved.
//

import UIKit
import Device

class GalleryItemsLayout: UICollectionViewLayout {
    
    var horizontalInset = 5.0 as CGFloat
    var verticalInset = 5.0 as CGFloat
    
    var minimumItemWidth = 150.0 as CGFloat
    var maximumItemWidth = 300.0 as CGFloat
    var itemHeight = 250.0 as CGFloat
    
    var _layoutAttributes = Dictionary<String, UICollectionViewLayoutAttributes>()
    var _contentSize = CGSize.zero
    
    // MARK: -
    // MARK: Layout
    
    override func prepare() {
        super.prepare()
        
        self.gridLayoutSetup()
        
        _layoutAttributes = Dictionary<String, UICollectionViewLayoutAttributes>() // 1
        
        let headerHeight = UIApplication.shared.statusBarFrame.size.height
        
        let numberOfSections = self.collectionView!.numberOfSections // 3
        
        var yOffset = headerHeight
        
        for section in 0 ..< numberOfSections {
            
            let numberOfItems = self.collectionView!.numberOfItems(inSection: section) // 3
            
            var xOffset = self.horizontalInset
            
            for item in 0 ..< numberOfItems {
                
                let indexPath = IndexPath(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath) // 4
                
                var itemSize = CGSize.zero
                var increaseRow = false
                
                if self.collectionView!.frame.size.width - xOffset > self.maximumItemWidth * 1.5 {
                    itemSize = randomItemSize() // 5
                } else {
                    itemSize.width = self.collectionView!.frame.size.width - xOffset - self.horizontalInset
                    itemSize.height = self.itemHeight
                    increaseRow = true // 6
                }
                
                
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height).integral
                let key = layoutKeyForIndexPath(indexPath: indexPath as NSIndexPath)
                _layoutAttributes[key] = attributes // 7
                
                xOffset += itemSize.width
                xOffset += self.horizontalInset // 8
                
                if increaseRow
                    && !(item == numberOfItems - 1 && section == numberOfSections - 1) { // 9
                    
                    yOffset += self.verticalInset
                    yOffset += self.itemHeight
                    xOffset = self.horizontalInset
                        
                }
            }
            
        }
        
        yOffset += self.itemHeight // 10
        
        _contentSize = CGSize(width: self.collectionView!.frame.size.width, height: yOffset + self.verticalInset) // 11
        
    }
    
    func randomItemSize() -> CGSize {
        return CGSize(width: getRandomWidth(), height: self.itemHeight)
    }
    
    func getRandomWidth() -> CGFloat {
        let range = UInt32(self.maximumItemWidth - self.minimumItemWidth + 1)
        let random = Float(arc4random_uniform(range))
        return CGFloat(self.minimumItemWidth) + CGFloat(random)
    }
    
    // MARK: -
    // MARK: Helpers
    
    func layoutKeyForIndexPath(indexPath : NSIndexPath) -> String {
        return "\(indexPath.section)_\(indexPath.row)"
    }
    
    func layoutKeyForHeaderAtIndexPath(indexPath : NSIndexPath) -> String {
        return "s_\(indexPath.section)_\(indexPath.row)"
    }
    
    // MARK: -
    // MARK: Invalidate
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return !newBounds.size.equalTo(self.collectionView!.frame.size)
    }
    
    // MARK: - 
    // MARK: Setup grid layout values based on device type
    
    func gridLayoutSetup()
    {
        /*** Display the device screen size ***/
        switch Device.size() {
        case .screen3_5Inch, .screen4Inch, .screen4_7Inch, .screen5_5Inch:
            self.horizontalInset = 5.0 as CGFloat
            self.verticalInset = 5.0 as CGFloat
            self.minimumItemWidth = 50.0 as CGFloat
            self.maximumItemWidth = 100.0 as CGFloat
            self.itemHeight = 100.0 as CGFloat

        default: break
            
        }
    }
    
    // MARK: -
    // MARK: Required methods

    override var collectionViewContentSize: CGSize{
        get {
            return _contentSize
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let key = layoutKeyForIndexPath(indexPath: indexPath as NSIndexPath)
        return _layoutAttributes[key]
    }
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let headerKey = layoutKeyForIndexPath(indexPath: indexPath as NSIndexPath)
        return _layoutAttributes[headerKey]

    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let predicate = NSPredicate {  [unowned self] (evaluatedObject, bindings) -> Bool in
            let layoutAttribute = self._layoutAttributes[evaluatedObject as! String]
            return rect.intersects(layoutAttribute!.frame)
        }
        
        let dict = _layoutAttributes as NSDictionary
        let keys = dict.allKeys as NSArray
        let matchingKeys = keys.filtered(using: predicate)
        
        return dict.objects(forKeys: matchingKeys, notFoundMarker: NSNull()) as? [UICollectionViewLayoutAttributes]
    }

}
