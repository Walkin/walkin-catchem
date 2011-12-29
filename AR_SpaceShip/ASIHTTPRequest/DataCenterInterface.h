//
//  DataCenterInterface.h
//  AR_SpaceShip
//
//  Created by 汉新 康 on 11-12-29.
//  Copyright (c) 2011年 iTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@protocol DataCenterInterface <NSObject>

@required 

-(void)onServerCallbackDictionary:(NSDictionary*)dic;
-(void)onServerCallbackTexure:(CCTexture2D *)texture;

@end
