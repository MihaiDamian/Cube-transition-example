//
//  Sprite.h
//  OpenGLViews
//
//  Created by Mihai Damian on 4/7/13.
//  Copyright (c) 2013 Mihai Damian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>


@interface Sprite : NSObject

@property (assign) GLKVector2 position;
@property (assign) CGSize contentSize;

- (id)initWithView:(UIView*)view effect:(GLKBaseEffect *)effect;
- (void)render;
- (void)update:(float)dt;

@end
