//
//  NavigationViewController.h
//  OpenGLViews
//
//  Created by Mihai Damian on 4/4/13.
//  Copyright (c) 2013 Mihai Damian. All rights reserved.
//

#import <UIKit/UIKit.h>


// TODO: find a better name
@interface NavigationViewController : UIViewController

- (id)initWithInitialViewController:(UIViewController*)controller;

- (void)pushViewController:(UIViewController*)controller;
- (void)popViewController;

@end
