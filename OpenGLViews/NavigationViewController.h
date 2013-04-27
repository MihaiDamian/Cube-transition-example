//
//  NavigationViewController.h
//  OpenGLViews
//
//  Created by Mihai Damian on 4/4/13.
//  Copyright (c) 2013 Mihai Damian. All rights reserved.
//

#import <UIKit/UIKit.h>


// Simulates the UInavigationController. Uses AnimationViewController to display a custom animation when transitioning between view controllers
@interface NavigationViewController : UIViewController

- (id)initWithInitialViewController:(UIViewController*)controller;

- (void)pushViewController:(UIViewController*)controller;
- (void)popViewController;

@end
