//
//  Cube.h
//  OpenGLViews
//
//  Created by Mihai Damian on 4/7/13.
//  Copyright (c) 2013 Mihai Damian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>


@class TextureAtlas;


@protocol CubeDataSource

- (GLKMatrix4)viewMatrix;

@end


// A class that knows how to draw a textured cube. In practice, since our animation never shows more than two faces of a cube this
// class only constructs two cube faces.
@interface Cube : NSObject

@property (nonatomic, weak) id<CubeDataSource> dataSource;
@property (nonatomic, assign) GLfloat rotation;

- (id)initWithTextureAtlas:(TextureAtlas*)atlas effect:(GLKBaseEffect *)effect;

- (void)render;

@end
