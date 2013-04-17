//
//  NavigationViewController.m
//  OpenGLViews
//
//  Created by Mihai Damian on 4/4/13.
//  Copyright (c) 2013 Mihai Damian. All rights reserved.
//

#import "NavigationViewController.h"
#import "AnimationViewController.h"


@implementation AnimatableViewController

@end


@interface NavigationViewController () <AnimationViewControllerDelegate>

@property (nonatomic, weak) UIViewController *currentViewController;
@property (nonatomic, strong) NSMutableArray *viewControllers;

@end


@implementation NavigationViewController

- (id)initWithInitialViewController:(AnimatableViewController*)controller
{
    self = [super initWithNibName:nil bundle:nil];
    if(self != nil)
    {
        _viewControllers = [NSMutableArray arrayWithObject:controller];
        controller.navigationViewController = self;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self presentViewController:[self.viewControllers lastObject]];
}

- (void)pushViewController:(AnimatableViewController*)controller
{
    controller.navigationViewController = self;
    
    AnimatableViewController *initialViewController = [self.viewControllers lastObject];
    AnimationViewController *animation = [[AnimationViewController alloc] initWithInitialView:initialViewController.view
                                                                                    finalView:controller.view
                                                                           animationDirection:AnimationDirectionForward];
    animation.animationDelegate = self;
    [self presentViewController:animation];
    
    [self.viewControllers addObject:controller];
}

- (void)popViewController
{
    // Do not pop the stack if there are not at least two controllers on it
    if([self.viewControllers count] < 2)
    {
        return;
    }
    
    AnimatableViewController *initialViewController = [self.viewControllers lastObject];
    AnimatableViewController *finalViewController = [self.viewControllers objectAtIndex:[self.viewControllers count] - 2];
    AnimationViewController *animation = [[AnimationViewController alloc] initWithInitialView:initialViewController.view
                                                                                    finalView:finalViewController.view
                                                                           animationDirection:AnimationDirectionBack];
    animation.animationDelegate = self;
    [self presentViewController:animation];
    
    [self.viewControllers removeLastObject];
}

#pragma mark ViewController container
- (void)presentViewController:(UIViewController*)controller
{
    [self dismissCurrentViewController];
    
    [self addChildViewController:controller];
    controller.view.frame = self.view.bounds;
    [self.view addSubview:controller.view];
    [controller didMoveToParentViewController:self];
    
    self.currentViewController = controller;
}

- (void)dismissCurrentViewController
{
    [self.currentViewController willMoveToParentViewController:nil];
    [self.currentViewController.view removeFromSuperview];
    [self.currentViewController removeFromParentViewController];
    self.currentViewController = nil;
}

#pragma mark AnimationViewControllerDelegate
- (void)didFinishAnimation
{
    // Remove the animation and present the view controller on top of the stack
    [self presentViewController:[self.viewControllers lastObject]];
}

@end
