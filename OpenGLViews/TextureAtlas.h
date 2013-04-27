//
//  TextureAtlas.h
//  OpenGLViews
//
//  Created by Mihai Damian on 4/26/13.
//  Copyright (c) 2013 Mihai Damian. All rights reserved.
//

#import <Foundation/Foundation.h>


// Creates an OpenGL texture from two views. Assumes the views have the same size and content scale factor.


@interface TextureAtlas : NSObject

// One texture containing the two rendered views
@property (nonatomic, assign, readonly) GLuint textureName;
// All textures in this atlas have the same size
@property (nonatomic, assign, readonly) CGSize textureSize;

- (id)initWithFirstView:(UIView*)view1 secondView:(UIView*)view2;

@end
