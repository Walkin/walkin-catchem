//
//  PuzzleScene.m
//  AR_SpaceShip
//
//  Created by Eric Kang on 11-12-23.
//  Copyright 2011年 iTeam. All rights reserved.
//

#import "PuzzleScene.h"
#import "PuzzleSprite.h"
#import "JSON.h"



@implementation PuzzleScene

@synthesize allowTouch;

+(CCScene*)scene{
    
    CCScene *scene = [CCScene node];
    
    PuzzleScene *layer = [PuzzleScene node];
    
    [scene addChild:layer];
    
    return scene;
}

-(id)init{
    
    if (self=[super init]) {
        
        allowTouch = YES;
        
        
        NSString* dbpath = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"json"];
        
        NSString* jsonString = [NSString stringWithContentsOfFile:dbpath encoding:NSUTF8StringEncoding error:nil];
        
        SBJsonParser* jsonParser = [[[SBJsonParser alloc] init] autorelease];
        
        NSDictionary *dic = [jsonParser objectWithString:jsonString];
        
        
        widthPics = [[dic objectForKey:@"widthPics"] intValue];
        heightPics = [[dic objectForKey:@"heightPics"] intValue];
        NSString *imgPath = [dic objectForKey:@"imgPath"] ;// @"pic_demo.jpg";
        
        CCTexture2D *catch = [[CCTextureCache sharedTextureCache] addImage:imgPath];
        imgs = [[ NSMutableArray  arrayWithCapacity:1] retain];
        CGSize imgSize = [catch contentSize];
        
        float spWidth = imgSize.width/widthPics;
        float spHeight = imgSize.height/heightPics;
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CGPoint center = ccp(winSize.width/2,winSize.height/2);
        
        
        for (int i=0; i<widthPics; i++) {
            
            for (int j=0; j<heightPics; j++) {
                
                PuzzleSprite *sp = [[PuzzleSprite new] initPuzzleSprite:catch row:i col:j spWidth:spWidth spHeight:spHeight];
                
                sp.delegate = self;
                
                float tempWidth = center.x - ((widthPics/2)*spWidth);
                
                if (widthPics%2==0) {
                    tempWidth = tempWidth + spWidth/2 ;
                }
                
                float tempHeight = center.y + ((heightPics/2)*spHeight);
                
                if (heightPics%2==0) {
                    tempHeight = tempHeight- spHeight/2;
                }
                
                float posx = tempWidth + i*spWidth;
                
                float posy = tempHeight - j*spHeight;                
                
                sp.position = ccp(posx,posy);
                
                sp.origPos = ccp(posx,posy);
                
                [imgs addObject:sp];
                
                [self addChild:sp];
                
            }
        }
        
        [self reArrageSp];
        
    }
    
    return self;
}

-(void)reArrageSp{
    
    for (int i = 0; i<widthPics*heightPics+1; i++) {
        
        int num1 = arc4random()%(widthPics*heightPics);
        int num2 = arc4random()%(widthPics*heightPics);
        
        PuzzleSprite *sp1 =  (PuzzleSprite*)[imgs objectAtIndex:num1];
        PuzzleSprite *sp2 =  (PuzzleSprite*)[imgs objectAtIndex:num2];
        
        CGPoint temp = sp2.position;
        
        sp2.position = sp1.position;
        
        sp1.position = temp;
    }
}


-(void)onTouchend:(id *)plsprite{

    PuzzleSprite *sp = (PuzzleSprite*)plsprite;
    
    for (int i=0; i<[imgs count]; i++) {
        PuzzleSprite *img = (PuzzleSprite*)[imgs objectAtIndex:i];
        if (img!=sp && img.isSelected) {
            
            self.allowTouch = NO;
            
            CGPoint posSp = img.position;
            
            CGPoint posImg = sp.position;
            
            CCAction *spmove = [CCMoveTo actionWithDuration:0.1 position:posSp];
            
            CCCallFunc *spfunc = [CCCallFunc actionWithTarget:sp selector:@selector(moveFinish)];
            
            CCSequence *spSeq = [CCSequence actions:spmove ,spfunc,nil ];
            
            [sp runAction:spSeq];
            
            
            CCAction *imgmove = [CCMoveTo actionWithDuration:0.1 position:posImg];
            
            CCCallFunc *imgfunc = [CCCallFunc actionWithTarget:img selector:@selector(moveFinish)];
            
            CCSequence *imgSeq = [CCSequence actions:imgmove , imgfunc, nil];
            
            [img runAction:imgSeq];
            
            
            break;
        }
    }
    
}

-(void)checkFinish{
    
    for (int i=0 ; i<[imgs count] ; i++) {
        PuzzleSprite *img = (PuzzleSprite*)[imgs objectAtIndex:i];
        if (img.position.x == img.origPos.x && img.position.y==img.origPos.y) {
            if (i==([imgs count]-1)) {
                [self onFinish];
            }
            continue;
        }else{
            break;
        }
    }
}

-(void)onFinish{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You Win" delegate:self cancelButtonTitle:@"RePlay" otherButtonTitles: nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    [self reArrageSp];
}

@end
