//
//  Sprite.h
//  OpenGLViews
//
//  Created by Mihai Damian on 4/7/13.
//  Copyright (c) 2013 Mihai Damian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>


@protocol SpriteDelegate

- (GLKMatrix4)viewMatrix;

@end


@interface Sprite : NSObject

@property (nonatomic, weak) id<SpriteDelegate> delegate;
@property (nonatomic, assign) GLfloat rotation;

- (id)initWithFirstView:(UIView*)firstView secondView:(UIView*)secondView effect:(GLKBaseEffect *)effect;
- (void)render;

@end
