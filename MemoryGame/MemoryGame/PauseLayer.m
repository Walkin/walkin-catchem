//
//  PauseLayer.m
//  AR_SpaceShip
//
//  Created by Zelin Ou on 8/10/11.
//  Copyright 2011 iTeam. All rights reserved.
//

#import "PauseLayer.h"
#import "MenuScene.h"
#import "GameScene.h"
#import "AppDelegate.h"


@implementation PauseLayer
@synthesize mnuBackToMenu;

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
                                                               selector:@selector(GoToGameScene:)];
		mnuBackToMenu =[CCMenuItemImage itemFromNormalImage:@"menu_normal.png" 
                                                               selectedImage:@"menu_press.png" 
                                                                      target:self 
                                                                    selector:@selector(GoToMainMenuScene:)];
//		CCMenuItemImage *mnuRestart =[CCMenuItemImage itemFromNormalImage:@"btn_normal.png" 
//                                                            selectedImage:@"btn_press.png" 
//                                                                   target:self 
//                                                                 selector:@selector(RestartGame:)];
        
        
//        label2 = [CCLabelBMFont labelWithString:@"Please hold the device rightly!" fntFile:@"Arial.fnt"];
//        label2.position = ccp(260,270);
//        [self addChild:label2 z:2 tag:kLabel2Tag];
//        [label2 setVisible:NO];


        
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

    }

    return self;
}



-(void) GoToGameScene: (id)sender;
{ 

//
//    self.visible = NO;
//    [self.parent resumeSchedulerAndActions];
//
//    for (Catchable *catchable in [DesignValues sharedDesignValues].catchableSprites ) {
//        [catchable resumeSchedulerAndActions];
//    }
//    
//    
//    [mnuBack setIsEnabled:NO];
//    [mnuBackToMenu setIsEnabled:NO];


}

-(void) GoToMainMenuScene: (id) sender
{
    
	CCScene *sc=[CCScene node];
	[sc addChild:[[MenuLayer alloc]init]];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:sc]];
	
}



- (void) dealloc
{

	[super dealloc];
}


@end
