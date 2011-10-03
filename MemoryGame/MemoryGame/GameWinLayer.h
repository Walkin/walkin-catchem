//
//  GameWinLayer.h
//  MemoryGame
//
//  Created by Oliver Ou on 11-9-29.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//



#import "cocos2d.h"


@interface GameWinLayer : CCLayer {
    
    CCMenuItemImage *mnuBack;
    CCMenuItemImage *mnuBackToMenu;
    //    CCLabelBMFont *label1;
    
    
}

@property (nonatomic, retain) CCMenuItemImage *mnuBackToMenu;

-(void) GoToGameScene: (id)sender;
-(void) GoToMainMenuScene: (id)sender;

@end
