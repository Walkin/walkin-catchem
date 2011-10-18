//
//  AboutScene.m
//  FunnyShake
//
//  Created by Oliver on 3/14/11.
//  Copyright 2011 Walkin . All rights reserved.


#import "TestScene3.h"
#import "SimpleAudioEngine.h"
#import "Catchable.h"
#import "CombineMovement.h"
#import "StableCatchable.h"
#import "MainMenuScene.h"
#import "AppDelegate.h"
#import "PauseLayer3.h"
#import "CCSlider.h"
#import "DesignValues.h"
#import "Tag.h"



#define kNoticeZ 3


@implementation TestScene3



-(id) init
{
	self = [super init];
	if (self != nil)
	{
		[self addChild:[TestLayer3 node] z:0 tag:kTestLayer3Tag];
	}
	return self;
	
}


-(void) dealloc
{
	[super dealloc];
}

@end

@interface TestLayer (privateMethods)
-(void)applyJoystick:(SneakyJoystick *)aJoystick toNode:(Catchable *)aNode forTimeDelta:(float)dt;
@end


@implementation TestLayer3



-(id) init
{
	
	if( (self=[super init] )) {
        
     //   self.isAccelerometerEnabled = YES;
        

/////////////////////////////Create the pause layer//////////////////////////////
        p = [[[PauseLayer3 alloc]init]autorelease];
        [self addChild:p z:10];
        p.visible = NO;
        
        [p.mnuBackToMenu setIsEnabled:NO];
        
        MaximumYaw = 45;
        
        [self addMenuItems];
        [self dataInitialize];
		
		[[CCDirector sharedDirector] setDisplayFPS:NO];
        
      //  [self presentWinCondition];
      //   [self presentCoreMotionData];
        
        [self addScopeCrosshairs];
        
        
        // Allow touches with the layer
        [self registerWithTouchDispatcher];

        
        [self addAudio];
        
        [self addRadar];
        
        [self scheduleUpdate];
        
        ///////////////////////////Show Ready,Set,Go before start playing game/////////////////////////
        [self startGame];
        
       // [self addScoreLabel];
        
        [self addJoyStick];

	}
	return self;
}

-(void)startGame
{
    
    [self runAction:[CCCallFuncN actionWithTarget:self selector:@selector(removeSpriteAndAddCatchemSpritesBegin:)]];
    
}



-(void)MatchCamera: (id) sender
{
    
    NSLog(@"My touchLocation is x: %f, y: %f ", yaw, roll);
    
    for (Catchable *catchable in [DesignValues sharedDesignValues].catchableSprites ) {
        
        catchable.yawPosition = yaw;
        catchable.rollPosition = roll;
    }

}


-(void)addJoyStick
{
    leftJoy = [[[SneakyJoystickSkinnedBase alloc] init] autorelease];
    leftJoy.position = ccp(414,64);
    leftJoy.backgroundSprite = [ColoredCircleSprite circleWithColor:ccc4(255, 255, 255, 128) radius:64];
    leftJoy.thumbSprite = [ColoredCircleSprite circleWithColor:ccc4(255, 255, 255, 255) radius:32];
    leftJoy.joystick = [[SneakyJoystick alloc] initWithRect:CGRectMake(0,0,128,128)];
    joystick = [leftJoy.joystick retain];
    
    [self addChild:leftJoy z:6];
    
    [self schedule:@selector(tick:) interval:1.0f/120.0f];
}


-(void)tick:(float)delta {
    
    for (Catchable *catchable in [DesignValues sharedDesignValues].catchableSprites ) {
        
        [self applyJoystick:joystick toNode:catchable forTimeDelta:delta];
    }
}


-(void)update:(ccTime)delta {
    
    
    //NSLog(@"The catchable count is %d", catchableCount);
    
    changePic = (int)(CCRANDOM_0_1()*10);
    
    CMDeviceMotion *currentDeviceMotion = motionManager.deviceMotion;
    CMAttitude *currentAttitude = currentDeviceMotion.attitude;
    
    
    yaw = (float)(CC_RADIANS_TO_DEGREES(currentAttitude.yaw));
    roll = (float)(CC_RADIANS_TO_DEGREES(currentAttitude.roll));
    
    [yawLabel setString:[NSString stringWithFormat:@"Yaw: %.0f", yaw]];
    [rollLabel setString:[NSString stringWithFormat:@"roll: %.0f", roll]];
    
    
    for (Catchable *catchable in [DesignValues sharedDesignValues].catchableSprites ) {
        [self checkCatchablePositionX:catchable withYaw:yaw];
        [self checkCatchablePositionY:catchable withRoll:roll];
        
        
////////////////////////sign the yaw value from CMMotionManager to catchable's yaw///////////////////////        
        catchable.yaw = yaw;
        
        [catchable radarSystem];
    }
}



-(void) ChangeCloths: (id) sender
{
    
    //  NSLog(@"the num of change pic is %d",changePic);
    NSString *spritePic = [NSString stringWithFormat:@"stableCatchable_00%d.png", changePic];
    
    
    for (Catchable *catchable in [DesignValues sharedDesignValues].catchableSprites ) {
        
        
        [catchable setTexture:[[CCTextureCache sharedTextureCache] addImage:spritePic]];
        [catchable cleanup];
        
    }
    
}


- (void)captureScreen: (id) sender
{

        
    [self HideItemsBeforeCapture];
    
    
}

-(void)HideItemsBeforeCapture
{
    
    [aboutmenu setVisible:NO];
    leftJoy.visible = NO;
    radar.visible = NO;
    scope.visible = NO;
    
    for (Catchable *catchable in [DesignValues sharedDesignValues].catchableSprites ) {
        catchable.redSpot.visible = NO;
    }
    
    
    [self schedule:@selector(TakePicturesWarning) interval:0.1];

}

-(void)TakePicturesWarning
{
    [self unschedule:@selector(TakePicturesWarning)];
    
    CGSize size2 = [[CCDirector sharedDirector] winSize];
	CCSprite * ready = [CCSprite spriteWithFile:@"ready.png"];
	[self addChild:ready z:kNoticeZ];
	[ready setPosition:ccp(size2.width / 2, size2.height / 2)];
	[ready setOpacity:0];
	
	CCSprite * set =[CCSprite spriteWithFile:@"set.png"];
	[self addChild:set z:kNoticeZ];
	[set setPosition:ccp(size2.width / 2, size2.height / 2)];
	[set setOpacity:0];
	
	CCSprite * go = [CCSprite spriteWithFile:@"go.png"];
	[self addChild:go z:kNoticeZ];
	[go setPosition:ccp(size2.width / 2, size2.height / 2)];
	[go setOpacity:0];
	
	[ready runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.5],[CCSpawn actions:[CCFadeIn actionWithDuration:0.1],[CCScaleTo actionWithDuration:0.1 scale:1.2],nil] ,[CCDelayTime actionWithDuration:0.1],[CCFadeOut actionWithDuration:0.1],[CCCallFuncN actionWithTarget:self selector:@selector(removeSprite:)],nil]];
	[set runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.0],[CCSpawn actions:[CCFadeIn actionWithDuration:0.1],[CCScaleTo actionWithDuration:0.1 scale:1.2],nil] ,[CCDelayTime actionWithDuration:0.1],[CCFadeOut actionWithDuration:0.1],[CCCallFuncN actionWithTarget:self selector:@selector(removeSprite:)],nil]];
	[go runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.5],[CCSpawn actions:[CCFadeIn actionWithDuration:0.1],[CCScaleTo actionWithDuration:0.1 scale:1.2],nil] ,[CCDelayTime actionWithDuration:0.1],[CCFadeOut actionWithDuration:0.1],[CCCallFuncN actionWithTarget:self selector:@selector(TakePictures)],nil]];

//        [[[CCDirector sharedDirector] openGLView] addSubview:[AppDelegate get].overlay];

        
}


-(void)TakePictures
{
    [self unschedule:@selector(TakePictures)];
    
    
    CGImageRef screen = UIGetScreenImage();
    
    UIImage *sourceImage = [UIImage imageWithCGImage:screen];

//    UIImage *sourceImage = [[CCDirector sharedDirector]screenshotUIImage];

    NSData *data = UIImagePNGRepresentation(sourceImage);
    UIImage *tmp = [UIImage imageWithData:data];
    UIImage *fixed = [UIImage imageWithCGImage:tmp.CGImage
                                         scale:sourceImage.scale
                                   orientation: UIImageOrientationLeft];
    
    UIImageWriteToSavedPhotosAlbum(fixed, self, nil, nil);
    
    CGImageRelease(screen);
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"takePicture.mp3"];

    
    [self schedule:@selector(ShowItemsAfterCapture) ];

}


-(void)ShowItemsAfterCapture
{
    [self unschedule:@selector(ShowItemsAfterCapture)];
    
    [aboutmenu setVisible:YES];
    leftJoy.visible = YES;
    radar.visible = YES;
    scope.visible = YES;
    
    for (Catchable *catchable in [DesignValues sharedDesignValues].catchableSprites ) {
        catchable.redSpot.visible = YES;
    }
}

-(void) ScaleBig: (id) sender
{
    for (Catchable *catchable in [DesignValues sharedDesignValues].catchableSprites ) {
        
        catchable.scale += 0.1;
        
    }
    
}


-(void) ScaleSmall: (id) sender
{
    for (Catchable *catchable in [DesignValues sharedDesignValues].catchableSprites ) {
        
        catchable.scale -= 0.1;
        
    }
    
}



-(void)removeSpriteAndAddCatchemSpritesBegin:(CCNode *)n
{


    
    catchableCount = 0;
    

    
//    for(int i = 0; i < [[DesignValues sharedDesignValues]getFloaterCombined]; i++) {
      for(int i = 0; i < 1; i++) {
        Catchable *catchable = [self addStableCatchable:i];
        [[DesignValues sharedDesignValues].catchableSprites  addObject:catchable];
        catchableCount += 1;
        catchable.MaximumYaw = 45;
        [catchable addRedSpot];
        [self addChild:catchable.redSpot z:4];
        
    }
    
    enableTouch = YES;
    
    
}


-(Catchable *)addStableCatchable:(int)shipTag{
    
    Catchable *catchable;
    
    int picChoose = (int)(CCRANDOM_0_1()*10);
    
    
    float x;
    float y;
    float randomX;
    float randomY;
    x = 0;
    y = 0;
    
    catchable = [StableCatchable spriteWithFile:[NSString stringWithFormat:@"stableCatchable_00%d.png",picChoose]];
    StableCatchableCount += catchable.StableCount;
    
    randomX = CCRANDOM_MINUS1_1()*MaximumYaw;
    randomY = -CCRANDOM_0_1()*100;
    
    if (yaw <= -0.0 && yaw >= -180.0) {
        yaw = yaw +360.0;
    }
    
    
    x = randomX + yaw;
    
    
    while ( randomY > -10 && randomY < -150 ) {
        randomY = -CCRANDOM_0_1()*100;
    }
    
    y = randomY;
    
    
    //    catchable.yawPosition = x;   
    //    catchable.rollPosition = y;
    CGPoint positionPoint = ccp(x, y);
    [catchable setInitialPosition:positionPoint];
    
    // Set the position of the space ship off the screen
    // we will update it in another method
    [catchable setPosition:ccp(5000, 5000)];
    
    catchable.visible = true;
    
    
    [self addChild:catchable z:3 tag:shipTag];
    
    ///////////////////////////Make catchable Wave itself/////////////////////// 
    
 //       id waves = [CCWaves actionWithWaves:5 amplitude:20 horizontal:YES vertical:NO grid:ccg(15,10) duration:5];
 //       [catchable runAction: [CCRepeatForever actionWithAction: waves]];
    
    return catchable;
}



-(void) GoToPauseLayer
{
    [leftJoy.joystick release];
    
    [self unschedule:@selector(GoToPauseLayer)];
    
    p.visible = YES;
    [p.mnuBackToMenu setIsEnabled:YES];
    [self pauseSchedulerAndActions];
    playTouchSound = NO;
    
    for (Catchable *catchable in [DesignValues sharedDesignValues].catchableSprites ) {
        [catchable pauseSchedulerAndActions];
    }
    

}



- (void) dealloc
{

    [joystick release];
    [leftJoy release];
	[super dealloc];
}


///////////////function to apply a velocity to a position with delta/////////////
static CGPoint applyVelocity(CGPoint velocity, Catchable *position, float delta){
	return CGPointMake(position.yawPosition - velocity.x * delta, position.rollPosition - velocity.y * delta);
}

-(void)applyJoystick:(SneakyJoystick *)aJoystick toNode:(Catchable *)aNode forTimeDelta:(float)dt
{
    // you can create a velocity specific to the node if you wanted, just supply a different multiplier
    // which will allow you to do a parallax scrolling of sorts
	CGPoint scaledVelocity = ccpMult(aJoystick.velocity, 20.0f); 
	
    // apply the scaled velocity to the position over delta
	aNode.yawPosition = applyVelocity(scaledVelocity, aNode, dt).x;
    aNode.rollPosition = applyVelocity(scaledVelocity, aNode, dt).y;
    
    ///////////////////////////Set device's yaw value vary between 0 and 360/////////////////////////////////
    if (aNode.yawPosition <= -0.0 && aNode.yawPosition >= -180.0) {
        aNode.yawPosition = aNode.yawPosition +360.0;
    }
    
    
}


@end

