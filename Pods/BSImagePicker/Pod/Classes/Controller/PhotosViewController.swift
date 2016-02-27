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
import BSGridCollectionViewLayout

final class PhotosViewController : UICollectionViewController {    
    var selectionClosure: ((asset: PHAsset) -> Void)?
    var deselectionClosure: ((asset: PHAsset) -> Void)?
    var cancelClosure: ((assets: [PHAsset]) -> Void)?
    var finishClosure: ((assets: [PHAsset]) -> Void)?
    
    var doneBarButton: UIBarButtonItem?
    var cancelBarButton: UIBarButtonItem?
    var albumTitleView: AlbumTitleView?
    
    let expandAnimator = ZoomAnimator()
    let shrinkAnimator = ZoomAnimator()
    
    private var photosDataSource: PhotoCollectionViewDataSource?
    private var albumsDataSource: AlbumTableViewDataSource
    private let cameraDataSource: CameraCollectionViewDataSource
    private var composedDataSource: ComposedCollectionViewDataSource?
    
    private var defaultSelections: PHFetchResult?
    
    let settings: BSImagePickerSettings
    
    private var doneBarButtonTitle: String?
    
    lazy var albumsViewController: AlbumsViewController = {
        let storyboard = UIStoryboard(name: "Albums", bundle: BSImagePickerViewController.bundle)
        let vc = storyboard.instantiateInitialViewController() as! AlbumsViewController
        vc.tableView.dataSource = self.albumsDataSource
        vc.tableView.delegate = self
        
        return vc
    }()
    
    private lazy var previewViewContoller: PreviewViewController? = {
        return PreviewViewController(nibName: nil, bundle: nil)
    }()
    
    required init(fetchResults: [PHFetchResult], defaultSelections: PHFetchResult? = nil, settings aSettings: BSImagePickerSettings) {
        albumsDataSource = AlbumTableViewDataSource(fetchResults: fetchResults)
        cameraDataSource = CameraCollectionViewDataSource(settings: aSettings, cameraAvailable: UIImagePickerController.isSourceTypeAvailable(.Camera))
        self.defaultSelections = defaultSelections
        settings = aSettings
        
        super.init(collectionViewLayout: GridCollectionViewLayout())
        
        PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("b0rk: initWithCoder not implemented")
    }
    
    deinit {
        PHPhotoLibrary.sharedPhotoLibrary().unregisterChangeObserver(self)
    }
    
    override func loadView() {
        super.loadView()
        
        // Setup collection view
        collectionView?.backgroundColor = UIColor.whiteColor()
        collectionView?.allowsMultipleSelection = true
        
        // Set an empty title to get < back button
        title = " "
        
        // Set button actions and add them to navigation item
        doneBarButton?.target = self
        doneBarButton?.action = Selector("doneButtonPressed:")
        cancelBarButton?.target = self
        cancelBarButton?.action = Selector("cancelButtonPressed:")
        albumTitleView?.albumButton.addTarget(self, action: Selector("albumButtonPressed:"), forControlEvents: .TouchUpInside)
        navigationItem.leftBarButtonItem = cancelBarButton
        navigationItem.rightBarButtonItem = doneBarButton
        navigationItem.titleView = albumTitleView

        if let album = albumsDataSource.fetchResults.first?.firstObject as? PHAssetCollection {
            initializePhotosDataSource(album, selections: defaultSelections)
            updateAlbumTitle(album)
            synchronizeCollectionView()
        }
        
        // Add long press recognizer
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "collectionViewLongPressed:")
        longPressRecognizer.minimumPressDuration = 0.5
        collectionView?.addGestureRecognizer(longPressRecognizer)
        
        // Set navigation controller delegate
        navigationController?.delegate = self
        
        // Register cells
        photosDataSource?.registerCellIdentifiersForCollectionView(collectionView)
        cameraDataSource.registerCellIdentifiersForCollectionView(collectionView)
    }
    
    // MARK: Appear/Disappear
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        updateDoneButton()
    }
    
    // MARK: Button actions
    func cancelButtonPressed(sender: UIBarButtonItem) {
        guard let closure = cancelClosure, let photosDataSource = photosDataSource else {
            dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
            closure(assets: photosDataSource.selections)
        })
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func doneButtonPressed(sender: UIBarButtonItem) {
        guard let closure = finishClosure, let photosDataSource = photosDataSource else {
            dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
            closure(assets: photosDataSource.selections)
        })
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func albumButtonPressed(sender: UIButton) {
        guard let popVC = albumsViewController.popoverPresentationController else {
            return
        }
        
        popVC.permittedArrowDirections = .Up
        popVC.sourceView = sender
        let senderRect = sender.convertRect(sender.frame, fromView: sender.superview)
        let sourceRect = CGRect(x: senderRect.origin.x, y: senderRect.origin.y + (sender.frame.size.height / 2), width: senderRect.size.width, height: senderRect.size.height)
        popVC.sourceRect = sourceRect
        popVC.delegate = self
        albumsViewController.tableView.reloadData()
        
        presentViewController(albumsViewController, animated: true, completion: nil)
    }
    
    func collectionViewLongPressed(sender: UIGestureRecognizer) {
        if sender.state == .Began {
            // Disable recognizer while we are figuring out location and pushing preview
            sender.enabled = false
            collectionView?.userInteractionEnabled = false
            
            // Calculate which index path long press came from
            let location = sender.locationInView(collectionView)
            let indexPath = collectionView?.indexPathForItemAtPoint(location)
            
            if let vc = previewViewContoller, let indexPath = indexPath, let cell = collectionView?.cellForItemAtIndexPath(indexPath) as? PhotoCell, let asset = cell.asset {
                // Setup fetch options to be synchronous
                let options = PHImageRequestOptions()
                options.synchronous = true
                
                // Load image for preview
                if let imageView = vc.imageView {
                    PHCachingImageManager.defaultManager().requestImageForAsset(asset, targetSize:imageView.frame.size, contentMode: .AspectFit, options: options) { (result, _) in
                        imageView.image = result
                    }
                }
                
                // Setup animation
                expandAnimator.sourceImageView = cell.imageView
                expandAnimator.destinationImageView = vc.imageView
                shrinkAnimator.sourceImageView = vc.imageView
                shrinkAnimator.destinationImageView = cell.imageView
                
                navigationController?.pushViewController(vc, animated: true)
            }
            
            // Re-enable recognizer, after animation is done
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(expandAnimator.transitionDuration(nil) * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                sender.enabled = true
                self.collectionView?.userInteractionEnabled = true
            })
        }
    }
    
    // MARK: Private helper methods
    func updateDoneButton() {
        // Find right button
        if let subViews = navigationController?.navigationBar.subviews, let photosDataSource = photosDataSource {
            for view in subViews {
                if let btn = view as? UIButton where checkIfRightButtonItem(btn) {
                    // Store original title if we havn't got it
                    if doneBarButtonTitle == nil {
                        doneBarButtonTitle = btn.titleForState(.Normal)
                    }
                    
                    // Update title
                    if let doneBarButtonTitle = doneBarButtonTitle {
                        // Special case if we have selected 1 image and that is
                        // the max number of allowed selections
                        if (photosDataSource.selections.count == 1 && self.settings.maxNumberOfSelections == 1) {
                            btn.bs_setTitleWithoutAnimation("\(doneBarButtonTitle)", forState: .Normal)
                        } else if photosDataSource.selections.count > 0 {
                            btn.bs_setTitleWithoutAnimation("\(doneBarButtonTitle) (\(photosDataSource.selections.count))", forState: .Normal)
                        } else {
                            btn.bs_setTitleWithoutAnimation(doneBarButtonTitle, forState: .Normal)
                        }
                        
                        // Enabled?
                        doneBarButton?.enabled = photosDataSource.selections.count > 0
                    }
                    
                    // Stop loop
                    break
                }
            }
        }
    }
    
    // Check if a give UIButton is the right UIBarButtonItem in the navigation bar
    // Somewhere along the road, our UIBarButtonItem gets transformed to an UINavigationButton
    func checkIfRightButtonItem(btn: UIButton) -> Bool {
        guard let rightButton = navigationItem.rightBarButtonItem else {
            return false
        }
        
        // Store previous values
        let wasRightEnabled = rightButton.enabled
        let wasButtonEnabled = btn.enabled
        
        // Set a known state for both buttons
        rightButton.enabled = false
        btn.enabled = false
        
        // Change one and see if other also changes
        rightButton.enabled = true
        let isRightButton = btn.enabled
        
        // Reset
        rightButton.enabled = wasRightEnabled
        btn.enabled = wasButtonEnabled
        
        return isRightButton
    }
    
    func synchronizeSelectionInCollectionView(collectionView: UICollectionView) {
        guard let photosDataSource = photosDataSource else {
            return
        }
        
        // Get indexes of the selected assets
        let mutableIndexSet = NSMutableIndexSet()
        for object in photosDataSource.selections {
            let index = photosDataSource.fetchResult.indexOfObject(object)
            if index != NSNotFound {
                mutableIndexSet.addIndex(index)
            }
        }
        
        // Convert into index paths
        let indexPaths = mutableIndexSet.bs_indexPathsForSection(1)
        
        // Loop through them and set them as selected in the collection view
        for indexPath in indexPaths {
            collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: .None)
        }
    }
    
    func updateAlbumTitle(album: PHAssetCollection) {
        if let title = album.localizedTitle {
            // Update album title
            albumTitleView?.albumTitle = title
        }
    }
    
  func initializePhotosDataSource(album: PHAssetCollection, selections: PHFetchResult? = nil) {
        // Set up a photo data source with album
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.Image.rawValue)
        initializePhotosDataSourceWithFetchResult(PHAsset.fetchAssetsInAssetCollection(album, options: fetchOptions), selections: selections)
    }
    
    func initializePhotosDataSourceWithFetchResult(fetchResult: PHFetchResult, selections: PHFetchResult? = nil) {
        let newDataSource = PhotoCollectionViewDataSource(fetchResult: fetchResult, selections: selections, settings: settings)
        
        // Transfer image size
        // TODO: Move image size to settings
        if let photosDataSource = photosDataSource {
            newDataSource.imageSize = photosDataSource.imageSize
            newDataSource.selections = photosDataSource.selections
        }
        
        photosDataSource = newDataSource
        
        // Hook up data source
        composedDataSource = ComposedCollectionViewDataSource(dataSources: [cameraDataSource, newDataSource])
        collectionView?.dataSource = composedDataSource
        collectionView?.delegate = self
    }
    
    func synchronizeCollectionView() {
        guard let collectionView = collectionView else {
            return
        }
        
        // Reload and sync selections
        collectionView.reloadData()
        synchronizeSelectionInCollectionView(collectionView)
    }
}

// MARK: UICollectionViewDelegate
extension PhotosViewController {
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Camera shouldn't be selected, but pop the UIImagePickerController!
        if let composedDataSource = composedDataSource where composedDataSource.dataSources[indexPath.section].isEqual(cameraDataSource) {
            let cameraController = UIImagePickerController()
            cameraController.allowsEditing = false
            cameraController.sourceType = .Camera
            cameraController.delegate = self
            
            self.presentViewController(cameraController, animated: true, completion: nil)
            
            return false
        }
        
        return collectionView.userInteractionEnabled && photosDataSource!.selections.count < settings.maxNumberOfSelections
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let photosDataSource = photosDataSource, let cell = collectionView.cellForItemAtIndexPath(indexPath) as? PhotoCell, let asset = photosDataSource.fetchResult.objectAtIndex(indexPath.row) as? PHAsset else {
            return
        }
        
        // Select asset if not already selected
        photosDataSource.selections.append(asset)
        
        // Set selection number
        if let selectionCharacter = settings.selectionCharacter {
            cell.selectionString = String(selectionCharacter)
        } else {
            cell.selectionString = String(photosDataSource.selections.count)
        }
        
        // Update done button
        updateDoneButton()
        
        // Call selection closure
        if let closure = selectionClosure {
            dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
                closure(asset: asset)
            })
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        guard let photosDataSource = photosDataSource, let asset = photosDataSource.fetchResult.objectAtIndex(indexPath.row) as? PHAsset, let index = photosDataSource.selections.indexOf(asset) else {
            return
        }
        
        // Deselect asset
        photosDataSource.selections.removeAtIndex(index)
        
        // Update done button
        updateDoneButton()
        
        // Reload selected cells to update their selection number
        if let selectedIndexPaths = collectionView.indexPathsForSelectedItems() {
            UIView.setAnimationsEnabled(false)
            collectionView.reloadItemsAtIndexPaths(selectedIndexPaths)
            synchronizeSelectionInCollectionView(collectionView)
            UIView.setAnimationsEnabled(true)
        }
        
        // Call deselection closure
        if let closure = deselectionClosure {
            dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
                closure(asset: asset)
            })
        }
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? CameraCell else {
            return
        }
        
        cell.startLiveBackground() // Start live background
    }
}

// MARK: UIPopoverPresentationControllerDelegate
extension PhotosViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    func popoverPresentationControllerShouldDismissPopover(popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
}
// MARK: UINavigationControllerDelegate
extension PhotosViewController: UINavigationControllerDelegate {
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .Push {
            return expandAnimator
        } else {
            return shrinkAnimator
        }
    }
}

// MARK: UITableViewDelegate
extension PhotosViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Update photos data source
        if let album = albumsDataSource.fetchResults[indexPath.section][indexPath.row] as? PHAssetCollection {
            initializePhotosDataSource(album)
            updateAlbumTitle(album)
            synchronizeCollectionView()
        }
        
        // Dismiss album selection
        albumsViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: Traits
extension PhotosViewController {
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if let collectionViewFlowLayout = collectionViewLayout as? GridCollectionViewLayout {
            let itemSpacing: CGFloat = 2.0
            let cellsPerRow = settings.cellsPerRow(verticalSize: traitCollection.verticalSizeClass, horizontalSize: traitCollection.horizontalSizeClass)
            
            collectionViewFlowLayout.itemSpacing = itemSpacing
            collectionViewFlowLayout.itemsPerRow = cellsPerRow
            
            photosDataSource?.imageSize = collectionViewFlowLayout.itemSize
            
            updateDoneButton()
        }
    }
}

// MARK: UIImagePickerControllerDelegate
extension PhotosViewController: UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            picker.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        var placeholder: PHObjectPlaceholder?
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            let request = PHAssetChangeRequest.creationRequestForAssetFromImage(image)
            placeholder = request.placeholderForCreatedAsset
            }, completionHandler: { success, error in
                guard let placeholder = placeholder, let asset = PHAsset.fetchAssetsWithLocalIdentifiers([placeholder.localIdentifier], options: nil).firstObject as? PHAsset where success == true else {
                    picker.dismissViewControllerAnimated(true, completion: nil)
                    return
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    // TODO: move to a function. this is duplicated in didSelect
                    self.photosDataSource?.selections.append(asset)
                    self.updateDoneButton()
                    
                    // Call selection closure
                    if let closure = self.selectionClosure {
                        dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
                            closure(asset: asset)
                        })
                    }
                    
                    picker.dismissViewControllerAnimated(true, completion: nil)
                }
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: PHPhotoLibraryChangeObserver
extension PhotosViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(changeInstance: PHChange) {
        guard let photosDataSource = photosDataSource, let collectionView = collectionView else {
            return
        }
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if let photosChanges = changeInstance.changeDetailsForFetchResult(photosDataSource.fetchResult) {
                // Update collection view
                // Alright...we get spammed with change notifications, even when there are none. So guard against it
                if photosChanges.hasIncrementalChanges && (photosChanges.removedIndexes?.count > 0 || photosChanges.insertedIndexes?.count > 0 || photosChanges.changedIndexes?.count > 0) {
                    // Update fetch result
                    photosDataSource.fetchResult = photosChanges.fetchResultAfterChanges
                    
                    if let removed = photosChanges.removedIndexes {
                        collectionView.deleteItemsAtIndexPaths(removed.bs_indexPathsForSection(1))
                    }
                    
                    if let inserted = photosChanges.insertedIndexes {
                        collectionView.insertItemsAtIndexPaths(inserted.bs_indexPathsForSection(1))
                    }
                    
                    // Changes is causing issues right now...fix me later
                    // Example of issue:
                    // 1. Take a new photo
                    // 2. We will get a change telling to insert that asset
                    // 3. While it's being inserted we get a bunch of change request for that same asset
                    // 4. It flickers when reloading it while being inserted
                    // TODO: FIX
                    //                    if let changed = photosChanges.changedIndexes {
                    //                        print("changed")
                    //                        collectionView.reloadItemsAtIndexPaths(changed.bs_indexPathsForSection(1))
                    //                    }
                    
                    // Sync selection
                    self.synchronizeSelectionInCollectionView(collectionView)
                } else if photosChanges.hasIncrementalChanges == false {
                    // Update fetch result
                    photosDataSource.fetchResult = photosChanges.fetchResultAfterChanges
                    
                    collectionView.reloadData()
                    
                    // Sync selection
                    self.synchronizeSelectionInCollectionView(collectionView)
                }
            }
        })
        
        
        // TODO: Changes in albums
    }
}
