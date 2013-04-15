//
//  SecondViewController.h
//  OpenGLViews
//
//  Created by Mihai Damian on 4/15/13.
//  Copyright (c) 2013 Mihai Damian. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SecondViewController;


@protocol SecondViewControllerDelegate

- (void)secondControllerIsReadyForAnimation:(SecondViewController*)controller;

@end


@interface SecondViewController : UIViewController

@property (nonatomic, weak) id<SecondViewControllerDelegate> delegate;

@end
