//
//  FirstViewController.h
//  OpenGLViews
//
//  Created by Mihai Damian on 4/8/13.
//  Copyright (c) 2013 Mihai Damian. All rights reserved.
//

#import <UIKit/UIKit.h>


@class FirstViewController;


@protocol FirstViewControllerDelegate

- (void)firstControllerIsReadyForAnimation:(FirstViewController*)controller;

@end


@interface FirstViewController : UIViewController

@property (nonatomic, weak) id<FirstViewControllerDelegate> delegate;

@end
