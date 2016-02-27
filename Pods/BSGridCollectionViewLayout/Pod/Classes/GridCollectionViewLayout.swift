// The MIT License (MIT)
//
// Copyright (c) 2015 Joakim Gyllström
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

/**
Provides a grid collection view layout
*/
public final class GridCollectionViewLayout: UICollectionViewLayout {
    /**
    Spacing between items (horizontal and vertical)
    */
    public var itemSpacing: CGFloat = 0 {
        didSet {
            _itemSize = estimatedItemSize()
        }
    }

    /**
    Number of items per row
    */
    public var itemsPerRow = 3 {
        didSet {
            _itemSize = estimatedItemSize()
        }
    }

    /**
    Item height ratio relative to it's width
    */
    public var itemHeightRatio: CGFloat = 1 {
        didSet {
            _itemSize = estimatedItemSize()
        }
    }

    /**
    Size for each item
    */
    public var itemSize: CGSize {
        get {
           return _itemSize
        }
    }

    var items = 0
    var rows = 0
    var _itemSize = CGSizeZero

    public override func prepareLayout() {
        // Set total number of items and rows
        items = estimatedNumberOfItems()
        rows = items / itemsPerRow + ((items % itemsPerRow > 0) ? 1 : 0)

        // Set item size
        _itemSize = estimatedItemSize()
    }

    /**
     See UICollectionViewLayout documentation
     */
    public override func collectionViewContentSize() -> CGSize {
        guard let collectionView = collectionView where rows > 0 else {
            return CGSizeZero
        }

        let height = estimatedRowHeight() * CGFloat(rows)
        return CGSize(width: collectionView.bounds.width, height: height)
    }

    /**
     See UICollectionViewLayout documentation
     */
    public override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return indexPathsInRect(rect).map { (indexPath) -> UICollectionViewLayoutAttributes in
            return self.layoutAttributesForItemAtIndexPath(indexPath)! // TODO: Fix forcefull unwrap
        }
    }

    /**
     See UICollectionViewLayout documentation
     */
    public override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let itemIndex = flatIndex(indexPath) // index among total number of items
        let rowIndex = itemIndex % itemsPerRow // index within it's row
        let row = itemIndex / itemsPerRow // which row for that item

        let x = (CGFloat(rowIndex) * itemSpacing) + (CGFloat(rowIndex) * itemSize.width)
        let y = (CGFloat(row) * itemSpacing) + (CGFloat(row) * itemSize.height)
        let width = _itemSize.width
        let height = _itemSize.height

        let attribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        attribute.frame = CGRect(x: x, y: y, width: width, height: height)

        return attribute
    }

    /**
     See UICollectionViewLayout documentation
     */
    public override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }

    // No decoration or supplementary views
    /**
    See UICollectionViewLayout documentation
    */
    public override func layoutAttributesForDecorationViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? { return nil }
    /**
     See UICollectionViewLayout documentation
     */
    public override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? { return nil }
}

extension GridCollectionViewLayout {
    /**
     Calculates which index paths are within a given rect
     - parameter rect: The rect which we want index paths for
     - returns: An array of indexPaths for that rect
     */
    func indexPathsInRect(rect: CGRect) -> [NSIndexPath] {
        let rowHeight = estimatedRowHeight()
        let startRow = (rect.origin.y / rowHeight < 0) ? 0 : Int(rect.origin.y / rowHeight)
        let endRow = ((rect.origin.y + rect.height) / rowHeight > CGFloat(rows)) ? rows : Int((rect.origin.y + rect.height) / rowHeight) + 1

        let startIndex = startRow * itemsPerRow
        let endIndex = (endRow * itemsPerRow + itemsPerRow > items) ? items-1 : endRow * itemsPerRow

        var indexPaths = [NSIndexPath]()
        for var index = startIndex; index <= endIndex; ++index {
            indexPaths.append(indexPathFromFlatIndex(index))
        }

        return indexPaths
    }

    /**
     Takes an index path (which are 2 dimensional) and turns it into a 1 dimensional index
     - parameter indexPath: The index path we want to flatten
     - returns: A flat index
     */
    func flatIndex(indexPath: NSIndexPath) -> Int {
        guard let collectionView = collectionView else {
            return 0
        }

        var index = indexPath.row

        for var section = 0; section < indexPath.section; ++section {
            index += collectionView.numberOfItemsInSection(section)
        }

        return index
    }

    /**
     Converts a flat index into an index path
     - parameter index: The flat index
     - returns: An index path
     */
    func indexPathFromFlatIndex(index: Int) -> NSIndexPath {
        guard let collectionView = collectionView else {
            return NSIndexPath(forItem: 0, inSection: 0)
        }

        var item = index
        var section = 0

        while(item >= collectionView.numberOfItemsInSection(section)) {
            item -= collectionView.numberOfItemsInSection(section)
            section += 1
        }

        return NSIndexPath(forItem: item, inSection: section)
    }

    /**
     Estimated the size of the items
     - returns: Estimated item size
     */
    func estimatedItemSize() -> CGSize {
        guard let collectionView = collectionView else {
            return CGSizeZero
        }

        let itemWidth = (collectionView.bounds.width - CGFloat(itemsPerRow - 1) * itemSpacing) / CGFloat(itemsPerRow)
        return CGSize(width: itemWidth, height: itemWidth * itemHeightRatio)
    }

    /**
     Estimated total number of items
     - returns: Total number of items
     */
    func estimatedNumberOfItems() -> Int {
        guard let collectionView = collectionView else {
            return 0
        }

        let sections = collectionView.numberOfSections()
        items = 0
        for var section = 0; section < sections; ++section { // TODO: Use flatIndex function
            items += collectionView.numberOfItemsInSection(section)
        }

        return items
    }

    /**
     Height for each row
     - returns: Row height
     */
    func estimatedRowHeight() -> CGFloat {
        return _itemSize.height+itemSpacing
    }
}
