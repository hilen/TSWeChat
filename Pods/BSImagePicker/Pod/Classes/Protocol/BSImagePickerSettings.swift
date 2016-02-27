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

import Photos

/**
BSImagePicker settings. Tweaks these to make BSImagePicker fit your needs
*/
public protocol BSImagePickerSettings {
    /**
    Max number of images user can select
    */
    var maxNumberOfSelections: Int { get set }
    
    /**
    Character to use for selection. If nil, selection number will be used
    */
    var selectionCharacter: Character? { get set }
    
    /**
    Inner circle color
    */
    var selectionFillColor: UIColor { get set }
    
    /**
    Outer circle color
    */
    var selectionStrokeColor: UIColor { get set }
    
    /**
    Shadow color
    */
    var selectionShadowColor: UIColor { get set }
    
    /**
    Attributes for text inside circle. Color, font, etc
    */
    var selectionTextAttributes: [String: AnyObject] { get set }
    
    /**
    Return how many cells per row you want to show for the given size classes
    */
    var cellsPerRow: (verticalSize: UIUserInterfaceSizeClass, horizontalSize: UIUserInterfaceSizeClass) -> Int { get set }
    
    /**
    Toggle take photos
    */
    var takePhotos: Bool { get set }
    
    /**
     Icon to show in take photo cell. 
     If you use a black image tint color will be applied to it.
    */
    var takePhotoIcon: UIImage? { get set }
}