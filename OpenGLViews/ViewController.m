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


@interface ViewController () <AnimationViewControllerDataSource>

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AnimationViewController *controller = [[AnimationViewController alloc] initWithNibName:nil bundle:nil];
    controller.dataSource = self;
    [self addChildViewController:controller];
    controller.view.frame = self.view.bounds;
    [self.view addSubview:controller.view];
    [controller didMoveToParentViewController:self];
}

#pragma mark AnimationViewControllerDataSource
- (UIView*)leftView
{
    return [[FirstViewController alloc] initWithNibName:nil bundle:nil].view;
}

@end
