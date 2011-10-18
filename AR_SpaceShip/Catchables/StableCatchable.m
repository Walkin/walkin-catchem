//
//  StableCatchable.m
//  AR_SpaceShip
//
//  Created by Oliver Ou on 11-9-21.
//  Copyright 2011年 Walkin. All rights reserved.
//


#import "StableCatchable.h"
#define kScallSpeed 5


static inline float lerpf(float a, float b, float t)
{
    return a + (b - a) * t;
}


@implementation StableCatchable
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
        //  self.scale = 1.5;
        self.progressTimer = 0.0;
        Zdest = self.scale;
        Zorg = self.scale;
        self.EnableCatchTimer = 0.0;
        wasTouched = YES;

        [self schedule:@selector(moveCatchableToFront) interval:1.0];
        
        [self pauseCatchablesWithBool:YES];
        
    }
    
    return self;
}


////////////////////////////////Position the Objects to Front and unschedule the update method to pause ////////////////////////

-(void)moveCatchableToFront
{
    [self unschedule:@selector(moveCatchableToFront)]; 
    [self unscheduleUpdate];
    rollPosition = -90.0;

}

-(void)pauseCatchablesWithBool:(BOOL)pause
{
    
    if (pause == YES) {
        
        [self scheduleUpdate];
        [self schedule:@selector(moveCatchableToFront) interval:2.0]; 
        
    }
    
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
