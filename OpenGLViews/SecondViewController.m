//
//  SecondViewController.m
//  OpenGLViews
//
//  Created by Mihai Damian on 4/15/13.
//  Copyright (c) 2013 Mihai Damian. All rights reserved.
//

#import "SecondViewController.h"


@implementation SecondViewController

- (void)viewDidLayoutSubviews
{
    [self.delegate secondControllerIsReadyForAnimation:self];
}

@end