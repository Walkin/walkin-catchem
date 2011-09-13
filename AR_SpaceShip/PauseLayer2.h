//
//  PauseLayer2.h
//  AR_SpaceShip
//
//  Created by Zelin Ou on 8/23/11.
//  Copyright (c) 2011 iTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TestScene1.h"
#include <CoreMotion/CoreMotion.h>
#import <CoreFoundation/CoreFoundation.h>


@interface PauseLayer2 : CCLayer {
    
    CCMenuItemImage *mnuBack;
    CCMenuItemImage *mnuBackToMenu;
    CCLabelBMFont *label1;
    CCLabelBMFont *label2;
    CCLabelBMFont *label3;
    CMMotionManager *motionManager;
    
}

@property (nonatomic, retain) CMMotionManager *motionManager;
@property (nonatomic, retain) CCMenuItemImage *mnuBackToMenu;

-(void) GoToTestScene2: (id)sender;
-(void) GoToMainMenuScene: (id)sender;
//-(void) RestartGame:(id)sender;

-(void)checkCatchablePositionYWithRoll:(float)rollPosition;
@end
