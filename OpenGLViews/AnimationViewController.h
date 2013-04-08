//
//  AnimationViewController.h
//  OpenGLViews
//
//  Created by Mihai Damian on 4/4/13.
//  Copyright (c) 2013 Mihai Damian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>


@protocol AnimationViewControllerDataSource

- (UIView*)leftView;

@end


@interface AnimationViewController : GLKViewController

@property (nonatomic, weak) id<AnimationViewControllerDataSource> dataSource;

@end
