//
//  SpriteTouchInterface.h
//  AR_SpaceShip
//
//  Created by 汉新 康 on 11-12-27.
//  Copyright (c) 2011年 iTeam. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol SpriteTouchInterface <NSObject>

@required

-(void)onTouchend:(id*) plsprite;
-(void)checkFinish;


@end
