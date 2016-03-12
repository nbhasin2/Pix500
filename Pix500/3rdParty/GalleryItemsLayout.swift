//
//  GalleryItemsLayout.swift
//  UICollectionView_p1_Swift
//  http://swiftiostutorials.com/tutorial-creating-custom-layouts-uicollectionview/
//
//  Created by Olga Dalton on 28/02/15.
//  Copyright (c) 2015 Olga Dalton. All rights reserved.
//

import UIKit

class GalleryItemsLayout: UICollectionViewLayout {
    
    var horizontalInset = 0.0 as CGFloat
    var verticalInset = 0.0 as CGFloat
    
    var minimumItemWidth = 0.0 as CGFloat
    var maximumItemWidth = 0.0 as CGFloat
    var itemHeight = 0.0 as CGFloat
    
    var _layoutAttributes = Dictionary<String, UICollectionViewLayoutAttributes>()
    var _contentSize = CGSizeZero
    
    // MARK: -
    // MARK: Layout
    
    override func prepareLayout() {
        super.prepareLayout()
        
        _layoutAttributes = Dictionary<String, UICollectionViewLayoutAttributes>() // 1
        
        let headerHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        
        let numberOfSections = self.collectionView!.numberOfSections() // 3
        
        var yOffset = headerHeight
        
        for var section = 0; section < numberOfSections; section++ {
            
            let numberOfItems = self.collectionView!.numberOfItemsInSection(section) // 3
            
            var xOffset = self.horizontalInset
            
            for var item = 0; item < numberOfItems; item++ {
                
                let indexPath = NSIndexPath(forItem: item, inSection: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath) // 4
                
                var itemSize = CGSizeZero
                var increaseRow = false
                
                if self.collectionView!.frame.size.width - xOffset > self.maximumItemWidth * 1.5 {
                    itemSize = randomItemSize() // 5
                } else {
                    itemSize.width = self.collectionView!.frame.size.width - xOffset - self.horizontalInset
                    itemSize.height = self.itemHeight
                    increaseRow = true // 6
                }
                
                attributes.frame = CGRectIntegral(CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height))
                let key = layoutKeyForIndexPath(indexPath)
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
        
        _contentSize = CGSizeMake(self.collectionView!.frame.size.width, yOffset + self.verticalInset) // 11
        
    }
    
    func randomItemSize() -> CGSize {
        return CGSizeMake(getRandomWidth(), self.itemHeight)
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
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return !CGSizeEqualToSize(newBounds.size, self.collectionView!.frame.size)
    }
    
    // MARK: -
    // MARK: Required methods
    
    override func collectionViewContentSize() -> CGSize {
        return _contentSize
    }
    
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let key = layoutKeyForIndexPath(indexPath)
        return _layoutAttributes[key]
    }

    override func layoutAttributesForDecorationViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let headerKey = layoutKeyForIndexPath(indexPath)
        return _layoutAttributes[headerKey]
    }
    
    
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let predicate = NSPredicate {  [unowned self] (evaluatedObject, bindings) -> Bool in
            let layoutAttribute = self._layoutAttributes[evaluatedObject as! String]
            return CGRectIntersectsRect(rect, layoutAttribute!.frame)
        }
        
        let dict = _layoutAttributes as NSDictionary
        let keys = dict.allKeys as NSArray
        let matchingKeys = keys.filteredArrayUsingPredicate(predicate)
        
        return dict.objectsForKeys(matchingKeys, notFoundMarker: NSNull()) as? [UICollectionViewLayoutAttributes]
    }

}