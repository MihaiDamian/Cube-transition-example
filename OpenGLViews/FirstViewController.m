//
//  FirstViewController.m
//  OpenGLViews
//
//  Created by Mihai Damian on 4/8/13.
//  Copyright (c) 2013 Mihai Damian. All rights reserved.
//

#import "FirstViewController.h"
#import "SecondViewController.h"


@implementation FirstViewController

- (void)viewDidLayoutSubviews
{
    [self.animationDelegate viewControllerIsReadyForAnimation:self];
}

- (IBAction)goForward:(id)sender
{
    SecondViewController *controller = [[SecondViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationViewController pushViewController:controller];
}

@end
