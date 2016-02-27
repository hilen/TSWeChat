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
import UIImageViewModeScaleAspect

final class ZoomAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    var sourceImageView: UIImageView?
    var destinationImageView: UIImageView?
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // Get to and from view controller
        if let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey), let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey), let sourceImageView = sourceImageView, let destinationImageView = destinationImageView, let containerView = transitionContext.containerView() {
            // Disable selection so we don't select anything while the push animation is running
            fromViewController.view?.userInteractionEnabled = false
            
            // Setup views
            sourceImageView.hidden = true
            destinationImageView.hidden = true
            toViewController.view.alpha = 0.0
            fromViewController.view.alpha = 1.0
            containerView.backgroundColor = toViewController.view.backgroundColor
            
            // Setup scaling image
            let scalingFrame = containerView.convertRect(sourceImageView.frame, fromView: sourceImageView.superview)
            let scalingImage = UIImageViewModeScaleAspect(frame: scalingFrame)
            scalingImage.contentMode = sourceImageView.contentMode
            scalingImage.image = sourceImageView.image
            
            //Init image scale
            let destinationFrame = toViewController.view.convertRect(destinationImageView.bounds, fromView: destinationImageView.superview)
            if destinationImageView.contentMode == .ScaleAspectFit {
                scalingImage.initToScaleAspectFitToFrame(destinationFrame)
            } else {
                scalingImage.initToScaleAspectFillToFrame(destinationFrame)
            }
            
            // Add views to container view
            containerView.addSubview(toViewController.view)
            containerView.addSubview(scalingImage)
            
            // Animate
            UIView.animateWithDuration(transitionDuration(transitionContext),
                delay: 0.0,
                options: UIViewAnimationOptions.TransitionNone,
                animations: { () -> Void in
                    // Fade in
                    fromViewController.view.alpha = 0.0
                    toViewController.view.alpha = 1.0
                    
                    if destinationImageView.contentMode == .ScaleAspectFit {
                        scalingImage.animaticToScaleAspectFit()
                    } else {
                        scalingImage.animaticToScaleAspectFill()
                    }
                }, completion: { (finished) -> Void in
                    
                    // Finish image scaling and remove image view
                    if destinationImageView.contentMode == .ScaleAspectFit {
                        scalingImage.animateFinishToScaleAspectFit()
                    } else {
                        scalingImage.animateFinishToScaleAspectFill()
                    }
                    scalingImage.removeFromSuperview()
                    
                    // Unhide
                    destinationImageView.hidden = false
                    sourceImageView.hidden = false
                    fromViewController.view.alpha = 1.0
                    
                    // Finish transition
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                    
                    // Enable selection again
                    fromViewController.view?.userInteractionEnabled = true
            })
        }
    }
}
