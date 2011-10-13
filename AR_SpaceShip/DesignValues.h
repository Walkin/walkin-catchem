//
//  DesignValues.h
//  AR_SpaceShip
//
//  Created by Zelin Ou on 8/26/11.
//  Copyright (c) 2011 iTeam. All rights reserved.
//

#import "cocos2d.h"
#import <Foundation/Foundation.h>


@interface DesignValues : NSObject
{

    NSDictionary *temp;
    NSMutableArray *orderedKeys;
    NSMutableArray *catchableSprites;
    NSMutableArray *orderedValues;
    int FloaterCombined;
    int ParticleCatchable;
    float MaximumYaw;
    float MinimumYaw;
    float UpdateFrequency;
    float EnableCatchTimer;
    float yaw;
    float roll;


}


+(DesignValues *)sharedDesignValues;
- (int)getFloaterCombined;
- (int)getParticleCatchable;
- (float)getMaximumYaw;
- (float)getMinimumYaw;
- (float)getUpdateFrequency;
- (float)getEnableCatchTimer;
- (float)getYaw;
- (float)getRoll;


@property(nonatomic,retain) NSDictionary *temp;
@property(nonatomic,retain) NSMutableArray *orderedKeys;
@property(nonatomic,retain) NSMutableArray *orderedValues;
@property(nonatomic,retain) NSMutableArray *catchableSprites;
@property(readwrite) int FloaterCombined;
@property(readwrite) int ParticleCatchable;
@property(readwrite) float MaximumYaw;
@property(readwrite) float MinimumYaw;
@property(readwrite) float UpdateFrequency;
@property(readwrite) float EnableCatchTimer;
@property(readwrite) float yaw;
@property(readwrite) float roll;


@end
