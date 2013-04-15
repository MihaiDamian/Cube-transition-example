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
#import "SecondViewController.h"


@interface ViewController () <FirstViewControllerDelegate, SecondViewControllerDelegate>

@property (nonatomic, assign) NSUInteger controllersReady;
@property (nonatomic, strong) FirstViewController *firstController;
@property (nonatomic, strong) SecondViewController *secondController;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.firstController = [[FirstViewController alloc] initWithNibName:nil bundle:nil];
    [self addChildViewController:self.firstController];
    [self.view addSubview:self.firstController.view];
    [self.firstController didMoveToParentViewController:self];
    self.firstController.delegate = self;
    
    self.secondController = [[SecondViewController alloc] initWithNibName:nil bundle:nil];
    [self addChildViewController:self.secondController];
    [self.view addSubview:self.secondController.view];
    [self.secondController didMoveToParentViewController:self];
    self.secondController.delegate = self;
}

- (void)setControllersReady:(NSUInteger)controllersReady
{
    _controllersReady = controllersReady;
    
    if(_controllersReady == 2)
    {
        AnimationViewController *animationController = [[AnimationViewController alloc] initWithInitialView:self.firstController.view finalView:self.secondController.view];
        [self addChildViewController:animationController];
        animationController.view.frame = self.view.bounds;
        [self.view addSubview:animationController.view];
        [animationController didMoveToParentViewController:self];
    }
}

#pragma mark FirstViewControllerDelegate
- (void)firstControllerIsReadyForAnimation:(FirstViewController*)controller
{
    self.controllersReady++;
}

#pragma mark SecondViewControllerDelegate
- (void)secondControllerIsReadyForAnimation:(SecondViewController*)controller
{
    self.controllersReady++;
}

@end
