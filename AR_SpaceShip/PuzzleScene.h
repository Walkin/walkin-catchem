//
//  PuzzleScene.h
//  AR_SpaceShip
//
//  Created by 汉新 康 on 11-12-23.
//  Copyright 2011年 iTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "DataCenter.h"
#import "SpriteTouchInterface.h"

@interface PuzzleScene : CCLayer <SpriteTouchInterface>{
    int widthPics;
    
    int heightPics;
    
    NSMutableArray *imgs;
    
    BOOL allowTouch;
    
    DataCenter *dc;
}

@property BOOL allowTouch;

+(CCScene*)scene;

-(id)init;


@end
