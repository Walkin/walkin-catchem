//
//  ParticleCatchable.m
//  AR_SpaceShip
//
//  Created by Oliver Ou on 11-10-13.
//  Copyright (c) 2011年 iTeam. All rights reserved.
//



#import "ParticleCatchable.h"
#define kScallSpeed 5


static inline float lerpf(float a, float b, float t)
{
    return a + (b - a) * t;
}


@implementation ParticleCatchable
@synthesize speed;
@synthesize timer;
@synthesize ratio;
@synthesize progressTimer;



- (id)init
{
    self = [super init];
    if (self) {
        MovingRight = YES;
        MovingUp = YES;
        scaleTimer = 0;
        TimeToMove = 0.0;
        self.timer = CCRANDOM_0_1() * 2 + 3;
        self.scale = 0.7;
        self.progressTimer = 0.0;
        Zdest = self.scale;
        Zorg = self.scale;
        self.EnableCatchTimer = 0.0;
        wasTouched = YES;
        
        
        [self scheduleUpdate];
        
        
    }
    
    return self;
}



-(void)update:(ccTime)delta {
    

    
    
    ///////////////When using the accelerometer////////////////////////////////////////
    
    //    NSLog(@"The ratio is %f, progressTimer is %f, timer is %f",self.ratio,self.progressTimer,self.timer);
    
    if(self.EnableCatchTimer > 0.0 ) {
        self.EnableCatch = YES;
        self.EnableCatchTimer -= delta;
        
    }
    
    if (self.EnableCatchTimer <= 0.0) {
        self.EnableCatch = NO;
        
    }
    
    [self updatePosition:delta/2];
    [self checkTime:delta];
    
    //////////////////Control the scale size of catchable instantly///////////////////
    if (Zdest > 3.0 || Zdest < 0.5) {
        
        Zorg = 1.5;
        Zdest = 1.5;
        
    }
    
    if(Ydest > -10.0 || Ydest < -150.0)
    {
        Ydest = -90.0;
        Yorg =  -90.0;
        
    }
    
}

-(void)checkTime:(ccTime)delta
{
    //   NSLog(@"timer: %f, progress: %f",timer, progressTimer);    
    
    if ( self.progressTimer > self.timer) {
        [self resetRandomMovement];
    }
    
}

- (int)yawPositionWithinBounds:(float)value{
    
    if (Xdest > self.initialYaw + MaximumYaw || Xdest < self.initialYaw - MaximumYaw) {
        
        return 2;
        
    }
    
    if ( Xdest < self.initialYaw + MaximumYaw && Xdest > self.initialYaw - MaximumYaw) {
        
        return 1;
    }
    
    return 0;
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
    
    return 0;
    
}


- (void)resetRandomMovement{
    
    self.progressTimer = 0.0f;
    self.timer = CCRANDOM_MINUS1_1() + 1;
    
    //  Xdest = CCRANDOM_MINUS1_1()*10 + self.yawPosition;
    
    Ydest = -CCRANDOM_MINUS1_1()*10 + self.rollPosition;
    
    
    switch ([self scaleWithinBounds:Zdest])
    
	{
        case 1:
            Zdest = self.scale - CCRANDOM_MINUS1_1() * 0.5;
            break;
            
        case 2: 
            Zdest = CCRANDOM_MINUS1_1() * 0.5 + self.scale;
            break;
            
        default:
            break;
	}
    
    
    switch ([self yawPositionWithinBounds:Xdest])
    
	{
            
            //////////////////////When the catchable is in the range, update it's Xdest//////////////////            
        case 1:
            
            Xdest = CCRANDOM_MINUS1_1()*10 + self.yawPosition;
            
            break;
            
            ///////////////////////When the catchable is out of the range, reset its Xdest to the initialYaw//////////
        case 2: 
            
            
            //            Xdest = self.initialYaw;
            //            Xorg = self.initialYaw;
            
            
            if (yaw <= -0.0 && yaw >= -180.0) {
                yaw = yaw +360.0;
            }
            
            Xdest = CCRANDOM_MINUS1_1()* self.MaximumYaw + yaw;
            Xorg = CCRANDOM_MINUS1_1()* self.MaximumYaw + yaw;
            
            break;
            
            
        default:
            break;
	}
    
    // We should double check our Randoms here to make sure that they
    // do not go beyond the maximums and minimums defined in designer values
    
    Xorg = self.yawPosition;
    Yorg = self.rollPosition;
    Zorg = self.scale;    
}


- (void)updatePosition:(ccTime)delta {
    
    self.progressTimer += delta;
    self.ratio = self.progressTimer / self.timer ;
    
    
    if (self.ratio < 1.0) {
        self.yawPosition = lerpf(Xorg, Xdest, self.ratio);
        self.rollPosition = lerpf(Yorg, Ydest, self.ratio);
        self.scale = lerpf(Zorg, Zdest, self.ratio);
    }
    
    else{
        self.yawPosition = Xdest;
        self.rollPosition = Ydest;
        self.scale = Zdest;
    }
    
}



- (void) dealloc
{    
    
	[super dealloc];
}


@end
