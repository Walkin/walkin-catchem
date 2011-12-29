//
//  DataCenter.m
//  AR_SpaceShip
//
//  Created by 汉新 康 on 11-12-29.
//  Copyright (c) 2011年 iTeam. All rights reserved.
//

#import "DataCenter.h"
#import "cocos2d.h"


@implementation DataCenter

@synthesize delegate;

static DataCenter* dc;

+(DataCenter *)sharedDatacenter{
    
    if (!dc) {
        dc = [[DataCenter alloc] init];
    }
    return dc;
}

-(DataCenter*)init{
    
    self = [super init];
    
    NSString* dbpath = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"json"];
    
    NSString* jsonString = [NSString stringWithContentsOfFile:dbpath encoding:NSUTF8StringEncoding error:nil];
    
    jsonParser = [[[SBJsonParser alloc] init] autorelease];
    
    NSDictionary *dic = [jsonParser objectWithString:jsonString];
    
    url = [NSURL URLWithString:[dic objectForKey:@"url"]];
    
    request = [ASIHTTPRequest requestWithURL:url];
    
    [request setDelegate:self];
    
    return self;
}

-(void)sendToHost{
    [request startAsynchronous];
}

-(void)requestFinished:request{
    
    NSDictionary *hdic = [request responseHeaders];
    
    NSString *str = [hdic objectForKey:@"Content-Type"];
    
    NSRange range = [str rangeOfString:@"image"];
    
    if (range.location==0) {
        
        NSData *nsData = [request responseData];
        
        UIImage *img = [UIImage imageWithData:nsData];
        
        CGImageRef *ref = [img CGImage];
        
        NSTimeInterval time=[[NSDate date] timeIntervalSince1970]*1000;
        
        int i=time;
        
        NSLog(@"texture name %i",i);
        
        CCTexture2D *text = [[CCTextureCache sharedTextureCache] addCGImage:ref forKey:[NSString stringWithFormat:@"%i.png",i]];
        
        [self.delegate onServerCallbackTexure:text];
        
        
    }else{
        
        NSString *responsString = [request responseString];
        
        NSDictionary *dic = [jsonParser objectWithString:responsString]; 
        
        [self.delegate onServerCallbackDictionary:dic];
        
    }
    
    
}


@end
