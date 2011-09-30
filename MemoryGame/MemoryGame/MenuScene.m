//
//  MenuScene.m
//  MemoryGame
//
//  Created by Oliver Ou on 11-9-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MenuScene.h"
#import "GameScene.h"

#define kMenuBackgroundZ -1
#define kMenuItemsZ 1

@implementation MenuScene

-(id) init
{
	self = [super init];
	if (self != nil)
	{
		[self addChild:[MenuLayer node] z:kMenuBackgroundZ];
	}
	return self;
	
}

-(void) dealloc
{
	[super dealloc];
}

@end


@implementation MenuLayer

-(id) init
{
	
	if( (self=[super init] )) {
        
        
        isTouchEnabled_ = YES;
		
        [[CCDirector sharedDirector]setDeviceOrientation:CCDeviceOrientationLandscapeRight];
        
        
        ////////////////////////////////Menu Background////////////////////////////////////
        
		CCSprite *menubg = [CCSprite spriteWithFile:@"TieGuyBackground.png"];
		menubg.anchorPoint = CGPointZero;
		menubg.position = CGPointZero;
		[self addChild:menubg z:kMenuBackgroundZ];
        
		
        ////////////////////////////////Menu items///////////////////////////////////////////
        
		CCMenuItemImage *mnuBTN1 = [CCMenuItemImage itemFromNormalImage:@"CatchemGame.png" 
                                                           selectedImage:@"CatchemGameSelected.png" 
                                                                  target:self 
                                                                selector:@selector(GamePlay:)];
		
		CCMenuItemImage *mnuBTN2 = [CCMenuItemImage itemFromNormalImage:@"InNotIn.png" 
                                                           selectedImage:@"InNotInSelected.png" 
                                                                  target:self 
                                                                selector:nil];
		
		CCMenuItemImage *mnuBTN3 = [CCMenuItemImage itemFromNormalImage:@"Quiz.png" 
                                                           selectedImage:@"QuizSelected.png" 
                                                                  target:self 
                                                                selector:nil];
		
        CCMenuItemImage *tableViewButton = [CCMenuItemImage itemFromNormalImage:@"TreasureHunt.png" 
                                                                  selectedImage:@"TreasureHuntSelected.png"
                                                                         target:self selector:nil];
		
		CCMenu *mainMenu = [CCMenu menuWithItems:mnuBTN1,mnuBTN2,mnuBTN3,tableViewButton,nil];
		[self addChild:mainMenu z:kMenuItemsZ];
		[mainMenu setAnchorPoint:CGPointZero];
		[mainMenu setPosition:CGPointZero];
		[mnuBTN1 setAnchorPoint:CGPointZero];
		[mnuBTN1 setPosition:CGPointMake(40,380)];
		[mnuBTN2 setAnchorPoint:CGPointZero];
		[mnuBTN2 setPosition:CGPointMake(40,260)];
		[mnuBTN3 setAnchorPoint:CGPointZero];
		[mnuBTN3 setPosition:CGPointMake (40,140)];
        [tableViewButton setAnchorPoint:CGPointZero];
        [tableViewButton setPosition:CGPointMake(40,20)];
		
        ////////////////////////////////DisplayFPS////////////////////////////////////		
		[[CCDirector sharedDirector] setDisplayFPS:NO];
        
        
        
	}
	return self;
}


-(void) GamePlay:(id)sender
{
	
	CCScene *sc=[CCScene node];
	[sc addChild:[[[GameLayer alloc]init]autorelease]];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:sc]];
    
	
}


- (void) dealloc
{
    
	[super dealloc];
}


@end
