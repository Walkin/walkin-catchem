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
@synthesize speed;
@synthesize timer;
@synthesize progressTimer;



- (id)init
{
    self = [super init];
    if (self) {
        MovingRight = YES;
        MovingUp = YES;
        scaleTimer = 0;
        TimeToMove = 0.0;
        self.timer = CCRANDOM_0_1() * 2 + 1;
        self.scale = 1.5;
        self.progressTimer = 0.0;
        Zdest = self.scale;
        Zorg = self.scale;
        self.EnableCatchTimer = 0.0;
        wasTouched = YES;

    }
    
    return self;
}

-(void)update:(ccTime)delta {
    
    // NSLog(@"The value of EnableCatchTimer is %f", self.EnableCatchTimer);
    // NSLog(@"The yaw of the device is %f", yaw);
    // NSLog(@"The scale of the catchable is %f", self.scale);
    // NSLog(@"The Zdest is %f and Zorg is %f", Zdest, Zorg);
    // NSLog(@"Xdest: %f, Ydest: %f Zdest: %f  Rdest: %f",Xdest, Ydest, Zdest, circleRadius);
    
///////////////When using the accelerometer////////////////////////////////////////
//    [self updatePosition:delta*0.1];
//    [self checkTime:delta*0.1];
    
    if(self.EnableCatchTimer > 0.0 ) {
       self.EnableCatch = YES;
       self.EnableCatchTimer -= delta;

   }
    
    if (self.EnableCatchTimer <= 0.0) {
        self.EnableCatch = NO;
        
    }
    
    [self updatePosition:delta];
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
    
    if ( progressTimer > self.timer) {
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
    
    progressTimer = 0.0f;
    self.timer = CCRANDOM_MINUS1_1() * 1.5;
    
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
        case 1:
            
            Xdest = CCRANDOM_MINUS1_1()*10 + self.yawPosition;
            
            break;
            
        case 2: 
            
            Xdest = XInit;
            Xorg = XInit;
            
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
    
    progressTimer += delta;
    float ratio = progressTimer / self.timer;

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

	[super dealloc];
}


@end
