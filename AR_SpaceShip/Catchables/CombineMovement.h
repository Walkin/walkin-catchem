//
//  CombineMovement.h
//  FunnyShake
//
//  Created by Zelin Ou on 7/21/11.
//  Copyright 2011 Walkin. All rights reserved.
//

#import "Catchable.h"

@interface CombineMovement : Catchable
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
