//
//  RYPlayControl.m
//  Ryff
//
//  Created by Christopher Laganiere on 7/24/14.
//  Copyright (c) 2014 Chris Laganiere. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "RYPlayControl.h"

// Custom UI
#import "RYStyleSheet.h"

#define kAnimationDuration 1.0f

@interface RYPlayControl ()

@property (nonatomic, strong) CAShapeLayer *circleShape;
@property (nonatomic, strong) CAShapeLayer *innerCircleShape;

// Data
@property (nonatomic, strong) NSTimer *rotationAnimationTimer;

@end

@implementation RYPlayControl

- (void) configureWithFrame:(CGRect)frame
{
    CGFloat outerStrokeWidth = 3.0f;
    CGFloat innerStrokeWidth = 6.0f;
    
    _circleShape      = [CAShapeLayer layer];
    CGPoint circleCenter        = CGPointMake(frame.size.width/2, frame.size.height/2);
    _circleShape.path           = [UIBezierPath bezierPathWithArcCenter:circleCenter radius:(frame.size.width-outerStrokeWidth/2) / 2 startAngle:-M_PI_2 endAngle:-M_PI_2 + 2 * M_PI clockwise:YES].CGPath;
    _circleShape.strokeColor    = [RYStyleSheet actionColor].CGColor;
    _circleShape.fillColor      = nil;
    _circleShape.lineWidth      = outerStrokeWidth;
    _circleShape.strokeEnd      = 1.0f;
    [self.layer addSublayer:_circleShape];
    
    
    _innerCircleShape                = [CAShapeLayer layer];
    _innerCircleShape.path           = [UIBezierPath bezierPathWithArcCenter:circleCenter radius:(frame.size.width-innerStrokeWidth-outerStrokeWidth) / 2 startAngle:-M_PI_2 endAngle:-M_PI_2 + 2 * M_PI clockwise:YES].CGPath;
    _innerCircleShape.strokeColor    = [RYStyleSheet actionColor].CGColor;
    _innerCircleShape.fillColor      = nil;
    _innerCircleShape.lineWidth      = innerStrokeWidth;
    _innerCircleShape.strokeEnd      = 0.2f;
    _innerCircleShape.anchorPoint    = (CGPoint){0.5, 0.5};
    _innerCircleShape.bounds         = frame;
    _innerCircleShape.position       = circleCenter;
    [self.layer addSublayer:_innerCircleShape];
}

#pragma mark - 
#pragma mark - Animations

- (void) animateOuterProgress:(CGFloat)progress
{
    [self animateFill:_circleShape toStrokeEnd:progress];
}

- (void) animateInnerProgress:(CGFloat)progress
{
    [self animateFill:_innerCircleShape toStrokeEnd:progress];
}

- (void) animatePlaying
{
    [self animateOuterProgress:1.0f];
    
    [self doRotation];
    [_rotationAnimationTimer invalidate];
    _rotationAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:kAnimationDuration target:self selector:@selector(rotationAnimationTimerTick:) userInfo:nil repeats:YES];
}

#pragma mark - Internal

- (void) rotationAnimationTimerTick:(NSTimer*)timer
{
    [self doRotation];
}

- (void) doRotation
{
    [self animateRotate:_innerCircleShape toRotationEnd:2*M_PI withDuration:kAnimationDuration];
}

- (void) animateFill:(CAShapeLayer*)shapeLayer toStrokeEnd:(CGFloat)strokeEnd
{
    [shapeLayer removeAnimationForKey:@"strokeEnd"];
    
    CGFloat animationDuration = 0.1f;
    
    CABasicAnimation *fillStroke = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    fillStroke.duration          = animationDuration;
    fillStroke.fromValue         = @(shapeLayer.strokeEnd);
    fillStroke.toValue           = @(strokeEnd);
    shapeLayer.strokeEnd         = strokeEnd;
    [shapeLayer addAnimation:fillStroke forKey:@"fill stroke"];
}

- (void) animateRotate:(CAShapeLayer*)shapeLayer toRotationEnd:(CGFloat)rotationEnd withDuration:(CGFloat)animationDuration
{
    [shapeLayer removeAnimationForKey:@"transform.rotation"];
    
    NSNumber *rotationAtStart = [shapeLayer valueForKeyPath:@"transform.rotation"];
    CATransform3D myRotationTransform = CATransform3DRotate(shapeLayer.transform, rotationEnd, 0.0, 0.0, 1.0);
    shapeLayer.transform = myRotationTransform;
    CABasicAnimation *myAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    myAnimation.duration = animationDuration;
    myAnimation.fromValue = rotationAtStart;
    myAnimation.toValue = [NSNumber numberWithFloat:([rotationAtStart floatValue] + rotationEnd)];
    [shapeLayer addAnimation:myAnimation forKey:@"transform.rotation"];
}

@end