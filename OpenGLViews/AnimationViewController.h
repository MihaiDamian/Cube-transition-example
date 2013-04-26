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


@interface AnimationViewController : GLKViewController

@property (nonatomic, weak) id<AnimationViewControllerDelegate> animationDelegate;
// Default is 0.3 seconds
@property (nonatomic, assign) NSTimeInterval duration;

// Do not start the animation more than once
- (void)startAnimationWithInitialView:(UIView*)initialView finalView:(UIView*)finalView direction:(AnimationDirection)direction;

@end
