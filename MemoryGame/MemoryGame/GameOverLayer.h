//
//  GameOverLayer.h
//  MemoryGame
//
//  Created by Oliver Ou on 11-9-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"


@interface GameOverLayer : CCLayer {
    
    CCMenuItemImage *mnuBack;
    CCMenuItemImage *mnuBackToMenu;
    //    CCLabelBMFont *label1;

    
}

@property (nonatomic, retain) CCMenuItemImage *mnuBackToMenu;

-(void) GoToGameScene: (id)sender;
-(void) GoToMainMenuScene: (id)sender;

@end
