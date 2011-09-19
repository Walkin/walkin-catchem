//
//  PauseLayer.m
//  AR_SpaceShip
//
//  Created by Zelin Ou on 8/10/11.
//  Copyright 2011 iTeam. All rights reserved.
//

#import "PauseLayer.h"
#import "MainMenuScene.h"
#import "TestScene1.h"
#import "AppDelegate.h"
#import "Tag.h"
#import "DesignValues.h"
#import "Catchable.h"

@implementation PauseLayer
@synthesize motionManager,mnuBackToMenu;

-(id) init
{
	
	if( (self=[super init] )) {
        
        isTouchEnabled_ = YES;
        
        CCSprite *menubg = [CCSprite spriteWithFile:@"texturedWhiteBG.png"];
        menubg.anchorPoint = CGPointZero;
        menubg.position = CGPointZero;
        [self addChild:menubg z:0];
        
        mnuBack =[CCMenuItemImage itemFromNormalImage:@"back_normal.png" 
                                                         selectedImage:@"back_press.png" 
                                                                target:self 
                                                              selector:@selector(GoToTestScene1:)];
		mnuBackToMenu =[CCMenuItemImage itemFromNormalImage:@"menu_normal.png" 
                                                               selectedImage:@"menu_press.png" 
                                                                      target:self 
                                                                    selector:@selector(GoToMainMenuScene:)];
//		CCMenuItemImage *mnuRestart =[CCMenuItemImage itemFromNormalImage:@"btn_normal.png" 
//                                                            selectedImage:@"btn_press.png" 
//                                                                   target:self 
//                                                                 selector:@selector(RestartGame:)];
        
        
        label2 = [CCLabelBMFont labelWithString:@"Please hold the device rightly!" fntFile:@"Arial.fnt"];
        label2.position = ccp(260,270);
        [self addChild:label2 z:2 tag:kLabel2Tag];
        [label2 setVisible:NO];
        
        label3 = [CCLabelBMFont labelWithString:@"You can go back to play now!" fntFile:@"Arial.fnt"];
        label3.position = ccp(260,270);
        [self addChild:label3 z:3 tag:kLabel3Tag];
        [label3 setVisible:NO];

        
        CCMenu *pausemenu = [CCMenu menuWithItems:mnuBack,mnuBackToMenu,nil];
		[self addChild:pausemenu z:1];
		[pausemenu  setAnchorPoint:CGPointZero];
		[pausemenu  setPosition:CGPointZero];
		[mnuBack setAnchorPoint:CGPointZero];
		[mnuBack setPosition:CGPointMake(200,80)];
		[mnuBackToMenu setAnchorPoint:CGPointZero];
		[mnuBackToMenu setPosition:CGPointMake(200,150)];
//		[mnuRestart setAnchorPoint:CGPointZero];
//		[mnuRestart setPosition:CGPointMake(320,190)];


	    [[CCDirector sharedDirector] setDisplayFPS:NO];
        
        self.motionManager = [[CMMotionManager alloc] init] ;
        motionManager.deviceMotionUpdateInterval = 1.0/60.0;
        if (motionManager.isDeviceMotionAvailable) {
            [motionManager startDeviceMotionUpdates];
        }
        
        [self scheduleUpdate];
        
    }

    return self;
}



-(void)update:(ccTime)delta {
    CMDeviceMotion *currentDeviceMotion = motionManager.deviceMotion;
    CMAttitude *currentAttitude = currentDeviceMotion.attitude;
    
    float roll = (float)(CC_RADIANS_TO_DEGREES(currentAttitude.roll));
    
    [self checkCatchablePositionYWithRoll:roll];
    
    
    
}

-(void)checkCatchablePositionYWithRoll:(float)rollPosition{
    
    float positionInY360 = rollPosition;
    
    if (positionInY360 < -40 && positionInY360 > -130) {
        
        [mnuBack setIsEnabled:YES];
        
        [label2 setVisible:NO];
        
        [label3 setVisible:YES];
        
        
    }
    
    if (positionInY360 > -40 || positionInY360 < -130) {
        
        [mnuBack setIsEnabled:NO];
        
        [label2 setVisible:YES];
        
        [label3 setVisible:NO];
        
        
    }
    
}


-(void) GoToTestScene1: (id) sender
{ 
    
//	CCScene *sc=[CCScene node];
//	[sc addChild:[[TestLayer1 alloc]init]];
////    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:sc]];
//    [[CCDirector sharedDirector] replaceScene:sc];

    self.visible = NO;
    [self.parent resumeSchedulerAndActions];

    for (Catchable *catchable in [DesignValues sharedDesignValues].catchableSprites ) {
        [catchable resumeSchedulerAndActions];
    }
    
    
    [mnuBack setIsEnabled:NO];
    [mnuBackToMenu setIsEnabled:NO];


	
}

-(void) GoToMainMenuScene: (id) sender
{
    
	CCScene *sc=[CCScene node];
	[sc addChild:[[MainMenuLayer alloc]init]];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:sc]];
	
}


//-(void) RestartGame: (id) sender
//{
//	
//	
//
//	[self.parent removeChild:self cleanup:YES];
//	[[CCDirector sharedDirector] resume];
//	
//    [[CCTouchDispatcher sharedDispatcher] setDispatchEvents:YES];
//	
//}


- (void) dealloc
{
    [motionManager release];
	[super dealloc];
}


@end
