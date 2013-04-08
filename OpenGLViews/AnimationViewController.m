//
//  AnimationViewController.m
//  OpenGLViews
//
//  Created by Mihai Damian on 4/4/13.
//  Copyright (c) 2013 Mihai Damian. All rights reserved.
//

#import "AnimationViewController.h"
#import "Sprite.h"


@interface AnimationViewController ()

@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, strong) Sprite *sprite;
@property (nonatomic, strong) GLKBaseEffect *effect;

@end


@implementation AnimationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if(!self.context)
    {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    [EAGLContext setCurrentContext:self.context];
    
    self.effect = [GLKBaseEffect new];
    GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(0, self.view.frame.size.width, 0, self.view.frame.size.height, -1024, 1024);
    self.effect.transform.projectionMatrix = projectionMatrix;
    
    self.sprite = [[Sprite alloc] initWithView:[self.dataSource leftView] effect:self.effect];
    self.sprite.position = GLKVector2Make(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
}

- (void)update
{
    [self.sprite update:self.timeSinceLastUpdate];
}

#pragma mark GLKViewDelegate
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(1, 0, 1, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    
    [self.sprite render];
}

@end
