//
//  BrandSprite.m
//  MemoryGame
//
//  Created by Oliver Ou on 11-9-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BrandSprite.h"
#import "GameScene.h"

@implementation BrandSprite
@synthesize mySprite, theGame;

- (id) init
{
    if((self = [super init]))
    {

        
        mySprite = [CCSprite spriteWithFile:@"brand.png"];

        
    }
    
    return (self);

}


- (void) pop
{
    
    CCSequence *popSequence = [CCSequence actions:[CCScaleTo actionWithDuration:.1 scale:.5], [CCScaleTo actionWithDuration:.1 scale:2], [CCCallFunc actionWithTarget:self selector:@selector(finishedPopSequence)], nil];
    
	[self runAction:popSequence];

}

- (void) finishedPopSequence
{
	self.scale = 1.0;

}

- (void) reset
{

}


@end
