//
//  Sprite.m
//  OpenGLViews
//
//  Created by Mihai Damian on 4/7/13.
//  Copyright (c) 2013 Mihai Damian. All rights reserved.
//

#import "Sprite.h"

#import <QuartzCore/QuartzCore.h>


typedef struct {
    GLKVector3 geometryVertex;
    GLKVector3 textureVertex;
} TexturedVertex;


@interface Sprite()
{
    TexturedVertex _texturedVertices[4];
}

@property (nonatomic, strong) GLKBaseEffect * effect;
@property (nonatomic, assign) float rotation;
@property (nonatomic, assign) GLuint textureName;

@end


@implementation Sprite

- (id)initWithView:(UIView*)view effect:(GLKBaseEffect *)effect
{
    self = [super init];
    if(self != nil)
    {
        self.effect = effect;
        
        [self prerenderView:view];
        
        _texturedVertices[0].geometryVertex = GLKVector3Make(0, 0, 0);
        _texturedVertices[1].geometryVertex = GLKVector3Make(self.contentSize.width, 0, 0);
        _texturedVertices[2].geometryVertex = GLKVector3Make(0, self.contentSize.height, 0);
        _texturedVertices[3].geometryVertex = GLKVector3Make(self.contentSize.width, self.contentSize.height, 0);
        
        _texturedVertices[0].textureVertex = GLKVector3Make(0, 0, 0);
        _texturedVertices[1].textureVertex = GLKVector3Make(1, 0, 0);
        _texturedVertices[2].textureVertex = GLKVector3Make(0, 1, 0);
        _texturedVertices[3].textureVertex = GLKVector3Make(1, 1, 0);
    }
    
    return self;
}

- (void)prerenderView:(UIView*)view
{
    float contentScaleFactor = view.contentScaleFactor;
    
    self.contentSize = CGSizeMake(view.bounds.size.width * contentScaleFactor, view.bounds.size.height * contentScaleFactor);
    
    // make space for an RGBA image of the view
    GLubyte *pixelBuffer = (GLubyte *)malloc(4 * self.contentSize.width * self.contentSize.height);
    
    // create a suitable CoreGraphics context
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big;
    CGContextRef context = CGBitmapContextCreate(pixelBuffer, self.contentSize.width, self.contentSize.height, 8, 4 * self.contentSize.width, colourSpace, bitmapInfo);
    CGColorSpaceRelease(colourSpace);
    
    // Scale factor of the context and the view to be rendered need to match
    CGContextScaleCTM(context, contentScaleFactor, contentScaleFactor);
    
    // draw the view to the buffer
    [view.layer renderInContext:context];
    
    // upload to OpenGL
    glGenTextures(1, &_textureName);
	glBindTexture(GL_TEXTURE_2D, self.textureName);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, self.contentSize.width, self.contentSize.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, pixelBuffer);
    
    // clean up
    CGContextRelease(context);
    free(pixelBuffer);
}

- (GLKMatrix4)modelMatrix
{    
    GLKMatrix4 modelMatrix = GLKMatrix4Identity;
    modelMatrix = GLKMatrix4Translate(modelMatrix, self.position.x, self.position.y, 0);
    modelMatrix = GLKMatrix4Translate(modelMatrix, -self.contentSize.width / 2, -self.contentSize.height / 2, 0);
    modelMatrix = GLKMatrix4RotateY(modelMatrix, self.rotation);
    return modelMatrix;
}

- (void)render
{
    self.effect.texture2d0.name = self.textureName;
    self.effect.texture2d0.enabled = YES;
    GLKMatrix4 modelMatrix = self.modelMatrix;
    self.effect.transform.modelviewMatrix = GLKMatrix4Multiply([self.delegate viewMatrix], modelMatrix);
    
    [self.effect prepareToDraw];
    
    long offset = (long)&_texturedVertices;
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(TexturedVertex), (void *) (offset + offsetof(TexturedVertex, geometryVertex)));
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(TexturedVertex), (void *) (offset + offsetof(TexturedVertex, textureVertex)));
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

- (void)update:(float)dt
{    
//    self.rotation += 0.1;
}

@end
