//
//  CombineMovement.h
//  FunnyShake
//
//  Created by Zelin Ou on 7/21/11.
//  Copyright 2011 iTeam. All rights reserved.
//

#import "Catchable.h"

@interface CombineMovement : Catchable
{
    float speed;
    
    float timer;
    float progressTimer;

}

-(void)resetRandomMovement;


@end
