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
@synthesize queue;

static DataCenter* dc;

+(DataCenter *)sharedDatacenter{
    
    if (!dc) {
        dc = [[[DataCenter alloc] init] retain];
    }
    return dc;
}

-(DataCenter*)init{
    
    self = [super init];
    
    NSString* dbpath = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"json"];
    
    NSString* jsonString = [NSString stringWithContentsOfFile:dbpath encoding:NSUTF8StringEncoding error:nil];
    
    jsonParser = [[SBJsonParser alloc] init] ;
    
    NSDictionary *dic = [jsonParser objectWithString:jsonString];
    
    url = [NSURL URLWithString:[dic objectForKey:@"url"]];
    
    return self;
}


-(void)requestData:(NSString *) picurl{
    
    if (![self queue]) {
        [self setQueue:[[NSOperationQueue alloc] init] ];
        
    }
    
    NSURL *paramurl = [NSURL URLWithString:picurl];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:paramurl] ;
    
    [request setDelegate:self];
    
    [request setDidFinishSelector:@selector(requestDone:)];
    
    [request setDidFailSelector:@selector(requestWentWrong:)];
    
    [[self queue] addOperation:request];
}

-(void)requestServer:(NSString *) action dic:(NSDictionary *)dic{
    
    NSArray *keys;
    int i, count;
    id key, value;
    
    keys = [dic allKeys];
    count = [keys count];
    
    NSString *param =[NSString stringWithFormat:@"%@?action=%@",url,action];
    
    for (i = 0; i < count; i++)
    {
        key = [keys objectAtIndex: i];
        value = [dic objectForKey: key];
        
        param = [NSString stringWithFormat:@"%@&%@=%@",param,key,value];
        
    }
    
    
    [self requestData:param];
    
}


-(void)requestDone:(ASIHTTPRequest *)request{
    
    NSDictionary *hdic = [request responseHeaders];
    
    NSString *str = [hdic objectForKey:@"Content-Type"];
    
    NSRange range = [str rangeOfString:@"image"];
    
    if (range.location==0) {
        
        NSData *nsData = [request responseData];
        
        UIImage *img = [UIImage imageWithData:nsData];
        
        CGImageRef *ref = [img CGImage];
        
        int i=arc4random()%10000;
        
        NSLog(@"texture name %d",i);
        
        CCTexture2D *text = [[CCTextureCache sharedTextureCache] addCGImage:ref forKey:[NSString stringWithFormat:@"%d.png",i]];
        
        [self.delegate onServerCallbackTexure:text];
        
        
    }else{
        
        NSString *responsString = [request responseString];
        
        
        NSString *rsstr = [NSString stringWithFormat:@"%@",responsString];
        
        NSDictionary *dic = [jsonParser objectWithString:rsstr]; 
        
        [self.delegate onServerCallbackDictionary:dic];
        
    }
    
    
}


- (void)requestWentWrong:(ASIHTTPRequest *)request
{
    
    NSError *error = [request error];   
    
}

@end
