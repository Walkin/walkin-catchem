//
//  PuzzleScene.m
//  AR_SpaceShip
//
//  Created by Eric Kang on 11-12-23.
//  Copyright 2011年 iTeam. All rights reserved.
//

#import "PuzzleScene.h"
#import "PuzzleSprite.h"
#import "DataCenter.h"



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
        
        widthPics = 3;
        
        heightPics = 3;
        
        NSDictionary *d1 = [NSDictionary dictionary];
        
        DataCenter *dc = [DataCenter sharedDatacenter];
        
        NSDictionary *d2 = [NSDictionary dictionaryWithObject:@"aa" forKey:@"b"];
        
        [dc requestServer:@"puzzleConfig" dic:d1];
        //[dc requestServer:d2];
        
//        NSURL *url = [NSURL URLWithString:@"http://png.52design.com/caisheico/pic/png_52design_caishe_18.png"];
//        
//        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
//        
//        [request setDelegate:self];
//        
//        [request startAsynchronous];
        
        
    }
    
    return self;
}

-(void)onServerCallbackDictionary:(NSDictionary*)dic{
    
    NSString *str = [dic objectForKey:@"url"];
    
    NSLog(str);
    
}


-(void)initPicture:(CCTexture2D *)catch {
    
    
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
