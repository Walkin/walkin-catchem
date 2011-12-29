//
//  DataCenter.h
//  AR_SpaceShip
//
//  Created by 汉新 康 on 11-12-29.
//  Copyright (c) 2011年 iTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "DataCenterInterface.h"

@interface DataCenter : NSObject{
    NSURL *url;
    ASIHTTPRequest *request;
    id<DataCenterInterface> *delegate;
    SBJsonParser* jsonParser;
}

@property id<DataCenterInterface> *delegate;

-(DataCenter *)init;

+(DataCenter*)sharedDatacenter;

//-(void)

@end
