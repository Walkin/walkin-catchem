//
//  GameScene.m
//  MemoryGame
//
//  Created by Oliver Ou on 11-9-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "GameOverLayer.h"
#import "GameWinLayer.h"
#import "MenuScene.h"

#define kMenuBackgroundZ -1
#define kMenuItemsZ 1

@implementation GameScene


- (id)init
{
    self = [super init];
    if (self) {
        
       [self addChild:[GameLayer node] z:0 ];
    }
    
    return self;
}

-(void) dealloc
{
	[super dealloc];
}


@end



@implementation GameLayer
@synthesize brandArray;
@synthesize questionArray;
@synthesize pointArray;
@synthesize brandID1;
@synthesize brandID2;
@synthesize brandID3;
@synthesize brandID4;
@synthesize brandID5;
@synthesize brandID6;
@synthesize randomIndex;




-(id) init
{
	
	if( (self=[super init] )) {
        
        [[CCDirector sharedDirector]setDeviceOrientation:CCDeviceOrientationPortrait];
        
//        /////////////////////////////Create the pause layer//////////////////////////////
//        p = [[[PauseLayer alloc]init]autorelease];
//        [self addChild:p z:10];
//        p.visible = NO;
//        [p.mnuBackToMenu setIsEnabled:NO];
        
        [self dataInitialize];
        
        [self addMenuBackground];
        
        [self addPositionPoints];
        
        [self resetProducts];
        
        [self addbrands];
        
        [self addTouchButtons];
		
		[[CCDirector sharedDirector] setDisplayFPS:NO];

        [self addAudio];



        
	}
	return self;
}

-(void)GoBacktoMenu
{
    CCScene *sc=[CCScene node];
    [sc addChild:[[[MenuLayer alloc]init]autorelease]];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:sc]];

}

-(void)resetProducts
{

/////////////////////////Reset the position of the points in the array////////////////
    int firstObject = 0;
    
    for (int i = 0; i<[self.pointArray count];i++) {
        int randomNum = random() % [self.pointArray count];
        [self.pointArray exchangeObjectAtIndex:firstObject withObjectAtIndex:randomNum];
        firstObject +=1;
		
    }
    
}


-(void)addPositionPoints
{
    
    self.pointArray = [NSMutableArray arrayWithObjects:
                       [NSValue valueWithCGPoint:CGPointMake(60.0, 160.0)],
                       [NSValue valueWithCGPoint:CGPointMake(210.0, 160.0)],
                       [NSValue valueWithCGPoint:CGPointMake(360.0, 160.0)],
                       [NSValue valueWithCGPoint:CGPointMake(60.0, 40.0)],
                       [NSValue valueWithCGPoint:CGPointMake(210.0, 40.0)],
                       [NSValue valueWithCGPoint:CGPointMake(360.0, 40.0)],
                       nil];
    
}

-(void)addbrands
{

    brandArray = [[NSMutableArray alloc] init];

    for (int i = 0; i< 6; i++) {
        
        CCSprite *brand = [[CCSprite alloc]initWithFile:@"brand.png"];
        
        brand.anchorPoint = CGPointZero;
        
        NSValue *val = [self.pointArray objectAtIndex:i];
        CGPoint p = [val CGPointValue];
        brand.position = p;
        
        [brandArray addObject:brand];
        
        [self addChild:brand z:3];
    }
    
    [self schedule:@selector(addProduct) interval:1.0];
}

-(void)addProduct
{
    [self unschedule:@selector(addProduct)];
    
    for (int i = 0; i< [brandArray count]; i++) {
        
        NSString *image = [NSString stringWithFormat:@"product_00%d.png", i+1];
        
        [[brandArray objectAtIndex:i] setTexture:[[CCTextureCache sharedTextureCache] addImage:image]];

    }
    
    [self schedule:@selector(changeBackToBrands) interval:3.0];
    
}

-(void)changeBackToBrands
{
    [self unschedule:@selector(changeBackToBrands)];
    
    [mainMenu setVisible:YES];
    
    [self presentQuestions];
    
    for (int i = 0; i< [brandArray count]; i++) {
        
        NSString *image = [NSString stringWithFormat:@"brand.png"];
        
        [[brandArray objectAtIndex:i] setTexture:[[CCTextureCache sharedTextureCache] addImage:image]];
        
    }


}

-(void)presentQuestions
{
    
    question1 = [CCLabelTTF labelWithString:@"Where is the shoes? " fontName:@"Marker Felt" fontSize:20];
    question1.position = ccp(250, 280);
    
    question2 = [CCLabelTTF labelWithString:@"Where is the clothes? " fontName:@"Marker Felt" fontSize:20];
    question2.position = ccp(250, 280);
    
    question3 = [CCLabelTTF labelWithString:@"Where is the jewelry? " fontName:@"Marker Felt" fontSize:20];
    question3.position = ccp(250, 280);

    
    questionArray = [NSMutableArray arrayWithObjects:question1,question2,question3, nil];
    

    randomIndex = random() % [questionArray count]+1;
    
    NSLog(@"The randomIndex is %d", randomIndex);

    switch (randomIndex) {
        case 1:
            [self addChild:question1 z:2 tag:brandID3];
            break;
                
        case 2:
            [self addChild:question2 z:2 tag:brandID1];
            break;
                
        case 3:    
            [self addChild:question3 z:2 tag:brandID4];
            break;
                
        default:
            break;

    }
    
}

-(void)addMenuBackground
{
    ////////////////////////////////Menu Background////////////////////////////////////
    
    CCSprite *menubg = [CCSprite spriteWithFile:@"background.png"];
    menubg.anchorPoint = CGPointZero;
    menubg.position = CGPointZero;
    [self addChild:menubg z:kMenuBackgroundZ];
    
}

-(void)addTouchButtons
{
    mainMenu = [CCMenu menuWithItems:nil];
    [mainMenu setAnchorPoint:CGPointZero];
    [mainMenu setPosition:CGPointZero];

    
    for (int i=0; i < 6 ; i++) {
        
        CCMenuItemImage *button = [CCMenuItemImage itemFromNormalImage:@"brand.png"
                                                         selectedImage:NULL
                                                                target:self 
                                                              selector:@selector(checkAnswerWithTarget:)];
        
        NSValue *val = [self.pointArray objectAtIndex:i];
        CGPoint p = [val CGPointValue];
        
        [button setAnchorPoint:CGPointZero];
        [button setPosition:p];

        [mainMenu addChild:button z:4 tag:i+1];
        
    }
    
    
    [self addChild:mainMenu z:4];
    [mainMenu setVisible:NO];

}

-(void)checkAnswerWithTarget:(CCMenuItemImage*) sender
{
    NSLog(@"My id is %d", sender.tag);
    
    
    switch (randomIndex) {
        case 1:
            
            if (sender.tag == question1.tag ) {
                
                NSLog(@"You are right!");
                
                    CCScene *sc=[CCScene node];
                    [sc addChild:[[[GameWinLayer alloc]init]autorelease]];
                    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:sc]];
                
            } else
            {
                NSLog(@"You are wrong!");
                
                CCScene *sc=[CCScene node];
                [sc addChild:[[[GameOverLayer alloc]init]autorelease]];
                [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:sc]];
            }
            
            break;
            
        case 2:
            
            if (sender.tag == question2.tag ) {
                
                NSLog(@"You are right!");
                
                CCScene *sc=[CCScene node];
                [sc addChild:[[[GameWinLayer alloc]init]autorelease]];
                [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:sc]];
                
                
            } else
            {
                NSLog(@"You are wrong!");
                
                CCScene *sc=[CCScene node];
                [sc addChild:[[[GameOverLayer alloc]init]autorelease]];
                [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:sc]];
            }
            
            break;
            
        case 3:
            
            if (sender.tag == question3.tag ) {
                
                NSLog(@"You are right!");
                
                CCScene *sc=[CCScene node];
                [sc addChild:[[[GameWinLayer alloc]init]autorelease]];
                [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:sc]];
                
                
            } else
            {
                NSLog(@"You are wrong!");
                
                CCScene *sc=[CCScene node];
                [sc addChild:[[[GameOverLayer alloc]init]autorelease]];
                [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:sc]];
            }
            
            break;
            
        default:
            break;
    }
    
}


-(void)dataInitialize
{

    brandID1 = 1;
    brandID2 = 2;
    brandID3 = 3;
    brandID4 = 4;
    brandID5 = 5;
    brandID6 = 6;

}


-(void)GoToPauseLayer
{

}


-(void)addAudio
{

}


- (void) dealloc
{
    
	[super dealloc];
}

@end