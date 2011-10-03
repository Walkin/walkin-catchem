//
//  GameScene.h
//  MemoryGame
//
//  Created by Oliver Ou on 11-9-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//



#import "cocos2d.h"


@interface GameScene : CCScene {
    
    
}

@end


@interface GameLayer : CCLayer
{
    
    NSMutableArray *brandArray;
    NSMutableArray *questionArray;
    NSMutableArray *pointArray;
    CCMenu *mainMenu;
    CCLabelTTF *question1;
    CCLabelTTF *question2;
    CCLabelTTF *question3;
    int brandID1;
    int brandID2;
    int brandID3;
    int brandID4;
    int brandID5;
    int brandID6;
    int randomIndex;
    
    
}

@property (nonatomic, retain) NSMutableArray *brandArray;
@property (nonatomic, retain) NSMutableArray *questionArray;
@property (nonatomic, retain) NSMutableArray *pointArray;
@property (readwrite) int brandID1;
@property (readwrite) int brandID2;
@property (readwrite) int brandID3;
@property (readwrite) int brandID4;
@property (readwrite) int brandID5;
@property (readwrite) int brandID6;
@property (readwrite) int randomIndex;

-(void)dataInitialize;

-(void)GoToPauseLayer;
-(void)addMenuBackground;
-(void)addAudio;
-(void)presentQuestions;
-(void)addbrands;
-(void)addPositionPoints;
-(void)addProduct;
-(void)changeBackToBrands;
-(void)resetProducts;
-(void)addTouchButtons;
-(void)checkAnswerWithTarget:(CCMenuItemImage*) sender;
-(void)GoBacktoMenu;


@end