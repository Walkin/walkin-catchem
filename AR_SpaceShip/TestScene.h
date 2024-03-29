//
//  TestScene.h
//  AR_SpaceShip
//
//  Created by Zelin Ou on 8/11/11.
//  Copyright 2011 Walkin. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>
#import <CoreFoundation/CoreFoundation.h>
#import "cocos2d.h"


#define kXPositionMultiplier 15
#define kYPositionMultiplier 15


@class Catchable;


@interface TestScene : CCScene {



}

@end

@interface TestLayer: CCLayer {
    
    CMMotionManager *motionManager;
    CCLabelTTF *yawLabel;
    CCLabelTTF *rollLabel;
    CCLabelTTF *posIn360Label;
    CCLabelTTF *posIn180Label;
    CCLabelTTF *winCondition;
  //  NSMutableArray *catchableSprites;

    CCMenu *aboutmenu;
    CCMenuItemImage *mnuBack;
    CCMenuItemImage *mnuChange;
    CCMenuItemImage *mnuScaleBig;
    CCMenuItemImage *mnuScaleSmall;
    CCMenuItemImage *mnuCapture;
    CCMenuItemImage *mnuMatch;

    
    int catchableCount;
    int score;
    int count;
    CCLabelTTF *scoreLabel;
    CCSprite *scope;
    CCSprite *radar;
    
    int CombinedCatchemCount;
    int StableCatchableCount;
    float MaximumYaw;
    BOOL enableTouch;
    BOOL playTouchSound;
    BOOL pauseGame;
    float yaw;
    float roll;
    float updateYaw;
    int changePic;


}

-(Catchable *)addCombinedCatchable:(int)shipTag; 
-(Catchable *)addParticleCatchable:(int)shipTag; 
-(Catchable *)addStableCatchable:(int)shipTag; 
-(void)dataInitialize;
-(void)update:(ccTime)delta;
-(void)ScoreUpdate;
-(void)GoToPauseLayer;
-(void)checkCatchablePositionX:(Catchable *)Catchable withYaw:(float)yawPosition;
-(void)checkCatchablePositionY:(Catchable *)Catchable withRoll:(float)rollPosition;
-(void)updateCatchablePositionX:(float)positionInX360 withEnemy:(Catchable *)Catchable;
-(void)updateCatchablePositionY:(float)positionInY360 withEnemy:(Catchable *)Catchable;
-(void)runStandardPositionXCheck:(float)positionInX360 withDiff:(float)difference withEnemy:(Catchable *)Catchable;
-(void)runStandardPositionYCheck:(float)positionInY360 withDiff:(float)difference withEnemy:(Catchable *)Catchable;
- (BOOL) circle:(CGPoint) circlePoint withRadius:(float) radius collisionWithCircle:(CGPoint) circlePointTwo collisionCircleRadius:(float) radiusTwo;
-(void)removeSprite:(CCNode *)n;
-(void)removeSpriteAndAddCatchemSpritesBegin:(CCNode *)n;
-(void)startGame;
-(void)addMenuItems;
-(void)presentCoreMotionData;
-(void)addScopeCrosshairs;
-(void)addAudio;
-(void)addScoreLabel;
-(void)addRadar;
-(void)presentWinCondition;
-(void)ChangeCloths: (id) sender;
-(void)ScaleBig: (id) sender;
-(void)ScaleSmall: (id) sender;
-(void)captureScreen: (id) sender;
-(void)MatchCamera: (id) sender;
-(void)HideItemsBeforeCapture;
-(void)TakePictures;
-(void)ShowItemsAfterCapture;
-(void)TakePicturesWarning;


@property (nonatomic, retain) CMMotionManager *motionManager;
@property (readwrite) int catchableCount;
@property (readwrite) int score;
@property (readwrite) int count;
@property (readwrite) int CombinedCatchemCount;
@property (readwrite) int StableCatchableCount;
@property (readwrite) float MaximumYaw;
@property (readwrite) BOOL enableTouch;
@property (readwrite) BOOL playTouchSound;
@property (readwrite) float yaw;
@property (readwrite) float roll;
@property (readwrite) BOOL pauseGame;
@property (readwrite) float updateYaw;
//@property (nonatomic, retain) NSMutableArray *catchableSprites;

@end