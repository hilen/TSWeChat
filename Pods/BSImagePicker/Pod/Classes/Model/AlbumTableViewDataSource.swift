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
import Photos

/**
Implements the UITableViewDataSource protocol with a data source and cell factory
*/
final class AlbumTableViewDataSource : NSObject, UITableViewDataSource {
    let fetchResults: [PHFetchResult]
    private let albumCellIdentifier = "albumCell"
    
    init(fetchResults: [PHFetchResult]) {
        self.fetchResults = fetchResults
        
        super.init()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchResults.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResults[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(albumCellIdentifier, forIndexPath: indexPath) as! AlbumCell
        let cachingManager = PHCachingImageManager.defaultManager() as? PHCachingImageManager
        cachingManager?.allowsCachingHighQualityImages = false
        
        // Fetch album
        if let album = fetchResults[indexPath.section][indexPath.row] as? PHAssetCollection {
            // Title
            cell.albumTitleLabel.text = album.localizedTitle
            
            // Selection style
            cell.selectionStyle = .None
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [
                NSSortDescriptor(key: "creationDate", ascending: false)
            ]
            fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.Image.rawValue)
            
            let result = PHAsset.fetchAssetsInAssetCollection(album, options: fetchOptions)
            result.enumerateObjectsUsingBlock { (object, idx, stop) in
                if let asset = object as? PHAsset {
                    let imageSize = CGSize(width: 79, height: 79)
                    let imageContentMode: PHImageContentMode = .AspectFill
                    switch idx {
                    case 0:
                        PHCachingImageManager.defaultManager().requestImageForAsset(asset, targetSize: imageSize, contentMode: imageContentMode, options: nil) { (result, _) in
                            cell.firstImageView.image = result
                            cell.secondImageView.image = result
                            cell.thirdImageView.image = result
                        }
                    case 1:
                        PHCachingImageManager.defaultManager().requestImageForAsset(asset, targetSize: imageSize, contentMode: imageContentMode, options: nil) { (result, _) in
                            cell.secondImageView.image = result
                            cell.thirdImageView.image = result
                        }
                    case 2:
                        PHCachingImageManager.defaultManager().requestImageForAsset(asset, targetSize: imageSize, contentMode: imageContentMode, options: nil) { (result, _) in
                            cell.thirdImageView.image = result
                        }
                        
                    default:
                        // Stop enumeration
                        stop.initialize(true)
                    }
                }
            }
        }
        
        return cell
    }
}
