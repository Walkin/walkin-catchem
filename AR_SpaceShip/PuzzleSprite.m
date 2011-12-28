//
//  PuzzleSprite.m
//  AR_SpaceShip
//
//  Created by 汉新 康 on 11-12-27.
//  Copyright 2011年 iTeam. All rights reserved.
//

#import "PuzzleSprite.h"
#import "PuzzleScene.h"

@implementation PuzzleSprite

@synthesize delegate;
@synthesize isSelected;
@synthesize origPos;



-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    
    PuzzleScene *scene = (PuzzleScene*)self.delegate;
    
    if (!scene.allowTouch) {
        return NO;
    }
    
    if ( ![self containsTouchLocation:touch] )   
    {  
        return NO;  
    } 
    
    return YES;
}
-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{

}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    
    if (isSelected) {
        isSelected = NO;
        
        [self removeChild:frame cleanup:NO];
        
    }else{
        isSelected = YES;
        [self.delegate onTouchend:self];
        
        [self addChild:frame];
        
    }
    
}
-(PuzzleSprite*)initPuzzleSprite:(CCTexture2D *)texture row:(int)row col:(int)col spWidth:(float)spWidth spHeight:(float)spHeight{
    
    img = [CCSprite spriteWithTexture:texture rect:CGRectMake(row*spWidth, col*spHeight, spWidth, spHeight)];
    img.position = ccp(0,0);
    [self addChild:img];
    
    [self initFrame:spWidth spHeight:spHeight];
    
    return self;
}



-(void)onEnter{
    [super onEnter];
    isSelected = NO;
    
    [[CCTouchDispatcher sharedDispatcher]  addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(void)initFrame:(float)spWidth spHeight:(float)spHeight{
    
    frame = [CCNode new];
    
    CCSprite *lt = [CCSprite spriteWithFile:@"left_top.png"];
    
    float ltx = -spWidth/2+[lt contentSize].width/2;
    float lty = spHeight/2 - [lt contentSize].height/2;
    
    lt.position = ccp(ltx,lty);
    
    
    CCSprite *rt = [CCSprite spriteWithFile:@"right_top.png"];
    
    float rtx = spWidth/2-[rt contentSize].width/2;
    float rty = spHeight/2 - [rt contentSize].height/2;
    
    rt.position = ccp(rtx,rty);
    
    CCSprite *lb = [CCSprite spriteWithFile:@"left_bottom.png"];
    
    float lbx = -spWidth/2+[lb contentSize].width/2;
    float lby = -spHeight/2 + [lb contentSize].height/2;
    
    lb.position = ccp(lbx,lby);
    
    CCSprite *rb = [CCSprite spriteWithFile:@"right_bottom.png"];
    
    float rbx = spWidth/2-[rb contentSize].width/2;
    float rby = -spHeight/2 + [rb contentSize].height/2;
    
    rb.position = ccp(rbx,rby);
    
    [frame addChild:lt];
    [frame addChild:lb];
    [frame addChild:rt];
    [frame addChild:rb];
    
    frame.position = ccp(0,0);
    
}

- (CGRect)rect  
{  
    CGSize s = [img contentSize];  
    return CGRectMake(-s.width / 2, -s.height / 2, s.width, s.height);  
}  

- (BOOL)containsTouchLocation:(UITouch *)touch  
{  
    return CGRectContainsPoint(self.rect, [self convertTouchToNodeSpaceAR:touch]);  
}  

-(void)moveFinish{
    
    self.isSelected = NO;
    
    [self removeChild:frame cleanup:NO];
    
    
    PuzzleScene *scene = (PuzzleScene*)self.delegate;
    scene.allowTouch = YES;
    
    [self.delegate checkFinish];
    
}

@end
