//
//  Sprite.m
//  OpenGLViews
//
//  Created by Mihai Damian on 4/7/13.
//  Copyright (c) 2013 Mihai Damian. All rights reserved.
//

#import "Sprite.h"
#import "TextureAtlas.h"


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
@property (nonatomic, assign) CGSize faceSize;
@property (nonatomic, strong) TextureAtlas *textureAtlas;

@end


@implementation Sprite

- (id)initWithTextureAtlas:(TextureAtlas*)atlas effect:(GLKBaseEffect *)effect
{
    self = [super init];
    if(self != nil)
    {
        _effect = effect;
        _textureAtlas = atlas;
        
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

- (CGSize)faceSize
{
    return self.textureAtlas.textureSize;
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
    self.effect.texture2d0.name = self.textureAtlas.textureName;
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
