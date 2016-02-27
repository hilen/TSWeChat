UIImageViewModeScaleAspect (1.2)
================================

<p>Create animation of a UIImageView between two contentMode ( UIViewContentModeScaleAspectFill / UIViewContentModeScaleAspectFit )</p>
<a href="http://www.viviencormier.fr/" target="_blank">My WebSite</a> - <a href="https://twitter.com/VivienCormier" target="_blank">My Twitter</a>

Screenshot & Demo Video
-----------------------

<p>To see a demo video, click <a href="http://www.youtube.com/watch?v=vZYbQ0Yt8eQ" target="_blank">here</a></p>
<a href="http://www.youtube.com/watch?v=vZYbQ0Yt8eQ" target="_blank">
  <img alt="ScreenShot Demo Video" src="https://github.com/VivienCormier/UIImageViewModeScaleAspect/blob/master/Example/UIImageViewModeScaleAspect/UIImageViewModeScaleAspect/example_1.png?raw=true" width="500" height="391" />
  <img alt="ScreenShot Demo Video" src="https://github.com/VivienCormier/UIImageViewModeScaleAspect/blob/master/Example/UIImageViewModeScaleAspect/UIImageViewModeScaleAspect/example_2.png?raw=true" width="500" height="391" />
</a>

How To Get Started
------------------

<p>Use Pod (or download and add "UIImageViewModeScaleAspect.h" and "UIImageViewModeScaleAspect.m" in your xcodeprojet.) : </p>

``` objective-c
pod 'UIImageViewModeScaleAspect'
```

<p>Import the .h file :</p>
``` objective-c
#import "UIImageViewModeScaleAspect.h"
```

<p>Init the UIImageViewModeScaleAspect. Important ! Do not forget to init the contentMode :</p>
``` objective-c
UIImageViewModeScaleAspect *myImage = [[UIImageViewModeScaleAspect alloc]initWithFrame:CGRectMake(0, 100, 200, 100)];
myImage.contentMode = UIViewContentModeScaleAspectFill; // Add the first contentMode
myImage.image = [UIImage imageNamed:@"becomeapanda_tumblr_com"];
[self.view addSubview:myImage];
```

Automatic animation
-------------------

<p>For convert UIViewContentModeScaleAspectFill to UIViewContentModeScaleAspectFit :</p>
``` objective-c
[myImage animateToScaleAspectFitToFrame:CGRectMake(0, 0, 200, 200) WithDuration:0.4f afterDelay:0.0f];
```

<p>For convert UIViewContentModeScaleAspectFit to UIViewContentModeScaleAspectFill :</p>
``` objective-c
[myImage animateToScaleAspectFillToFrame:CGRectMake(0, 0, 200, 200) WithDuration:0.4f afterDelay:0.0f];
```

Manual animation
----------------

<p>For convert UIViewContentModeScaleAspectFill to UIViewContentModeScaleAspectFit :</p>
``` objective-c
[myImage initToScaleAspectFillToFrame:CGRectMake(0, 100, 200, 100)];
        
[UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction
                 animations:^{
                     //
                     // Others Animation
                     //
                     [myImage animaticToScaleAspectFill];
                     //
                     // Others Animation
                     //
                 } completion:^(BOOL finished) {
                     [myImage animateFinishToScaleAspectFill];
                 }];
```

<p>For convert UIViewContentModeScaleAspectFit to UIViewContentModeScaleAspectFill :</p>
``` objective-c
[myImage initToScaleAspectFitToFrame:CGRectMake(0, 0, 200, 200)];
        
[UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction
                 animations:^{
                     //
                     // Others Animation
                     //
                     [myImage animaticToScaleAspectFit];
                     //
                     // Others Animation
                     //
                 } completion:^(BOOL finished) {
                     [myImage animateFinishToScaleAspectFit];
                 }];
```
