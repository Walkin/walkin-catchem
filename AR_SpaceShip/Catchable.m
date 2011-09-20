//
//  Catchable.m
//  ARSpaceships
//
//  Created by Nick on 6/14/11.
//  Copyright 2011 Nick Waynik Jr. All rights reserved.
//

#import "Catchable.h"
#import "DesignValues.h"

#define PI 3.1415926535897932384626

static inline float lerpf(float a, float b, float t)
{
    return a + (b - a) * t;
}


@implementation Catchable

@synthesize yawPosition;
@synthesize rollPosition;
@synthesize kSpeedLeft;
@synthesize kSpeedUp;
@synthesize TimeToMove;
@synthesize scaleTimer;
@synthesize CombineMoveCount;
@synthesize scaleSpeed;
@synthesize motionManager; 
@synthesize redSpot;
@synthesize wasTouched;
@synthesize MovingRight;
@synthesize MaximumYaw;
@synthesize initialYaw;
@synthesize initialRoll;
@synthesize yaw;
@synthesize randomSpeed;
@synthesize Xdest;
@synthesize Ydest;
@synthesize Zdest;
@synthesize Rdest;
@synthesize Xorg;
@synthesize Yorg;
@synthesize Zorg;
@synthesize Rorg;
@synthesize XInit;
@synthesize EnableCatchTimer;
@synthesize EnableCatch;



-(id)init {
    self = [super init];
    if (self){ 
///////////////////////////////Initial yaw and roll value for catchables///////////////////////////
        yawPosition = 0.0;
        rollPosition = -90.0;
        CombineMoveCount = 1;
        scaleSpeed = 0.0;
        initialYaw = 0.0;
        XInit = 0.0;
        wasTouched = YES;

        
     //   [self scheduleUpdate];

        self.motionManager = [[[CMMotionManager alloc] init] autorelease];
        motionManager.deviceMotionUpdateInterval = 1.0/60.0;
        if (motionManager.isDeviceMotionAvailable) {
            [motionManager startDeviceMotionUpdates];
         }

        
	}
  
     return self;
}


-(void) setInitialPosition:(CGPoint)incPosition{
    self.Xdest = incPosition.x;
    self.Ydest = incPosition.y;
    self.Xorg = incPosition.x;
    self.Yorg = incPosition.y;
}

-(void)addRedSpot
{
    redSpot = [CCSprite spriteWithFile:@"redSpot.png"];
    redSpot.position = ccp(420,300);
}

-(void)moveSelf:(ccTime)delta{}
-(void)checkTime:(ccTime)delta{}

- (CGPoint) RotateAroundPt:(CGPoint) centerPt withAngle:(float) radAngle withRadius:(float) radius {
    CGPoint Spot;
    Spot.x = centerPt.x + cosf(radAngle) * radius;
    Spot.y = centerPt.y + sinf(radAngle) * radius;
    return Spot;
}

-(float)circleRadius{
    float scaleRatio = 3.0 / (self.scale + 3.0);
    float val = lerpf(10.0, 37.0, scaleRatio);
  //  NSLog(@"Scale: %f, Ratio: %f, val : %f, RedPos: x= %f , y = %f",self.scale,scaleRatio,val, redSpot.position.x, redSpot.position.y);
    
    if (val > 37.0) {
        val = 37.0;
    }else if ( val < 10.0)
    {
        val = 0.0;
     }
    return val;
}


- (void)radarSystem
{
 
    CMDeviceMotion *currentDeviceMotion = motionManager.deviceMotion;
    CMAttitude *currentAttitude = currentDeviceMotion.attitude;
    


//////////////////////Using the CMDeviceMotion's yaw///////////////////////
    yaw = (float)(CC_RADIANS_TO_DEGREES(currentAttitude.yaw));

    
    float differentYaw;
    float catchableYaw;
    CGPoint circleCenter = ccp(420, 260);
    CGPoint redSpotPos;
    
    ///////////////////////////Set Catchable's yawPosition back to 0 when it's over 360///////////////////////        
    if (self.yawPosition >360.0) {
        self.yawPosition = 0.0;
    }
    
    ///////////////////////////Add catchableYaw variable to represent catchable's yaw value
    catchableYaw = self.yawPosition;
    
    ///////////////////////////Set device's yaw value vary between 0 and 360/////////////////////////////////
    if (yaw <= -0.0 && yaw >= -180.0) {
        yaw = yaw +360.0;
    }
    
    ///////////////////////////Add differenceYaw to represent the difference between catchableYaw and yaw/////////////
    ///////////////////////////Convert the differenceYaw value back to radian////////////////////////////////////////
    differentYaw = catchableYaw - yaw; 
    differentYaw = (differentYaw * PI /180) + PI/2;
    
    //////////////////////////Update the redSpot's position with the differenceYaw value////////////////////////////
    redSpotPos = [self RotateAroundPt:circleCenter withAngle:differentYaw withRadius:[self circleRadius]];
    redSpot.position = ccp(redSpotPos.x,redSpotPos.y);
    

}

-(void)update:(ccTime)delta {
    [self updatePosition:delta];
    [self updateScale:delta];
    
}

- (void)updatePosition:(ccTime)delta{
    
}

- (void)updateScale:(ccTime)delta{

}

- (void) dealloc
{    
    [motionManager release];
    [redSpot release];

    
	[super dealloc];
}


@end
