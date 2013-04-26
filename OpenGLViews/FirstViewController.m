//
//  FirstViewController.m
//  OpenGLViews
//
//  Created by Mihai Damian on 4/8/13.
//  Copyright (c) 2013 Mihai Damian. All rights reserved.
//

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "NavigationViewController.h"


@implementation FirstViewController

- (IBAction)goForward:(id)sender
{
    SecondViewController *controller = [[SecondViewController alloc] initWithNibName:nil bundle:nil];
    controller.navigationViewController = self.navigationViewController;
    [self.navigationViewController pushViewController:controller];
}

@end
