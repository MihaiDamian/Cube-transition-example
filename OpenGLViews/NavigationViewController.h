//
//  NavigationViewController.h
//  OpenGLViews
//
//  Created by Mihai Damian on 4/4/13.
//  Copyright (c) 2013 Mihai Damian. All rights reserved.
//

#import <UIKit/UIKit.h>


@class AnimatableViewController;
@class NavigationViewController;


@protocol AnimatableViewControllerDelegate

// Call this after viewDidLayoutSubviews was called on AnimatableViewController
- (void)viewControllerIsReadyForAnimation:(AnimatableViewController*)controller;

@end


@interface AnimatableViewController : UIViewController

@property (nonatomic, weak) NavigationViewController *navigationViewController;
@property (nonatomic, weak) id<AnimatableViewControllerDelegate> animationDelegate;

@end


// TODO: find a better name
@interface NavigationViewController : UIViewController

- (id)initWithInitialViewController:(AnimatableViewController*)controller;

- (void)pushViewController:(AnimatableViewController*)controller;
- (void)popViewController;

@end
