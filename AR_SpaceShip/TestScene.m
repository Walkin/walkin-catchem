//
//  TestScene.m
//  AR_SpaceShip
//
//  Created by Zelin Ou on 8/11/11.
//  Copyright 2011 iTeam. All rights reserved.
//

#import "TestScene.h"
#include <stdlib.h>
#import "SimpleAudioEngine.h"
#import "Catchable.h"
#import "CombineMovement.h"
#import "MainMenuScene.h"
#import "AppDelegate.h"
#import "PauseLayer.h"
#import "CCSlider.h"
#import "CCUIViewWrapper.h"
#import "Tag.h"
#import "DesignValues.h"
#import "AccelerometerFilter.h"
#define kScallSpeed 5
#define kUpdateFrequency	20.0

@implementation TestScene


-(id) init
{
	self = [super init];
	if (self != nil)
	{
		
	}
	return self;
	
}

-(void) dealloc
{
	[super dealloc];
}

@end

@implementation TestLayer

#define kNoticeZ 3

@synthesize motionManager;
@synthesize catchableCount;
@synthesize score;
@synthesize count;
@synthesize CombinedCatchemCount;
@synthesize MaximumYaw;
@synthesize enableTouch; 
@synthesize yaw;
@synthesize roll;
@synthesize playTouchSound;
@synthesize pauseGame;
@synthesize locManager;
@synthesize useAdaptive;


-(id) init
{
	
	if( (self=[super init] )) {
        
        [[CCDirector sharedDirector]setDeviceOrientation:CCDeviceOrientationLandscapeLeft];
        enableTouch = NO;
        playTouchSound = YES;
        yaw = 0.0;
        
        
        

    }
    return self;
}



-(void)addAudio{
    
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"getCatchable.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"catch.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"win.wav"];
    
    
}

-(void)addRadar
{
    radar = [CCSprite spriteWithFile:@"radarCircle.png"];
    radar.position = ccp(420, 260);
    [self addChild:radar z:4];
    
    
}

-(void)addScoreLabel
{
    scoreLabel = [CCLabelTTF labelWithString:@"You have catched: " fontName:@"Marker Felt" fontSize:20];
    scoreLabel.position =  ccp(100, 260);
    
    score = 0;
    count = 0;
    [scoreLabel setString:[NSString stringWithFormat:@"You have catched: %d", score]];
    
    [self addChild:scoreLabel z:4];
    
    [self schedule:@selector(ScoreUpdate) interval:0.1];
    
    
}

-(void)ScoreUpdate
{
    [scoreLabel setString:[NSString stringWithFormat:@"You have catched: %d", score]];
    
}


-(void)startGame
{
    
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
	[go runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.5],[CCSpawn actions:[CCFadeIn actionWithDuration:0.1],[CCScaleTo actionWithDuration:0.1 scale:1.2],nil] ,[CCDelayTime actionWithDuration:0.1],[CCFadeOut actionWithDuration:0.1],[CCCallFuncN actionWithTarget:self selector:@selector(removeSpriteAndAddCatchemSpritesBegin:)],nil]];
    
	
	
}


-(void)removeSprite:(CCNode *)n
{
	[self removeChild:n cleanup:YES];
}


-(void)removeSpriteAndAddCatchemSpritesBegin:(CCNode *)n
{

    
    catchableCount = 0;
    
    
    
    for(int i = 0; i < [[DesignValues sharedDesignValues] getFloaterCombined]; i++) {
        Catchable *catchable = [self addCombinedCatchable:i];
        [[DesignValues sharedDesignValues].catchableSprites  addObject:catchable];
        catchableCount += 1;
        
        [catchable addRedSpot];
        [self addChild:catchable.redSpot z:4];
        
    }
    
    
    enableTouch = YES;

    
}

-(void)addMenuItems
{
    mnuBack=[CCMenuItemImage itemFromNormalImage:@"back_normal.png" 
                                   selectedImage:@"back_press.png" 
                                          target:self 
                                        selector:@selector(GoToMainMenuScene:)];
    
    
    CCMenuItemFont *lowPass = [CCMenuItemFont itemFromString:@"LowPassFilter" target:self selector:@selector(lowPassPressed:)];
    CCMenuItemFont *HighPass = [CCMenuItemFont itemFromString:@"HighPassFilter" target:self selector:@selector(HighPassPressed:)];
    CCMenuItemFont *Standard = [CCMenuItemFont itemFromString:@"Standard" target:self selector:@selector(StandardPressed:)];
    CCMenuItemFont *Adaptive = [CCMenuItemFont itemFromString:@"Adaptive" target:self selector:@selector(AdaptivePressed:)];
    CCMenuItemFont *PauseCatchable = [CCMenuItemFont itemFromString:@"Pause" target:self selector:@selector(PausePressed:)];
    CCMenuItemFont *ResumeCatchable = [CCMenuItemFont itemFromString:@"Resume" target:self selector:@selector(ResumePressed:)];
    
    CCMenu *aboutmenu = [CCMenu menuWithItems:mnuBack,lowPass,HighPass,Standard, Adaptive,PauseCatchable,ResumeCatchable, nil];
    [self addChild:aboutmenu z:4 tag:2];
    [aboutmenu setAnchorPoint:CGPointZero];
    [aboutmenu setPosition:CGPointZero];
    [mnuBack setAnchorPoint:CGPointZero];
    [mnuBack setPosition:CGPointMake(380,30)];
    [mnuBack setVisible:NO];
    [lowPass setPosition:CGPointMake(380, 50)];
    [HighPass setPosition:CGPointMake(380, 90)];
    [Standard setPosition:CGPointMake(380, 130)];
    [Adaptive setPosition:CGPointMake(380, 170)];
    [PauseCatchable setPosition:CGPointMake(50, 50)];
    [ResumeCatchable setPosition:CGPointMake(160, 50)];
}

-(void)lowPassPressed:(id)sender
{
   [self changeFilter:[LowpassFilter class]];
}

-(void)HighPassPressed:(id)sender
{
   [self changeFilter:[HighpassFilter class]];
}

-(void)StandardPressed:(id)sender
{
    useAdaptive = NO;

}

-(void)AdaptivePressed:(id)sender
{
    useAdaptive = YES;

}

-(void)PausePressed:(id)sender
{
    for (Catchable *catchable in [DesignValues sharedDesignValues].catchableSprites ) {
        [catchable unscheduleUpdate];
    }

}

-(void)ResumePressed:(id)sender
{
    for (Catchable *catchable in [DesignValues sharedDesignValues].catchableSprites ) {
        [catchable scheduleUpdate];
    }

}

- (BOOL) circle:(CGPoint) circlePoint withRadius:(float) radius collisionWithCircle:(CGPoint) circlePointTwo collisionCircleRadius:(float) radiusTwo {
	float xdif = circlePoint.x - circlePointTwo.x;
	float ydif = circlePoint.y - circlePointTwo.y;
    
	float distance = sqrt(xdif*xdif+ydif*ydif);
	if(distance <= radius+radiusTwo) return YES;
    
	return NO;
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSLog(@"Location manager error: %@", [error description]);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    
	CGFloat heading = -1.0f * M_PI * newHeading.magneticHeading / 180.0f;
    yaw = (float)(CC_RADIANS_TO_DEGREES(heading));
    yaw = yaw + 180.0;
    
    
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
{
	return YES;
}

#pragma mark UIAccelerometerDelegate Methods

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    
//	roll = acceleration.z * (-90.0) - 90.0;
    
    [filter addAcceleration:acceleration];

    roll = filter.z * (-90.0) - 90.0;
	
}



-(void)update:(ccTime)delta {
    
    //NSLog(@"The catchable count is %d", catchableCount);
    
    CMDeviceMotion *currentDeviceMotion = motionManager.deviceMotion;
    CMAttitude *currentAttitude = currentDeviceMotion.attitude;
 
    
  //  yaw = (float)(CC_RADIANS_TO_DEGREES(currentAttitude.yaw));
  // roll = (float)(CC_RADIANS_TO_DEGREES(currentAttitude.roll));
    
    [yawLabel setString:[NSString stringWithFormat:@"Yaw: %.0f", yaw]];
    [rollLabel setString:[NSString stringWithFormat:@"roll: %f", roll]];
    

    for (Catchable *catchable in [DesignValues sharedDesignValues].catchableSprites ) {
        [self checkCatchablePositionX:catchable withYaw:yaw];
        [self checkCatchablePositionY:catchable withRoll:roll];
        
        [catchable radarSystem];
    }
}


-(Catchable *)addCombinedCatchable:(int)shipTag{
    
    Catchable *catchable;
    
    int picChoose = (int)(CCRANDOM_0_1()*10);
    
    
    float x;
    float y;
    float randomX;
    float randomY;
    x = 0;
    y = 0;
    
    catchable = [CombineMovement spriteWithFile:[NSString stringWithFormat:@"catchable_00%d.png",picChoose]];
    CombinedCatchemCount += catchable.CombineMoveCount;
    
    randomX = CCRANDOM_MINUS1_1()*MaximumYaw;
    randomY = -CCRANDOM_0_1()*100;
    
    if (yaw <= -0.0 && yaw >= -180.0) {
        yaw = yaw +360.0;
    }

    
    x = randomX + yaw;
    
    catchable.initialYaw = yaw;
    catchable.XInit = x;

    
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
    
    return catchable;
}


-(void)addScopeCrosshairs
{
    scope = [CCSprite spriteWithFile:@"scope.png"];
    scope.position = ccp(240, 160);
    [self addChild:scope z:4];
    
    
}

-(void)changeFilter:(Class)filterClass
{
	// Ensure that the new filter class is different from the current one...
	if(filterClass != [filter class])
	{
		// And if it is, release the old one and create a new one.
		[filter release];
		filter = [[filterClass alloc] initWithSampleRate:[[DesignValues sharedDesignValues] getUpdateFrequency] cutoffFrequency:5.0];
		// Set the adaptive flag
		filter.adaptive = useAdaptive;

	}
}

-(void)dataInitialize
{
    
    
    self.motionManager = [[[CMMotionManager alloc] init] autorelease];
    motionManager.deviceMotionUpdateInterval = 1.0/60.0;
    if (motionManager.isDeviceMotionAvailable) {
        [motionManager startDeviceMotionUpdates];
    }
    
    self.locManager = [[[CLLocationManager alloc] init] autorelease];
    self.locManager.delegate = self;
    //        if (self.locManager.headingAvailable) 
    [self.locManager startUpdatingHeading];
    
//    accelerometer = [UIAccelerometer sharedAccelerometer];
//	accelerometer.updateInterval = 0.1;
//	accelerometer.delegate = self;
    
    [self changeFilter:[LowpassFilter class]];
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:1.0 / [[DesignValues sharedDesignValues] getUpdateFrequency]];
	[[UIAccelerometer sharedAccelerometer] setDelegate:self];

    useAdaptive = YES;
    
    pauseGame = YES;
    
}


-(void)presentWinCondition
{
    winCondition = [CCLabelTTF labelWithString:@"Please catch 20 things until you win !" fontName:@"Marker Felt" fontSize:18];
    winCondition.position = ccp(150,300);
    [self addChild:winCondition z:4];

}


-(void)presentCoreMotionData
{
    
    yawLabel = [CCLabelTTF labelWithString:@"Yaw: " fontName:@"Marker Felt" fontSize:12];
    rollLabel = [CCLabelTTF labelWithString:@"roll: " fontName:@"Marker Felt" fontSize:12];
    yawLabel.position =  ccp(50, 100);
    rollLabel.position = ccp(200,100);
    
    [self addChild: yawLabel z:4];
    [self addChild: rollLabel z:4];
    
}

-(void) GoToMainMenuScene: (id) sender
{
    
	CCScene *sc=[CCScene node];
	[sc addChild:[[[MainMenuLayer alloc]init]autorelease]];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:sc]];
	
}



-(void)checkCatchablePositionX:(Catchable *)Catchable withYaw:(float)yawPosition {
    // Convert the yaw value to a value in the range of 0 to 360
    float positionInX360 = yawPosition;
    if (positionInX360 < 0) {
        positionInX360 = 360 + positionInX360;
    }
    
    BOOL checkAlternateRange = false;
    
    // Determine the minimum position for enemy ship
    float rangeMin = positionInX360 - 150;
    if (rangeMin < 0) {
        rangeMin = 360 + rangeMin;
        checkAlternateRange = true;
    }
    
    // Determine the maximum position for the enemy ship
    float rangeMax = positionInX360 + 150;
    if (rangeMax > 360) {
        rangeMax = rangeMax - 360;
        checkAlternateRange = true;
    }    
    
    if (checkAlternateRange) {
        if ((Catchable.yawPosition < rangeMax || Catchable.yawPosition > rangeMin ) || (Catchable.yawPosition > rangeMin || Catchable.yawPosition < rangeMax)) {
            [self updateCatchablePositionX:positionInX360 withEnemy:Catchable];
        }        
    } else {
        if (Catchable.yawPosition > rangeMin && Catchable.yawPosition < rangeMax) {
            [self updateCatchablePositionX:positionInX360 withEnemy:Catchable];
        } 
    }
    
    
}

-(void)checkCatchablePositionY:(Catchable *)Catchable withRoll:(float)rollPosition
{
    float PositionInY360 = rollPosition;
    
    ///////////////////////////Pause the game when user move the device too high or too slow///////////////////    
    if (PositionInY360 > -10 || PositionInY360 < -150) {
        
        [self GoToPauseLayer];

    //    NSLog(@"I am out of the scene!");
        
    }
    
    ////////// Convert the yaw value to a value in the range of 0 to 360/////////////////////////
    
    if (PositionInY360 < 0) {
        PositionInY360 = 360 + PositionInY360;
    }
    
    BOOL checkAlternateRange = false;
    
    // Determine the minimum position for enemy ship
    float rangeMin = PositionInY360 - 150;
    if (rangeMin < 0) {
        rangeMin = 360 + rangeMin;
        checkAlternateRange = true;
    }
    
    // Determine the maximum position for the enemy ship
    float rangeMax = PositionInY360 + 150;
    if (rangeMax > 360) {
        rangeMax = rangeMax - 360;
        checkAlternateRange = true;
    }    
    
    if (checkAlternateRange) {
        if ((Catchable.rollPosition < rangeMax || Catchable.rollPosition > rangeMin ) || (Catchable.rollPosition > rangeMin || Catchable.rollPosition < rangeMax)) {
            [self updateCatchablePositionY:PositionInY360 withEnemy:Catchable];
        }        
    } else {
        if (Catchable.rollPosition > rangeMin && Catchable.rollPosition < rangeMax) {
            [self updateCatchablePositionY:PositionInY360 withEnemy:Catchable];
        } 
    }
    
    
}

-(void)updateCatchablePositionX:(float)positionInX360 withEnemy:(Catchable *)Catchable {
    float difference = 0;
    if (positionInX360 < 150) {
        // Run 1
        if (Catchable.yawPosition > 210) {
            difference = (360 - Catchable.yawPosition) + positionInX360;
            float xPosition = 240 + (difference * kXPositionMultiplier);
            [Catchable setPosition:ccp(xPosition, Catchable.position.y)];
            
            
        } else {
            // Run Standard Position Check
            [self runStandardPositionXCheck:positionInX360 withDiff:difference withEnemy:Catchable];
        }
    } else if(positionInX360 > 210) {
        // Run 2
        if (Catchable.yawPosition < 150) {
            difference = Catchable.yawPosition + (360 - positionInX360);
            float xPosition = 240 - (difference * kXPositionMultiplier);
            [Catchable setPosition:ccp(xPosition, Catchable.position.y)];
            
            
        } else {
            // Run Standard Position Check
            [self runStandardPositionXCheck:positionInX360 withDiff:difference withEnemy:Catchable];
        }
    } else {
        // Run Standard Position Check
        [self runStandardPositionXCheck:positionInX360 withDiff:difference withEnemy:Catchable];
    }
}

-(void)updateCatchablePositionY:(float)positionInY360 withEnemy:(Catchable *)catchable;
{
    float difference = 0;
    
    if (positionInY360 < 150) {
        // Run 1
        if (catchable.rollPosition > 210) {
            difference = (360 - catchable.rollPosition) + positionInY360;
            float yPosition = 160 + (difference * kYPositionMultiplier);
            [catchable setPosition:ccp(catchable.position.x, yPosition)];
            
            
        } else {
            // Run Standard Position Check
            [self runStandardPositionYCheck:positionInY360 withDiff:difference withEnemy:catchable];
        }
    } else if(positionInY360 > 210) {
        // Run 2
        if (catchable.rollPosition < 150) {
            difference = catchable.rollPosition + (360 - positionInY360);
            float yPosition = 160 - (difference * kYPositionMultiplier);
            [catchable setPosition:ccp(catchable.position.x, yPosition)];
            
        } else {
            // Run Standard Position Check
            [self runStandardPositionYCheck:positionInY360 withDiff:difference withEnemy:catchable];
        }
    } else {
        // Run Standard Position Check
        [self runStandardPositionYCheck:positionInY360 withDiff:difference withEnemy:catchable];
    }
    
}


-(void)runStandardPositionXCheck:(float)positionInX360 withDiff:(float)difference withEnemy:(Catchable *)catchable {
    if (catchable.yawPosition > positionInX360) {
        difference = catchable.yawPosition - positionInX360;
        float xPosition = 240 - (difference * kXPositionMultiplier);
        [catchable setPosition:ccp(xPosition, catchable.position.y)];
        
        
    } else {
        difference = positionInX360 - catchable.yawPosition;
        float xPosition = 240 + (difference * kXPositionMultiplier);
        [catchable setPosition:ccp(xPosition, catchable.position.y)];
        
    }
}

-(void)runStandardPositionYCheck:(float)positionInY360 withDiff:(float)difference withEnemy:(Catchable *)Catchable
{
    if (Catchable.rollPosition > positionInY360) {
        difference = Catchable.rollPosition - positionInY360;
        float yPosition = 160 - (difference * kYPositionMultiplier);
        [Catchable setPosition:ccp(Catchable.position.x, yPosition)];
        
        
    } else {
        difference = positionInY360 - Catchable.rollPosition;
        float yPosition = 160 + (difference * kYPositionMultiplier);
        [Catchable setPosition:ccp(Catchable.position.x, yPosition)];
        
        
    }
    
}




-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint location = CGPointMake(240,160);
    
    if (catchableCount != 0) {
        if (playTouchSound && pauseGame) {
            
            [[SimpleAudioEngine sharedEngine] playEffect:@"catch.wav"];
        }
    }
    

    
    for (Catchable *catchable in [DesignValues sharedDesignValues].catchableSprites ) {
        
        // Check to see if yaw position is in range
        BOOL wasTouched = [self circle:location withRadius:50 collisionWithCircle:catchable.position collisionCircleRadius:50];
        
        if (catchable.wasTouched && wasTouched) {
            
            CCParticleSystemQuad *particle = [CCParticleSystemQuad particleWithFile:@"Explosion.plist"];
            particle.position = ccp(240,160);
            [self addChild:particle z:20];
            particle.autoRemoveOnFinish = YES;
            
            //            catchable.wasTouched = NO;
            //            catchable.visible = false;
            //            catchable.redSpot.visible = false;
            //            catchableCount -= 1;
            
//////////////////////////Set the catchable randomly to another position of the range///////////////////////
            

            float randomY = -CCRANDOM_0_1()*100;
            
            
            while ( randomY > -10 && randomY < -150 ) {
                randomY = -CCRANDOM_0_1()*100;
            }
            
            if (yaw >= catchable.Xorg) {
              catchable.Xdest = catchable.Xorg - catchable.MaximumYaw;
                catchable.Ydest = randomY;

            }
            
            if (yaw < catchable.Xorg) {
                
                catchable.Xdest = catchable.Xorg + catchable.MaximumYaw;
                catchable.Ydest = randomY;

            }
            

            
///////////////////////////////////////////////////////////////////////////////////////////////////////////
            playTouchSound = YES;
            score++;
            
            [[SimpleAudioEngine sharedEngine] playEffect:@"getCatchable.wav"];
        }
        
    }
    
       
    //////////////////////////////////////////When you clean up the Catchable,You Win!/////////////////////////////////
    if (score >= 20 && pauseGame == YES) {
        if(enableTouch)
        {
            // Show end game
            CGSize winSize = [CCDirector sharedDirector].winSize;
            CCLabelBMFont *winLabel = [CCLabelBMFont labelWithString:@"You win!" fntFile:@"Arial.fnt"];
            winLabel.scale = 2.0;
            winLabel.position = ccp(winSize.width/2, winSize.height/2);
            [self addChild:winLabel z:4];
            [mnuBack setVisible:YES];
            pauseGame = NO;
            

            
            for (Catchable *catchable in [DesignValues sharedDesignValues].catchableSprites ) {
                catchable.wasTouched = NO;
            }
            

            
            
        }   
        
    }
}

-(void) GoToPauseLayer
{
//    playTouchSound = NO;
//    CCScene *sc=[CCScene node];
//	[sc addChild:[[[PauseLayer alloc]init]autorelease]];
//	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:sc]];
//   // [[CCDirector sharedDirector] pause];
    
}


- (void) dealloc
{    
    [motionManager release];
    [self removeSprite:scope];
    [self removeSprite:radar];

    
	[super dealloc];
}




@end
