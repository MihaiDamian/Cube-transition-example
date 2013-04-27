//
//  AnimationViewController.h
//  OpenGLViews
//
//  Created by Mihai Damian on 4/4/13.
//  Copyright (c) 2013 Mihai Damian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>


@protocol AnimationViewControllerDelegate

- (void)didFinishAnimation;

@end


typedef NS_ENUM(NSUInteger, AnimationDirection)
{
    AnimationDirectionForward,
    AnimationDirectionBack
};


// A controller that renders a cube animation similar to CATransition's private 'cube' animation type
@interface AnimationViewController : GLKViewController

@property (nonatomic, weak) id<AnimationViewControllerDelegate> animationDelegate;
// Default is 1 seconds
@property (nonatomic, assign) NSTimeInterval duration;

// Do not start the animation more than once.
// Make sure the views are layed out before calling this method, as any new updates after this point will only be visible after the animation has finished.
- (void)startAnimationWithInitialView:(UIView*)initialView finalView:(UIView*)finalView direction:(AnimationDirection)direction;

@end
