//  Created by Oliver on 3/14/11.
//  Copyright 2011 Walkin . All rights reserved.
//
#import "MainMenuScene.h"
#import "TestScene.h"
#import "TestScene1.h"
#import "TestScene2.h"
#import "TestScene3.h"
#import "DesignerValuesTableView.h"
#import "SimpleAudioEngine.h"

#define kMenuBackgroundZ -1
#define kMenuItemsZ 1
#define KMenuItemsTextZ 2


@implementation MainMenuScene

-(id) init
{
	self = [super init];
	if (self != nil)
	{
		[self addChild:[MainMenuLayer node] z:kMenuBackgroundZ];
	}
	return self;
	
}


-(void) dealloc
{
	[super dealloc];
}

@end

@implementation MainMenuLayer


-(id) init
{
	
	if( (self=[super init] )) {
		
		isTouchEnabled_ = YES;
		
        [[CCDirector sharedDirector]setDeviceOrientation:CCDeviceOrientationPortrait];
        

		
////////////////////////////////Menu Background////////////////////////////////////

		CCSprite *menubg = [CCSprite spriteWithFile:@"TieGuyBackground.png"];
		menubg.anchorPoint = CGPointZero;
		menubg.position = CGPointZero;
		[self addChild:menubg z:kMenuBackgroundZ];

		
////////////////////////////////Menu items///////////////////////////////////////////
	
		CCMenuItemImage *mnuTest1 = [CCMenuItemImage itemFromNormalImage:@"CatchemGame.png" 
															selectedImage:@"CatchemGameSelected.png" 
																   target:self 
																 selector:@selector(TestClick1:)];
		
		CCMenuItemImage *mnuTest2 = [CCMenuItemImage itemFromNormalImage:@"InNotIn.png" 
															 selectedImage:@"InNotInSelected.png" 
																	target:self 
																  selector:@selector(TestClick2:)];
		
		CCMenuItemImage *mnuTest3 = [CCMenuItemImage itemFromNormalImage:@"Quiz.png" 
															 selectedImage:@"QuizSelected.png" 
																	target:self 
                                                                selector:@selector(TestClick3:)];
		
        CCMenuItemImage *tableViewButton = [CCMenuItemImage itemFromNormalImage:@"TreasureHunt.png" 
                                                                  selectedImage:@"TreasureHuntSelected.png"
                                                                         target:self selector:@selector(popPressed:)];
		
		CCMenu *mainMenu = [CCMenu menuWithItems:mnuTest1,mnuTest2,mnuTest3,tableViewButton,nil];
		[self addChild:mainMenu z:kMenuItemsZ];
		[mainMenu setAnchorPoint:CGPointZero];
		[mainMenu setPosition:CGPointZero];
		[mnuTest1 setAnchorPoint:CGPointZero];
		[mnuTest1 setPosition:CGPointMake(40,380)];
		[mnuTest2 setAnchorPoint:CGPointZero];
		[mnuTest2 setPosition:CGPointMake(40,260)];
		[mnuTest3 setAnchorPoint:CGPointZero];
		[mnuTest3 setPosition:CGPointMake (40,140)];
        [tableViewButton setAnchorPoint:CGPointZero];
        [tableViewButton setPosition:CGPointMake(40,20)];
		
//		mnuNewGame.scale = 0.8;
		

////////////////////////////////DisplayFPS////////////////////////////////////		
		[[CCDirector sharedDirector] setDisplayFPS:NO];

        

		
	}
	return self;
}


-(void)popPressed:(id)sender
{
    
    
   tableView1 = [[DesignerValuesTableView alloc]init];
   // DesignerValuesTableView *tableView1 = [[DesignerValuesTableView alloc] initWithNibName:@"DesignerValuesTableView" bundle:Nil];
    nav = [[UINavigationController alloc]initWithRootViewController:tableView1];
    
    nav.navigationItem.title = @"TableView";
    
    backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(popped:)];
    
    tableView1.navigationItem.leftBarButtonItem = backButton;
    
    tableDelegate = [CCDirector sharedDirector].openGLView.window.rootViewController;
    
    [tableDelegate presentModalViewController:nav animated:YES];
    
    
}


-(void)popped:(id)sender {
    
     
    [tableDelegate dismissModalViewControllerAnimated:YES];
    tableDelegate = nil;
    [tableView1 release];

}

-(void) TestClick1: (id) sender
{
	
	CCScene *sc=[CCScene node];
	[sc addChild:[[[TestLayer1 alloc]init]autorelease]];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:sc]];

	
	
}

-(void) TestClick2: (id) sender
{

	CCScene *sc=[CCScene node];
	[sc addChild:[[[TestLayer2 alloc]init]autorelease]];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:sc]];


}

-(void) TestClick3: (id) sender
{

	CCScene *sc=[CCScene node];
	[sc addChild:[[[TestLayer3 alloc]init]autorelease]];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:sc]];

	
}




- (void) dealloc
{
    [nav release];
    [tableView release];
	[super dealloc];
}
@end
