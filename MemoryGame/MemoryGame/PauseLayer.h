//
//  PauseLayer.h
//  AR_SpaceShip
//
//  Created by Zelin Ou on 8/10/11.
//  Copyright 2011 iTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameScene.h"


@interface PauseLayer : CCLayer {

    CCMenuItemImage *mnuBack;
    CCMenuItemImage *mnuBackToMenu;
//    CCLabelBMFont *label1;



}

@property (nonatomic, retain) CCMenuItemImage *mnuBackToMenu;

-(void) GoToGameScene: (id)sender;
-(void) GoToMainMenuScene: (id)sender;

@end
