//
//  Catchable.h
//  ARSpaceships
//
//  Created by Nick on 6/14/11.
//  Copyright 2011 Nick Waynik Jr. All rights reserved.
//


#import "cocos2d.h"

@interface Catchable : CCSprite{
    float yawPosition;
    float rollPosition;
    float kSpeedLeft;
    float kSpeedUp;
    float randomSpeed;
    float TimeToMove;
    int scaleTimer;
    float scaleSpeed;
    BOOL MovingUp;
    BOOL MovingRight;
    BOOL wasTouched;
    int CombineMoveCount;
    int StableCount;
    CCSprite *redSpot;
    float MaximumYaw;
    float initialYaw;
    float initialRoll;
    float yaw;
    float Xdest;
    float Ydest;
    float Zdest;
    float Rdest;
    float Xorg;
    float Yorg;
    float Zorg;
    float Rorg;
    float XInit;
    float EnableCatchTimer;
    BOOL EnableCatch;

}

@property (nonatomic, retain) CCSprite *redSpot;
@property (readwrite) float yawPosition;
@property (readwrite) float rollPosition;
@property (readwrite) float kSpeedLeft;
@property (readwrite) float kSpeedUp;
@property (readwrite) float TimeToMove;
@property (readwrite) int scaleTimer;
@property (readwrite) int CombineMoveCount;
@property (readwrite) int StableCount;
@property (readwrite) BOOL wasTouched;
@property (readwrite) float scaleSpeed;
@property (readwrite) BOOL MovingRight;
@property (readwrite) float MaximumYaw;
@property (readwrite) float initialYaw;
@property (readwrite) float initialRoll;
@property (readwrite) float yaw;
@property (readwrite) float randomSpeed;
@property (readwrite) float Xdest;
@property (readwrite) float Ydest;
@property (readwrite) float Zdest;
@property (readwrite) float Rdest;
@property (readwrite) float Xorg;
@property (readwrite) float Yorg;
@property (readwrite) float Zorg;
@property (readwrite) float Rorg;
@property (readwrite) float XInit;
@property (readwrite) float EnableCatchTimer;
@property (readwrite) BOOL EnableCatch;




- (void)updatePosition:(ccTime)delta;
- (void)updateScale:(ccTime)delta;
-(void)resetRandomMovement;
///////////////////////////////////////Radar System///////////////////////////////////////////////////
-(void)addRedSpot;
- (void)radarSystem;
-(float)circleRadius;
- (CGPoint) RotateAroundPt:(CGPoint) centerPt withAngle:(float) radAngle withRadius:(float) radius;
//////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)setInitialPosition:(CGPoint)postion;
-(void)checkTime:(ccTime)delta;
-(void)pauseCatchablesWithBool:(BOOL)pause;
-(void)moveCatchableToFront;

@end