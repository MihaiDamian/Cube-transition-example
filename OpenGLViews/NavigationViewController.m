//
//  NavigationViewController.m
//  OpenGLViews
//
//  Created by Mihai Damian on 4/4/13.
//  Copyright (c) 2013 Mihai Damian. All rights reserved.
//

#import "NavigationViewController.h"
#import "AnimationViewController.h"


@interface NavigationViewController () <AnimationViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, strong) AnimationViewController *animationController;

@end


@implementation NavigationViewController

- (id)initWithInitialViewController:(UIViewController*)controller
{
    self = [super initWithNibName:nil bundle:nil];
    if(self != nil)
    {
        _viewControllers = [NSMutableArray arrayWithObject:controller];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self presentViewController:[self.viewControllers lastObject]];
}

- (void)animateFromViewController:(UIViewController*)fromViewController toViewController:(UIViewController*)toViewController direction:(AnimationDirection)direction
{
    [self addChildViewController:toViewController];
    toViewController.view.frame = self.view.bounds;
    [fromViewController willMoveToParentViewController:nil];
    
    self.animationController = [[AnimationViewController alloc] initWithNibName:nil bundle:nil];
    self.animationController.view.frame = self.view.bounds;
    self.animationController.animationDelegate = self;
    [self presentViewController:self.animationController];
    
    __weak NavigationViewController *weakSelf = self;
    
    // This method is used to ensure that toViewController has layed out it's view before animation.
    // The duration parameter is 0 as we don't don't need to do any UIKit animations. Since AnimationViewController will be cover the entire screen for the
    // duration of the animation we use the oportunity of discarding the fromViewController early, on the completion block.
    [self transitionFromViewController:fromViewController toViewController:toViewController duration:0 options:UIViewAnimationOptionTransitionNone animations:^{
        [weakSelf.view bringSubviewToFront:weakSelf.animationController.view];
        [weakSelf.animationController startAnimationWithInitialView:fromViewController.view finalView:toViewController.view direction:direction];
    } completion:^(BOOL finished) {
        [fromViewController willMoveToParentViewController:nil];
        [fromViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:self];
    }];
}

#pragma mark Stack operations
- (void)pushViewController:(UIViewController*)toViewController
{
    UIViewController *fromViewController = [self.viewControllers lastObject];
    [self.viewControllers addObject:toViewController];
    
    [self animateFromViewController:fromViewController toViewController:toViewController direction:AnimationDirectionForward];
}

- (void)popViewController
{
    // Do not pop the stack if there are not at least two controllers on it
    if([self.viewControllers count] < 2)
    {
        return;
    }
    
    UIViewController *fromViewController = [self.viewControllers lastObject];
    UIViewController *toViewController = [self.viewControllers objectAtIndex:[self.viewControllers count] - 2];
    
    [self animateFromViewController:fromViewController toViewController:toViewController direction:AnimationDirectionBack];
    
    [self.viewControllers removeLastObject];
}

#pragma mark ViewController container
- (void)presentViewController:(UIViewController*)controller
{
    [self addChildViewController:controller];
    controller.view.frame = self.view.bounds;
    [self.view addSubview:controller.view];
    [controller didMoveToParentViewController:self];
}

- (void)dismissViewController:(UIViewController*)controller
{
    [controller willMoveToParentViewController:nil];
    [controller.view removeFromSuperview];
    [controller removeFromParentViewController];
}

#pragma mark AnimationViewControllerDelegate
- (void)didFinishAnimation
{
    [self dismissViewController:self.animationController];
}

@end
