//
//  GameWinLayer.m
//  MemoryGame
//
//  Created by Oliver Ou on 11-9-29.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "GameWinLayer.h"
#import "MenuScene.h"
#import "GameScene.h"
#import "AppDelegate.h"


@implementation GameWinLayer
@synthesize mnuBackToMenu;

-(id) init
{
	
	if( (self=[super init] )) {
        
        isTouchEnabled_ = YES;
        
        CCSprite *menubg = [CCSprite spriteWithFile:@"background.png"];
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
        
        
        CCMenu *pausemenu = [CCMenu menuWithItems:mnuBack,mnuBackToMenu,nil];
		[self addChild:pausemenu z:1];
		[pausemenu  setAnchorPoint:CGPointZero];
		[pausemenu  setPosition:CGPointZero];
		[mnuBack setAnchorPoint:CGPointZero];
		[mnuBack setPosition:CGPointMake(200,80)];
		[mnuBackToMenu setAnchorPoint:CGPointZero];
		[mnuBackToMenu setPosition:CGPointMake(200,120)];
        //	[mnuRestart setAnchorPoint:CGPointZero];
        //	[mnuRestart setPosition:CGPointMake(320,190)];
        
        
        CCLabelTTF *question = [CCLabelTTF labelWithString:@"You Win  !!! " fontName:@"Marker Felt" fontSize:30];
        question.position =  ccp(250, 200);
        
        [self addChild:question z:2];
        
        
	    [[CCDirector sharedDirector] setDisplayFPS:NO];
        
    }
    
    return self;
}



-(void) GoToGameScene: (id)sender;
{ 
    
    
	CCScene *sc=[CCScene node];
	[sc addChild:[[GameLayer alloc]init]];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:sc]];
    
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