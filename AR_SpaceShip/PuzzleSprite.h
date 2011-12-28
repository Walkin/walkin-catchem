//
//  PuzzleSprite.h
//  AR_SpaceShip
//
//  Created by 汉新 康 on 11-12-27.
//  Copyright 2011年 iTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SpriteTouchInterface.h"

@interface PuzzleSprite : CCNode <CCTargetedTouchDelegate>{
    BOOL isSelected;
    CCSprite *img;
    CCNode *frame;
    CGPoint origPos;
    id<SpriteTouchInterface> *delegate;
}


@property id<SpriteTouchInterface> *delegate;
@property BOOL isSelected;
@property CGPoint origPos;

-(PuzzleSprite*)initPuzzleSprite:(CCTexture2D *)texture row:(int)row col:(int)col spWidth:(float)spWidth spHeight:(float)spHeight;

-(void)initFrame:(float)spWidth spHeight:(float)spHeight;

-(void)moveFinish;

@end
