//
//  ParticleCatchable.h
//  AR_SpaceShip
//
//  Created by Oliver Ou on 11-10-13.
//  Copyright (c) 2011年 Walkin. All rights reserved.
//

#import "Catchable.h"

@interface ParticleCatchable : Catchable
{
    float speed;
    float ratio;
    float timer;
    float progressTimer;
    
    
}


@property (readwrite) float speed;
@property (readwrite) float timer;
@property (readwrite) float ratio;
@property (readwrite) float progressTimer;



@end
