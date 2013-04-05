//
//  Renderer.h
//  OpenGLViews
//
//  Created by Mihai Damian on 4/4/13.
//  Copyright (c) 2013 Mihai Damian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>


@interface Renderer : NSObject

- (void)render;

- (BOOL)resizeFromLayer:(CAEAGLLayer*)layer;

@end
