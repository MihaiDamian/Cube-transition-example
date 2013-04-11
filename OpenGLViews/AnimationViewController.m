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

@property (nonatomic, strong) UIView *initialView;
@property (nonatomic, strong) UIView *finalView;

@end


@implementation AnimationViewController

- (id)initWithInitialView:(UIView*)initialView finalView:(UIView*)finalView
{
    self = [super initWithNibName:nil bundle:nil];
    if(self != nil)
    {
        self.initialView = initialView;
        self.finalView = finalView;
    }
    
    return self;
}

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
    
    CGFloat contentScaleFactor = view.contentScaleFactor;
    
    self.effect = [GLKBaseEffect new];
    GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(0, self.view.frame.size.width * contentScaleFactor, 0, self.view.frame.size.height * contentScaleFactor, -1024, 1024);
    self.effect.transform.projectionMatrix = projectionMatrix;

    self.initialView.contentScaleFactor = contentScaleFactor;
    self.sprite = [[Sprite alloc] initWithView:self.initialView effect:self.effect];
    self.sprite.position = GLKVector2Make(self.view.frame.size.width * contentScaleFactor / 2, self.view.frame.size.height * contentScaleFactor / 2);
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
