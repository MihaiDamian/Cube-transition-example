//
//  AnimationViewController.m
//  OpenGLViews
//
//  Created by Mihai Damian on 4/4/13.
//  Copyright (c) 2013 Mihai Damian. All rights reserved.
//

#import "AnimationViewController.h"
#import "EAGLView.h"


@interface AnimationViewController ()

@property (nonatomic, weak) IBOutlet EAGLView *eaglView;

@end


@implementation AnimationViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.eaglView startAnimating];
}

@end
