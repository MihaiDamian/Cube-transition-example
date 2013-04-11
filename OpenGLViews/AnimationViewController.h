//
//  AnimationViewController.h
//  OpenGLViews
//
//  Created by Mihai Damian on 4/4/13.
//  Copyright (c) 2013 Mihai Damian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>


@interface AnimationViewController : GLKViewController

// AnimationViewController may decide to prerender the view parameters at any point after they are passed in.
// Therefore the caller needs to make sure that all necessary resized on these views have been carried out before calling this method.
// For performance resons, future updates to the views may not be reflected in the animation
- (id)initWithInitialView:(UIView*)initialView finalView:(UIView*)finalView;

@end
