//
//  DesignValues.h
//  AR_SpaceShip
//
//  Created by Zelin Ou on 8/26/11.
//  Copyright (c) 2011 iTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DesignValues : NSObject
{

    NSDictionary *temp;
    NSMutableArray *catchableSprites;
}

@property (nonatomic,retain) NSDictionary *temp;


+(DesignValues *)sharedDesignValues;
- (int)getFloaterCombined;
- (float)getMaximumYaw;
- (float)getMinimumYaw;

@property(nonatomic,retain) NSDictionary *temp;
@property(nonatomic,retain) NSMutableArray *orderedKeys;
@property(nonatomic,retain) NSMutableArray *orderedValues;
@property(nonatomic,retain) NSMutableArray *catchableSprites;
@property(readwrite) int FloaterCombined;
@property(readwrite) float MaximumYaw;
@property(readwrite) float MinimumYaw;

@end
