//
//  AnimationViewController.m
//  OpenGLViews
//
//  Created by Mihai Damian on 4/4/13.
//  Copyright (c) 2013 Mihai Damian. All rights reserved.
//

#import "AnimationViewController.h"
#import "Sprite.h"


static GLfloat FOV = M_PI / 4;
static GLfloat TargetFPS = 60;


@interface AnimationViewController () <SpriteDelegate>

@property (nonatomic, strong) Sprite *sprite;
@property (nonatomic, strong) GLKBaseEffect *effect;

@property (nonatomic, strong) UIView *initialView;
@property (nonatomic, strong) UIView *finalView;

@property (nonatomic, assign) AnimationDirection direction;

@end


@implementation AnimationViewController

- (id)initWithInitialView:(UIView*)initialView finalView:(UIView*)finalView animationDirection:(AnimationDirection)direction
{
    self = [super initWithNibName:nil bundle:nil];
    if(self != nil)
    {
        _initialView = initialView;
        _finalView = finalView;
        
        // TODO: resolve this
        _finalView.frame = self.initialView.frame;
        
        _direction = direction;
        
        _animationDuration = 1;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([EAGLContext currentContext] == nil)
    {
        EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        if(context == nil)
        {
            NSLog(@"Failed to create ES context");
        }
        if(![EAGLContext setCurrentContext:context])
        {
            NSLog(@"Could not set EAGL Context");
        }
    }
    
    self.preferredFramesPerSecond = TargetFPS;
    
    GLKView *view = (GLKView *)self.view;
    view.context = [EAGLContext currentContext];
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    CGFloat contentScaleFactor = view.contentScaleFactor;

    self.effect = [GLKBaseEffect new];
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(FOV, view.frame.size.width / view.frame.size.height, 1, 5000);
    self.effect.transform.projectionMatrix = projectionMatrix;
    // No need for specular reflection
    self.effect.material.ambientColor = GLKVector4Make(0.1, 0.1, 0.1, 1);
    self.effect.material.diffuseColor = GLKVector4Make(1, 1, 1, 1);
    self.effect.light0.ambientColor = GLKVector4Make(1, 1, 1, 1);
    self.effect.light0.diffuseColor = GLKVector4Make(1, 1, 1, 1);
    // Define a directional light shining from the user's position down on the object
    self.effect.light0.position = GLKVector4Make(0, 0, 1, 0);
    self.effect.light0.enabled = GL_TRUE;

    self.initialView.contentScaleFactor = contentScaleFactor;
    self.finalView.contentScaleFactor = contentScaleFactor;
    if(self.direction == AnimationDirectionForward)
    {
        self.sprite = [[Sprite alloc] initWithFirstView:self.initialView secondView:self.finalView effect:self.effect];
    }
    else if(self.direction == AnimationDirectionBack)
    {
        self.sprite = [[Sprite alloc] initWithFirstView:self.finalView secondView:self.initialView effect:self.effect];
    }
    self.sprite.delegate = self;
    if(self.direction == AnimationDirectionBack)
    {
        self.sprite.rotation = -M_PI / 2;
    }
}

- (void)update
{
    GLfloat rotationSpeed = (M_PI / 2) / self.animationDuration;
    GLfloat rotation = rotationSpeed * self.timeSinceLastUpdate;
    
    if(self.direction == AnimationDirectionForward)
    {
        self.sprite.rotation -= rotation;
        if(self.sprite.rotation <= -M_PI / 2)
        {
            [self.animationDelegate didFinishAnimation];
        }
    }
    else if(self.direction == AnimationDirectionBack)
    {
        self.sprite.rotation += rotation;
        if(self.sprite.rotation >= 0)
        {
            [self.animationDelegate didFinishAnimation];
        }
    }
}

#pragma mark GLKViewDelegate
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0, 0, 0, 1);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_CULL_FACE);
    glCullFace(GL_FRONT);
    
    [self.sprite render];
}

#pragma mark SpriteDelegate
- (GLKMatrix4)viewMatrix
{
    // Calculate eye Z position so that a slice through Z 0 has the same size as the view
    float projectionOppositeAngle = M_PI - M_PI / 2 - FOV / 2;
    float eyeZ = (sin(projectionOppositeAngle) * (self.view.frame.size.height * self.view.contentScaleFactor / 2)) / sin(FOV / 2);
    return GLKMatrix4MakeLookAt(0, 0, eyeZ, 0, 0, 0, 0, 1, 0);
}

@end
