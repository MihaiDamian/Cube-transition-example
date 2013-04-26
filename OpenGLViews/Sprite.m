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
    GLKVector3 vertexNormal;
} TexturedVertex;


@interface Sprite()
{
    TexturedVertex _texturedVertices[12];
}

@property (nonatomic, strong) GLKBaseEffect * effect;
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
        
        // We'll use vertex triangles instead of triangle strips since we'll need to two surface normals for the vertices on the common edge of the two faces
        
        // Face A
        _texturedVertices[0].geometryVertex = GLKVector3Make(-self.faceSize.width / 2, -self.faceSize.height / 2, self.faceSize.width / 2);
        _texturedVertices[1].geometryVertex = GLKVector3Make(-self.faceSize.width / 2, self.faceSize.height / 2, self.faceSize.width / 2);
        _texturedVertices[2].geometryVertex = GLKVector3Make(self.faceSize.width / 2, -self.faceSize.height / 2, self.faceSize.width / 2);
        _texturedVertices[3].geometryVertex = GLKVector3Make(self.faceSize.width / 2, -self.faceSize.height / 2, self.faceSize.width / 2);
        _texturedVertices[4].geometryVertex = GLKVector3Make(-self.faceSize.width / 2, self.faceSize.height / 2, self.faceSize.width / 2);
        _texturedVertices[5].geometryVertex = GLKVector3Make(self.faceSize.width / 2, self.faceSize.height / 2, self.faceSize.width / 2);
        // Face B
        _texturedVertices[6].geometryVertex = GLKVector3Make(self.faceSize.width / 2, -self.faceSize.height / 2, self.faceSize.width / 2);
        _texturedVertices[7].geometryVertex = GLKVector3Make(self.faceSize.width / 2, self.faceSize.height / 2, self.faceSize.width / 2);
        _texturedVertices[8].geometryVertex = GLKVector3Make(self.faceSize.width / 2, -self.faceSize.height / 2, -self.faceSize.width / 2);
        _texturedVertices[9].geometryVertex = GLKVector3Make(self.faceSize.width / 2, -self.faceSize.height / 2, -self.faceSize.width / 2);
        _texturedVertices[10].geometryVertex = GLKVector3Make(self.faceSize.width / 2, self.faceSize.height / 2, self.faceSize.width / 2);
        _texturedVertices[11].geometryVertex = GLKVector3Make(self.faceSize.width / 2, self.faceSize.height / 2, -self.faceSize.width / 2);
        
        // Face A
        _texturedVertices[0].textureVertex = GLKVector2Make(0, 0);
        _texturedVertices[1].textureVertex = GLKVector2Make(0, 1);
        _texturedVertices[2].textureVertex = GLKVector2Make(0.5, 0);
        _texturedVertices[3].textureVertex = GLKVector2Make(0.5, 0);
        _texturedVertices[4].textureVertex = GLKVector2Make(0, 1);
        _texturedVertices[5].textureVertex = GLKVector2Make(0.5, 1);
        // Face B
        _texturedVertices[6].textureVertex = GLKVector2Make(0.5, 0);
        _texturedVertices[7].textureVertex = GLKVector2Make(0.5, 1);
        _texturedVertices[8].textureVertex = GLKVector2Make(1, 0);
        _texturedVertices[9].textureVertex = GLKVector2Make(1, 0);
        _texturedVertices[10].textureVertex = GLKVector2Make(0.5, 1);
        _texturedVertices[11].textureVertex = GLKVector2Make(1, 1);
        
        // Face A
        _texturedVertices[0].vertexNormal = GLKVector3Make(0, 0, 1);
        _texturedVertices[1].vertexNormal = GLKVector3Make(0, 0, 1);
        _texturedVertices[2].vertexNormal = GLKVector3Make(0, 0, 1);
        _texturedVertices[3].vertexNormal = GLKVector3Make(0, 0, 1);
        _texturedVertices[4].vertexNormal = GLKVector3Make(0, 0, 1);
        _texturedVertices[5].vertexNormal = GLKVector3Make(0, 0, 1);
        // Face B
        _texturedVertices[6].vertexNormal = GLKVector3Make(1, 0, 0);
        _texturedVertices[7].vertexNormal = GLKVector3Make(1, 0, 0);
        _texturedVertices[8].vertexNormal = GLKVector3Make(1, 0, 0);
        _texturedVertices[9].vertexNormal = GLKVector3Make(1, 0, 0);
        _texturedVertices[10].vertexNormal = GLKVector3Make(1, 0, 0);
        _texturedVertices[11].vertexNormal = GLKVector3Make(1, 0, 0);
    }
    
    return self;
}

- (void)dealloc
{
    glDeleteTextures(1, &_textureName);
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

    // Uncomment to see the texture exported to a file
    
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
    modelMatrix = GLKMatrix4Translate(modelMatrix, 0, 0, -self.faceSize.width / 2);
    modelMatrix = GLKMatrix4RotateY(modelMatrix, self.rotation);
    return modelMatrix;
}

- (void)render
{
    self.effect.texture2d0.name = self.textureName;
    self.effect.texture2d0.enabled = GL_TRUE;
    self.effect.texture2d0.envMode = GLKTextureEnvModeModulate;
    GLKMatrix4 modelMatrix = self.modelMatrix;
    self.effect.transform.modelviewMatrix = GLKMatrix4Multiply([self.delegate viewMatrix], modelMatrix);
    
    [self.effect prepareToDraw];
    
    long offset = (long)&_texturedVertices;
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(TexturedVertex), (void *) (offset + offsetof(TexturedVertex, geometryVertex)));
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(TexturedVertex), (void *) (offset + offsetof(TexturedVertex, textureVertex)));
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, sizeof(TexturedVertex), (void *) (offset + offsetof(TexturedVertex, vertexNormal)));
    
    glDrawArrays(GL_TRIANGLES, 0, sizeof(_texturedVertices) / sizeof(TexturedVertex));
}

@end
