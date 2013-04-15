//
//  FirstViewController.m
//  OpenGLViews
//
//  Created by Mihai Damian on 4/8/13.
//  Copyright (c) 2013 Mihai Damian. All rights reserved.
//

#import "FirstViewController.h"


@implementation FirstViewController

- (void)viewDidLayoutSubviews
{
    [self.delegate firstControllerIsReadyForAnimation:self];
}

@end
