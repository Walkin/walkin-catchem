//
//  BrandSprite.h
//  MemoryGame
//
//  Created by Oliver Ou on 11-9-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
@class GameLayer;


@interface BrandSprite : CCNode 

{
   	CCSprite * mySprite;
	GameLayer * theGame;


}


@property(nonatomic,retain) CCSprite * mySprite;
@property(nonatomic,retain) GameLayer * theGame;

//-(id) initWithGame:(GameLayer*) game;
- (void) pop;
- (void) reset;
- (void) finishedPopSequence;

@end
