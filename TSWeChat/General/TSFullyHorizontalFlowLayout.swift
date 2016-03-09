//
//  TSFullyHorizontalFlowLayout.swift
//  TSWeChat
//
//  Created by Hilen on 3/9/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

/*
 This class is inspired by: https://github.com/philippeauriach/fullyhorizontalcollectionview
 Rewrite in Swift
*/

import UIKit

class TSFullyHorizontalFlowLayout: UICollectionViewFlowLayout {
    internal var nbColumns: Int = -1
    internal var nbLines: Int = -1
    
    override init() {
        super.init()
        self.scrollDirection = .Horizontal
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes {
        guard let collectionView = self.collectionView else {
            return UICollectionViewLayoutAttributes()
        }
        let nbColumns: Int = self.nbColumns != -1 ? self.nbColumns : Int(self.collectionView!.frame.size.width / self.itemSize.width)
        let nbLines: Int = self.nbLines != -1 ? self.nbLines : Int(collectionView.frame.size.height / self.itemSize.height)
        let idxPage: Int = Int(indexPath.row) / (nbColumns * nbLines)
        let O: Int = indexPath.row - (idxPage * nbColumns * nbLines)
        let xD: Int = Int(O / nbColumns)
        let yD: Int = O % nbColumns
        let D: Int = xD + yD * nbLines + idxPage * nbColumns * nbLines
        let fakeIndexPath: NSIndexPath = NSIndexPath(forItem: D, inSection: indexPath.section)
        let attributes: UICollectionViewLayoutAttributes = super.layoutAttributesForItemAtIndexPath(fakeIndexPath)!
        return attributes
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let newX: CGFloat = min(0, rect.origin.x - rect.size.width / 2)
        let newWidth: CGFloat = rect.size.width * 2 + (rect.origin.x - newX)
        let newRect: CGRect = CGRectMake(newX, rect.origin.y, newWidth, rect.size.height)
        
        let attributes = super.layoutAttributesForElementsInRect(newRect)!
        var attributesCopy = [UICollectionViewLayoutAttributes]()
        
        for itemAttributes in attributes {
            let itemAttributesCopy = itemAttributes.copy() as! UICollectionViewLayoutAttributes
            attributesCopy.append(itemAttributesCopy)
        }
        
        return attributesCopy.map { attr in
            let newAttr: UICollectionViewLayoutAttributes = self.layoutAttributesForItemAtIndexPath(attr.indexPath)
            attr.frame = newAttr.frame
            attr.center = newAttr.center
            attr.bounds = newAttr.bounds
            attr.hidden = newAttr.hidden
            attr.size = newAttr.size
            return attr
        }
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func collectionViewContentSize() -> CGSize {
        let size: CGSize = super.collectionViewContentSize()
        let collectionViewWidth: CGFloat = self.collectionView!.frame.size.width
        let nbOfScreens: Int = Int(ceil((size.width / collectionViewWidth)))
        let newSize: CGSize = CGSizeMake(collectionViewWidth * CGFloat(nbOfScreens), size.height)
        return newSize
    }
}
