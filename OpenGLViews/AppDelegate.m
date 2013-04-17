//
//  AppDelegate.m
//  OpenGLViews
//
//  Created by Mihai Damian on 4/4/13.
//  Copyright (c) 2013 Mihai Damian. All rights reserved.
//

#import "AppDelegate.h"
#import "NavigationViewController.h"
#import "FirstViewController.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    FirstViewController *initialController = [[FirstViewController alloc] initWithNibName:nil bundle:nil];
    self.window.rootViewController = [[NavigationViewController alloc] initWithInitialViewController:initialController];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
