//
//  CombineMovement.m
//  FunnyShake
//
//  Created by Zelin Ou on 7/21/11.
//  Copyright 2011 iTeam. All rights reserved.
//




#import "CombineMovement.h"
#define kScallSpeed 5


static inline float lerpf(float a, float b, float t)
{
    return a + (b - a) * t;
}


@implementation CombineMovement

- (id)init
{
    self = [super init];
    if (self) {
        MovingRight = YES;
        MovingUp = YES;
        scaleTimer = 0;
        TimeToMove = 0.0;
        timer = CCRANDOM_0_1() * 2 + 1;
        self.scale = 1.5;
        progressTimer = 0.0;
        Zdest = self.scale;
        Zorg = self.scale;
    }
    
    return self;
}




//-(void)moveSelf:(ccTime)delta
//{
//
//    
//}

-(void)update:(ccTime)delta {
    [self updatePosition:delta];
    [self checkTime:delta];
    
    //NSLog(@"The yaw of the device is %f", yaw);
    //  NSLog(@"The scale of the catchable is %f", self.scale);
  //  NSLog(@"The Zdest is %f and Zorg is %f", Zdest, Zorg);

//////////////////Control the scale size of catchable instantly///////////////////
    if (Zdest > 3.0 || Zdest < 0.5) {
        
        Zorg = 1.5;
        Zdest = 1.5;
    }
    
}


-(void)checkTime:(ccTime)delta
{
 //   NSLog(@"timer: %f, progress: %f",timer, progressTimer);    
    
    if ( progressTimer > timer) {
        [self resetRandomMovement];
    }
    
}

- (BOOL)yawPositionWithinBounds:(float)value{
    
    
    return YES;
}

- (BOOL)rollPositionWithinBounds:(float)value{
    
    
    return YES;
}

- (int)scaleWithinBounds:(float)value{
    
    if (value <= 3.0 && value >= 1.5) {
        
        return 1;
    }
    
    if (value > 0.3 || value < 1.5) {
    //    NSLog(@"I am out of bounds!");
        return 2;
    }
    
//    if (value > 3.0 || value < 0.5) {
//        return 3;
//    }
 
    return 0;

}


- (void)resetRandomMovement{
    progressTimer = 0.0f;
    timer = CCRANDOM_MINUS1_1() * 1.5;
 //   do {
        Xdest = CCRANDOM_MINUS1_1()*10 + self.yawPosition;
 //   } while ([self yawPositionWithinBounds:Xdest]);
 //   do {
        Ydest = -CCRANDOM_MINUS1_1()*10 + self.rollPosition;
 //   } while ([self rollPositionWithinBounds:Ydest]);
    
    switch ([self scaleWithinBounds:Zdest])
    
	{
        case 1:
            Zdest = self.scale - CCRANDOM_MINUS1_1() * 0.5;
            break;
            
        case 2: 
            Zdest = CCRANDOM_MINUS1_1() * 0.5 + self.scale;
            break;
            
//        case 3:
//            Zorg = 1.5;
//            Zdest = 1.5;
//            
//            break;
//            
        default:
            break;
	}
        
    
    // We should double check our Randoms here to make sure that they
    // do not go beyond the maximums and minimums defined in designer values

    // NSLog(@"Xdest: %f, Ydest: %f Zdest: %f  Rdest: %f",Xdest, Ydest, Zdest, circleRadius);
    Xorg = self.yawPosition;
    Yorg = self.rollPosition;
    Zorg = self.scale;    
}


- (void)updatePosition:(ccTime)delta {
    
    progressTimer += delta;
    float ratio = progressTimer / timer;

    if (ratio < 1.0) {
        self.yawPosition = lerpf(Xorg, Xdest, ratio);
        self.rollPosition = lerpf(Yorg, Ydest, ratio);
        self.scale = lerpf(Zorg, Zdest, ratio);
    }
    
    else{
        self.yawPosition = Xdest;
        self.rollPosition = Ydest;
        self.scale = Zdest;
    }

}


- (void) dealloc
{    
    
   // [self removeFromParentAndCleanup:YES];
	[super dealloc];
}


@end
