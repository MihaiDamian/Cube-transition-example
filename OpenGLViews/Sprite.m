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
    CGPoint geometryVertex;
    CGPoint textureVertex;
} TexturedVertex;

typedef struct {
    TexturedVertex bl;
    TexturedVertex br;
    TexturedVertex tl;
    TexturedVertex tr;
} TexturedQuad;


@interface Sprite()

@property (nonatomic, strong) GLKBaseEffect * effect;
@property (nonatomic, assign) TexturedQuad quad;
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
        
        TexturedQuad newQuad;
        newQuad.bl.geometryVertex = CGPointMake(0, 0);
        newQuad.br.geometryVertex = CGPointMake(self.contentSize.width, 0);
        newQuad.tl.geometryVertex = CGPointMake(0, self.contentSize.height);
        newQuad.tr.geometryVertex = CGPointMake(self.contentSize.width, self.contentSize.height);
        
        newQuad.bl.textureVertex = CGPointMake(0, 0);
        newQuad.br.textureVertex = CGPointMake(1, 0);
        newQuad.tl.textureVertex = CGPointMake(0, 1);
        newQuad.tr.textureVertex = CGPointMake(1, 1);
        self.quad = newQuad;
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
    modelMatrix = GLKMatrix4Translate(modelMatrix, -self.contentSize.width / 2, -self.contentSize.height / 2, 0);
    modelMatrix = GLKMatrix4RotateY(modelMatrix, self.rotation);
    return modelMatrix;
}

- (void)render
{    
    self.effect.texture2d0.name = self.textureName;
    self.effect.texture2d0.enabled = YES;
    self.effect.transform.modelviewMatrix = self.modelMatrix;
    
    [self.effect prepareToDraw];
    
    long offset = (long)&_quad;
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, sizeof(TexturedVertex), (void *) (offset + offsetof(TexturedVertex, geometryVertex)));
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(TexturedVertex), (void *) (offset + offsetof(TexturedVertex, textureVertex)));
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

- (void)update:(float)dt
{    
//    self.rotation += 0.1;
}

@end
