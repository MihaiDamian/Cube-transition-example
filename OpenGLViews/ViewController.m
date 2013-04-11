//
//  ViewController.m
//  OpenGLViews
//
//  Created by Mihai Damian on 4/4/13.
//  Copyright (c) 2013 Mihai Damian. All rights reserved.
//

#import "ViewController.h"
#import "AnimationViewController.h"
#import "FirstViewController.h"


@interface ViewController () <FirstViewControllerDelegate>

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    FirstViewController *firstController = [[FirstViewController alloc] initWithNibName:nil bundle:nil];
    [self addChildViewController:firstController];
    [self.view addSubview:firstController.view];
    [firstController didMoveToParentViewController:self];
    firstController.delegate = self;
}

#pragma mark FirstViewControllerDelegate
- (void)controllerIsReadyForAnimation:(FirstViewController*)controller
{
    AnimationViewController *animationController = [[AnimationViewController alloc] initWithInitialView:controller.view finalView:nil];
    [self addChildViewController:animationController];
    animationController.view.frame = self.view.bounds;
    [self.view addSubview:animationController.view];
    [animationController didMoveToParentViewController:self];
}

@end
