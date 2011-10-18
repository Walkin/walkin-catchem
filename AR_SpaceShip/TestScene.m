//
//  TestScene.m
//  AR_SpaceShip
//
//  Created by Zelin Ou on 8/11/11.
//  Copyright 2011 Walkin. All rights reserved.
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
#import "Tag.h"
#import "DesignValues.h"


#define kScallSpeed 5


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
@synthesize StableCatchableCount;
@synthesize MaximumYaw;
@synthesize enableTouch; 
@synthesize yaw;
@synthesize roll;
@synthesize playTouchSound;
@synthesize pauseGame;
@synthesize updateYaw;
//@synthesize catchableSprites;


-(id) init
{
	
	if( (self=[super init] )) {
        
        [[CCDirector sharedDirector]setDeviceOrientation:CCDeviceOrientationLandscapeLeft];
        enableTouch = NO;
        playTouchSound = YES;
        yaw = 0.0;
        roll = 0.0;
        
        
        
    }
    return self;
}




-(void)addAudio{
    
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"getCatchable.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"takePicture.mp3"];
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
    
    mnuChange=[CCMenuItemImage itemFromNormalImage:@"change.png" 
                                   selectedImage:@"change.png" 
                                          target:self 
                                        selector:@selector(ChangeCloths:)];
    
    
    mnuScaleBig = [CCMenuItemImage itemFromNormalImage:@"scaleBig.png" 
                                         selectedImage:@"scaleBig.png" 
                                                target:self 
                                              selector:@selector(ScaleBig:)];
    
    mnuScaleSmall = [CCMenuItemImage itemFromNormalImage:@"scaleSmall.png" 
                                         selectedImage:@"scaleSmall.png" 
                                                target:self 
                                              selector:@selector(ScaleSmall:)];
    
    mnuCapture = [CCMenuItemImage itemFromNormalImage:@"camera.png" 
                                           selectedImage:@"camera.png" 
                                                  target:self 
                                                selector:@selector(captureScreen:)];

    
    mnuMatch = [CCMenuItemImage itemFromNormalImage:@"match.png" 
                                        selectedImage:@"match.png" 
                                               target:self 
                                             selector:@selector(MatchCamera:)];
    
    aboutmenu = [CCMenu menuWithItems:mnuBack, mnuChange,mnuScaleBig, mnuScaleSmall, mnuCapture, mnuMatch, nil];
    [self addChild:aboutmenu z:4 tag:2];
    [aboutmenu setAnchorPoint:CGPointZero];
    [aboutmenu setPosition:CGPointZero];
    [mnuBack setAnchorPoint:CGPointZero];
    [mnuBack setPosition:CGPointMake(380,30)];
    
    [mnuChange setAnchorPoint:CGPointZero];
    [mnuChange setPosition:CGPointMake(30,260)];
    
    [mnuScaleBig setAnchorPoint:CGPointZero];
    [mnuScaleBig setPosition:CGPointMake(30,20)];
    
    [mnuScaleSmall setAnchorPoint:CGPointZero];
    [mnuScaleSmall setPosition:CGPointMake(80,20)];
    
    [mnuCapture setAnchorPoint:CGPointZero];
    [mnuCapture setPosition:CGPointMake(230,20)];
    
    [mnuMatch setAnchorPoint:CGPointZero];
    [mnuMatch setPosition:CGPointMake(400,130)];
    
    mnuScaleBig.scale = 0.8;
    mnuScaleSmall.scale = 0.8;
    mnuChange.scale = 0.8;
    mnuMatch.scale = 0.8;
    mnuCapture.scale = 1.2;
    
    [mnuBack setVisible:NO];
    
}

- (BOOL) circle:(CGPoint) circlePoint withRadius:(float) radius collisionWithCircle:(CGPoint) circlePointTwo collisionCircleRadius:(float) radiusTwo {
	float xdif = circlePoint.x - circlePointTwo.x;
	float ydif = circlePoint.y - circlePointTwo.y;
    
	float distance = sqrt(xdif*xdif+ydif*ydif);
	if(distance <= radius+radiusTwo) return YES;
    
	return NO;
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

        
        [catchable radarSystem];
    }
}

-(Catchable *)addStableCatchable:(int)shipTag
{


}

-(Catchable *)addParticleCatchable:(int)shipTag
{


}

-(Catchable *)addCombinedCatchable:(int)shipTag{

}


-(void)addScopeCrosshairs
{
    scope = [CCSprite spriteWithFile:@"scope.png"];
    scope.position = ccp(240, 160);
    [self addChild:scope z:4];
    
    
}

-(void)dataInitialize
{
    
    
    self.motionManager = [[[CMMotionManager alloc] init] autorelease];
    motionManager.deviceMotionUpdateInterval = 1.0/60.0;
    if (motionManager.isDeviceMotionAvailable) {
        [motionManager startDeviceMotionUpdates];
    }
    
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

-(void) ChangeCloths: (id) sender
{

}

-(void) ScaleBig: (id) sender
{

}

-(void) ScaleSmall: (id) sender
{

}

- (void)captureScreen: (id) sender
{

}

-(void)MatchCamera: (id) sender
{


}


-(void)HideItemsBeforeCapture
{

}

-(void)TakePictures
{

}

-(void)ShowItemsAfterCapture
{

}

-(void)TakePicturesWarning
{

}


-(void)checkCatchablePositionX:(Catchable *)catchable withYaw:(float)yawPosition {
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
        if ((catchable.yawPosition < rangeMax || catchable.yawPosition > rangeMin ) || (catchable.yawPosition > rangeMin || catchable.yawPosition < rangeMax)) {
            [self updateCatchablePositionX:positionInX360 withEnemy:catchable];
        }        
    } else {
        if (catchable.yawPosition > rangeMin && catchable.yawPosition < rangeMax) {
            [self updateCatchablePositionX:positionInX360 withEnemy:catchable];
        } 
    }
    
    
}

-(void)checkCatchablePositionY:(Catchable *)Catchable withRoll:(float)rollPosition
{
    float PositionInY360 = rollPosition;
    
/////////////////////// Pause the game when user move the device too high or too slow////////////////////////////////////////
/////////////////////// for example, out of the range between -150 to -10 ///////////////////////////////////////////////////
    
    if (PositionInY360 >= -10 || PositionInY360 <= -150) {
        

        [self schedule:@selector(GoToPauseLayer) interval:2.0];
        
    }else
    {
       // NSLog(@"I am in the gamepaly scene now!");
        [self unschedule:@selector(GoToPauseLayer)];
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

-(void)updateCatchablePositionX:(float)positionInX360 withEnemy:(Catchable *)catchableSprite {
    float difference = 0;
    
    if (positionInX360 < 150) {
        // Run 1
        if (catchableSprite.yawPosition > 210) {
            difference = (360 - catchableSprite.yawPosition) + positionInX360;
            float xPosition = 240 + (difference * kXPositionMultiplier);
            [catchableSprite setPosition:ccp(xPosition, catchableSprite.position.y)];
          //  NSLog(@"Yaw1: %f ", xPosition);
            
        } else {
            // Run Standard Position Check
            [self runStandardPositionXCheck:positionInX360 withDiff:difference withEnemy:catchableSprite];
        }
    } else if(positionInX360 > 210) {
        // Run 2
        if (catchableSprite.yawPosition < 150) {
            difference = catchableSprite.yawPosition + (360 - positionInX360);
            float xPosition = 240 - (difference * kXPositionMultiplier);
            [catchableSprite setPosition:ccp(xPosition, catchableSprite.position.y)];
//            NSLog(@"Yaw2: %f ", xPosition);
            
        } else {
            // Run Standard Position Check
            [self runStandardPositionXCheck:positionInX360 withDiff:difference withEnemy:catchableSprite];
        }
    } else {
        // Run Standard Position Check
        [self runStandardPositionXCheck:positionInX360 withDiff:difference withEnemy:catchableSprite];
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
       //  NSLog(@"xPosition: %f ", xPosition);
        
    }
}

-(void)runStandardPositionYCheck:(float)positionInY360 withDiff:(float)difference withEnemy:(Catchable *)catchable
{
    if (catchable.rollPosition > positionInY360) {
        difference = catchable.rollPosition - positionInY360;
        float yPosition = 160 - (difference * kYPositionMultiplier);
        [catchable setPosition:ccp(catchable.position.x, yPosition)];

        
    } else {
        difference = positionInY360 - catchable.rollPosition;
        float yPosition = 160 + (difference * kYPositionMultiplier);
        [catchable setPosition:ccp(catchable.position.x, yPosition)];

        
    }
    
}


-(void) GoToPauseLayer
{

    
}

- (void) dealloc
{    


    [motionManager release];
    [self removeSprite:scope];
    [self removeSprite:radar];
	[super dealloc];
}

@end
