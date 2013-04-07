//
//  Sprite.m
//  OpenGLViews
//
//  Created by Mihai Damian on 4/7/13.
//  Copyright (c) 2013 Mihai Damian. All rights reserved.
//

#import "Sprite.h"


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
@property (nonatomic, strong) GLKTextureInfo * textureInfo;
@property (nonatomic, assign) float rotation;

@end


@implementation Sprite

- (id)initWithFile:(NSString *)fileName effect:(GLKBaseEffect *)effect
{
    self = [super init];
    if(self != nil)
    {
        self.effect = effect;
        
        NSError * error;
        NSDictionary *options = @{GLKTextureLoaderOriginBottomLeft : @YES};
        NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
        self.textureInfo = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
        if (self.textureInfo == nil)
        {
            NSLog(@"Error loading file: %@", [error localizedDescription]);
            return nil;
        }
        
        self.contentSize = CGSizeMake(self.textureInfo.width, self.textureInfo.height);
        
        TexturedQuad newQuad;
        newQuad.bl.geometryVertex = CGPointMake(0, 0);
        newQuad.br.geometryVertex = CGPointMake(self.textureInfo.width, 0);
        newQuad.tl.geometryVertex = CGPointMake(0, self.textureInfo.height);
        newQuad.tr.geometryVertex = CGPointMake(self.textureInfo.width, self.textureInfo.height);
        
        newQuad.bl.textureVertex = CGPointMake(0, 0);
        newQuad.br.textureVertex = CGPointMake(1, 0);
        newQuad.tl.textureVertex = CGPointMake(0, 1);
        newQuad.tr.textureVertex = CGPointMake(1, 1);
        self.quad = newQuad;
        
    }
    return self;
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
    self.effect.texture2d0.name = self.textureInfo.name;
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
