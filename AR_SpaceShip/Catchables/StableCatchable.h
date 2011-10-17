//
//  StableCatchable.h
//  AR_SpaceShip
//
//  Created by Oliver Ou on 11-9-21.
//  Copyright 2011年 Walkin. All rights reserved.
//


#import "Catchable.h"


@interface StableCatchable : Catchable 
{
    float speed;
    
    float timer;
    float progressTimer;

    
    
}

-(void)resetRandomMovement;

@property (readwrite) float speed;
@property (readwrite) float timer;
@property (readwrite) float progressTimer;



@end
