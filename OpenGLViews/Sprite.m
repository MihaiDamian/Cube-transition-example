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
    GLKVector2 textureVertex;
} TexturedVertex;


@interface Sprite()
{
    TexturedVertex _texturedVertices[6];
}

@property (nonatomic, strong) GLKBaseEffect * effect;
@property (nonatomic, assign) float rotation;
@property (nonatomic, assign) GLuint textureName;
@property (nonatomic, assign) CGSize faceSize;

@end


@implementation Sprite

- (id)initWithFirstView:(UIView*)firstView secondView:(UIView*)secondView effect:(GLKBaseEffect *)effect
{
    self = [super init];
    if(self != nil)
    {
        NSAssert(firstView.contentScaleFactor == secondView.contentScaleFactor, @"For simplicity the views' content scale factors should be equal");
        NSAssert(CGSizeEqualToSize(firstView.frame.size, secondView.frame.size), @"For simplicity the views' size should be eqaul");
        
        self.effect = effect;
        CGFloat contentScaleFactor = firstView.contentScaleFactor;
        self.faceSize = CGSizeMake(firstView.bounds.size.width * contentScaleFactor, firstView.bounds.size.height * contentScaleFactor);
        
        [self prerenderFirstView:firstView secondView:secondView];
        
        _texturedVertices[0].geometryVertex = GLKVector3Make(0, 0, 0);
        _texturedVertices[1].geometryVertex = GLKVector3Make(0, self.faceSize.height, 0);
        _texturedVertices[2].geometryVertex = GLKVector3Make(self.faceSize.width, 0, 0);
        _texturedVertices[3].geometryVertex = GLKVector3Make(self.faceSize.width, self.faceSize.height, 0);
        _texturedVertices[4].geometryVertex = GLKVector3Make(self.faceSize.width, 0, -self.faceSize.width);
        _texturedVertices[5].geometryVertex = GLKVector3Make(self.faceSize.width, self.faceSize.height, -self.faceSize.width);
        
        _texturedVertices[0].textureVertex = GLKVector2Make(0, 0);
        _texturedVertices[1].textureVertex = GLKVector2Make(0, 1);
        _texturedVertices[2].textureVertex = GLKVector2Make(0.5, 0);
        _texturedVertices[3].textureVertex = GLKVector2Make(0.5, 1);
        _texturedVertices[4].textureVertex = GLKVector2Make(1, 0);
        _texturedVertices[5].textureVertex = GLKVector2Make(1, 1);
    }
    
    return self;
}

- (void)prerenderFirstView:(UIView*)firstView secondView:(UIView*)secondView
{
    CGFloat contentScaleFactor = firstView.contentScaleFactor;
    
    // We'll be drawing the views side by side so we reserve double the width
    CGSize atlasSize = CGSizeMake(firstView.bounds.size.width * contentScaleFactor * 2, firstView.bounds.size.height * contentScaleFactor);
    
    // make space for an RGBA image of the view
    GLubyte *pixelBuffer = (GLubyte *)malloc(4 * atlasSize.width * atlasSize.height);
    
    // create a suitable CoreGraphics context
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big;
    CGContextRef context = CGBitmapContextCreate(pixelBuffer, atlasSize.width, atlasSize.height, 8, 4 * atlasSize.width, colourSpace, bitmapInfo);
    CGColorSpaceRelease(colourSpace);
    
    // Scale factor of the context and the view to be rendered need to match
    CGContextScaleCTM(context, contentScaleFactor, contentScaleFactor);
    
    // Draw the first view to the context
    [firstView.layer renderInContext:context];
    
    // Move the context's origin so the second view is drawn to the right of the first view
    CGFloat xTranslation = firstView.bounds.size.width;
    CGContextTranslateCTM(context, xTranslation, 0);
    
    // Draw the second view to the context
    [secondView.layer renderInContext:context];
    
    // Reposition the context's origin to it's initial location
    CGContextTranslateCTM(context, -xTranslation, 0);
    
    // upload to OpenGL
    glGenTextures(1, &_textureName);
	glBindTexture(GL_TEXTURE_2D, self.textureName);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, atlasSize.width, atlasSize.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, pixelBuffer);
    
    
//    UIImage *image = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
//    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString * basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
//    NSData * binaryImageData = UIImagePNGRepresentation(image);
//    [binaryImageData writeToFile:[basePath stringByAppendingPathComponent:@"myfile.png"] atomically:YES];
    
    // clean up
    CGContextRelease(context);
    free(pixelBuffer);
}

- (GLKMatrix4)modelMatrix
{    
    GLKMatrix4 modelMatrix = GLKMatrix4Identity;
    modelMatrix = GLKMatrix4Translate(modelMatrix, self.position.x, self.position.y, 0);
    modelMatrix = GLKMatrix4Translate(modelMatrix, -self.faceSize.width / 2, -self.faceSize.height / 2, 0);
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
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 6);
}

- (void)update:(float)dt
{    
//    self.rotation -= 0.1;
}

@end
