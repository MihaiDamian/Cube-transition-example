//
//  TextureAtlas.m
//  OpenGLViews
//
//  Created by Mihai Damian on 4/26/13.
//  Copyright (c) 2013 Mihai Damian. All rights reserved.
//

#import "TextureAtlas.h"

#import <QuartzCore/QuartzCore.h>


@interface TextureAtlas ()

@property (nonatomic, assign, readwrite) GLuint textureName;
@property (nonatomic, assign, readwrite) CGSize textureSize;

@end


@implementation TextureAtlas

- (id)initWithFirstView:(UIView*)view1 secondView:(UIView*)view2
{
    NSAssert(view1.contentScaleFactor == view2.contentScaleFactor, @"Views have different content scale factors");
    NSAssert(CGSizeEqualToSize(view1.frame.size, view2.frame.size), @"Views have different sizes");
    
    self = [super init];
    if(self != nil)
    {
        CGFloat contentScaleFactor = view1.contentScaleFactor;
        _textureSize = CGSizeMake(view1.bounds.size.width * contentScaleFactor, view1.bounds.size.height * contentScaleFactor);
        
        // We'll be drawing the views side by side so we reserve double the width
        CGSize atlasSize = CGSizeMake(_textureSize.width * 2, view1.bounds.size.height * contentScaleFactor);
        
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
        [view1.layer renderInContext:context];
        
        // Move the context's origin so the second view is drawn to the right of the first view
        CGFloat xTranslation = view1.bounds.size.width;
        CGContextTranslateCTM(context, xTranslation, 0);
        
        // Draw the second view to the context
        [view2.layer renderInContext:context];
        
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
        
//        UIImage *image = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
//        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString * basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
//        NSData * binaryImageData = UIImagePNGRepresentation(image);
//        [binaryImageData writeToFile:[basePath stringByAppendingPathComponent:@"myfile.png"] atomically:YES];
        
        // clean up
        CGContextRelease(context);
        free(pixelBuffer);
    }
    
    return self;
}

- (void)dealloc
{
    // OpenGL allocated resources need to be dealloced manually
    glDeleteTextures(1, &_textureName);
}

@end
